import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:couple_schedule_app/core/network/auth_interceptor.dart';
import 'package:couple_schedule_app/core/storage/token_storage.dart';
import 'package:couple_schedule_app/features/auth/data/datasources/auth_api.dart';
import 'package:couple_schedule_app/features/auth/data/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryTokenStorage extends TokenStorage {
  String? accessToken = 'old-access';
  String? refreshToken = 'old-refresh';
  int deletions = 0;

  @override
  Future<String?> getAccessToken() async => accessToken;
  @override
  Future<String?> getRefreshToken() async => refreshToken;
  @override
  Future<void> saveAccessToken(String token) async => accessToken = token;
  @override
  Future<void> saveRefreshToken(String token) async => refreshToken = token;
  @override
  Future<void> deleteToken() async {
    deletions++;
    accessToken = null;
    refreshToken = null;
  }
}

class TestAdapter implements HttpClientAdapter {
  TestAdapter(this.respond);
  final Future<ResponseBody> Function(RequestOptions options) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

void main() {
  late MemoryTokenStorage storage;
  late Dio apiDio;
  late Dio refreshDio;
  late AuthRepository repository;

  setUp(() {
    storage = MemoryTokenStorage();
    apiDio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    refreshDio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    apiDio.interceptors.add(
      AuthInterceptor(storage, AuthApi(dio: refreshDio), apiDio),
    );
    repository = AuthRepository(
      authApi: AuthApi(dio: apiDio),
      tokenStorage: storage,
    );
  });

  tearDown(() {
    apiDio.close(force: true);
    refreshDio.close(force: true);
  });

  test(
    'refresh success retries the original request with the new token',
    () async {
      final headers = <String?>[];
      apiDio.httpClientAdapter = TestAdapter((options) async {
        final authorization = options.headers['Authorization'] as String?;
        headers.add(authorization);
        return authorization == 'Bearer old-access'
            ? jsonResponse(401, 'expired')
            : jsonResponse(200, {
                'id': 1,
                'email': 'a@example.com',
                'nickname': 'a',
                'inviteCode': 'ABCDEFGH',
              });
      });
      refreshDio.httpClientAdapter = TestAdapter((options) async {
        expect(options.path, '/api/users/refresh');
        return jsonResponse(200, {
          'accessToken': 'new-access',
          'refreshToken': 'new-refresh',
        });
      });

      expect(await repository.checkAuthLogin(), isTrue);
      expect(headers, ['Bearer old-access', 'Bearer new-access']);
      expect(storage.accessToken, 'new-access');
      expect(storage.refreshToken, 'new-refresh');
    },
  );

  test('refresh 401 clears tokens and rejects automatic login', () async {
    apiDio.httpClientAdapter = TestAdapter(
      (_) async => jsonResponse(401, 'expired'),
    );
    refreshDio.httpClientAdapter = TestAdapter(
      (_) async => jsonResponse(401, 'invalid refresh'),
    );

    expect(await repository.checkAuthLogin(), isFalse);
    expect(storage.accessToken, isNull);
    expect(storage.refreshToken, isNull);
    expect(storage.deletions, 1);
  });

  test(
    'missing refresh token rejects automatic login without deleting tokens',
    () async {
      storage.refreshToken = null;
      apiDio.httpClientAdapter = TestAdapter(
        (_) async => jsonResponse(401, 'expired'),
      );
      refreshDio.httpClientAdapter = TestAdapter(
        (_) async => fail('unexpected refresh'),
      );

      expect(await repository.checkAuthLogin(), isFalse);
      expect(storage.accessToken, 'old-access');
      expect(storage.deletions, 0);
    },
  );

  for (final type in [
    DioExceptionType.connectionError,
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
  ]) {
    test('refresh $type preserves tokens and propagates the error', () async {
      apiDio.httpClientAdapter = TestAdapter(
        (_) async => jsonResponse(401, 'expired'),
      );
      refreshDio.httpClientAdapter = TestAdapter((options) async {
        throw DioException(requestOptions: options, type: type);
      });

      await expectLater(
        repository.checkAuthLogin(),
        throwsA(isA<DioException>().having((e) => e.type, 'type', type)),
      );
      expect(storage.accessToken, 'old-access');
      expect(storage.refreshToken, 'old-refresh');
      expect(storage.deletions, 0);
    });
  }

  test('refresh 500 is propagated without deleting tokens', () async {
    apiDio.httpClientAdapter = TestAdapter(
      (_) async => jsonResponse(401, 'expired'),
    );
    refreshDio.httpClientAdapter = TestAdapter(
      (_) async => jsonResponse(500, 'server error'),
    );
    await expectLater(
      repository.checkAuthLogin(),
      throwsA(
        isA<DioException>()
            .having((e) => e.requestOptions.path, 'path', '/api/users/refresh')
            .having((e) => e.response?.statusCode, 'status', 500),
      ),
    );
    expect(storage.accessToken, 'old-access');
    expect(storage.refreshToken, 'old-refresh');
    expect(storage.deletions, 0);
  });

  test(
    'retry 401 is propagated without deleting the refreshed tokens',
    () async {
      apiDio.httpClientAdapter = TestAdapter(
        (_) async => jsonResponse(401, 'unauthorized'),
      );
      refreshDio.httpClientAdapter = TestAdapter(
        (_) async => jsonResponse(200, {
          'accessToken': 'new-access',
          'refreshToken': 'new-refresh',
        }),
      );

      await expectLater(
        repository.checkAuthLogin(),
        throwsA(
          isA<DioException>()
              .having((e) => e.requestOptions.path, 'path', '/api/users/me')
              .having((e) => e.response?.statusCode, 'status', 401),
        ),
      );
      expect(storage.accessToken, 'new-access');
      expect(storage.refreshToken, 'new-refresh');
      expect(storage.deletions, 0);
    },
  );

  test('concurrent 401s share one refresh request', () async {
    final allOriginalRequests = Completer<void>();
    final releaseRefresh = Completer<void>();
    var oldRequests = 0;
    var refreshRequests = 0;
    apiDio.httpClientAdapter = TestAdapter((options) async {
      if (options.headers['Authorization'] == 'Bearer old-access') {
        oldRequests++;
        if (oldRequests == 3) allOriginalRequests.complete();
        return jsonResponse(401, 'expired');
      }
      expect(options.headers['Authorization'], 'Bearer new-access');
      return jsonResponse(200, {'ok': true});
    });
    refreshDio.httpClientAdapter = TestAdapter((_) async {
      refreshRequests++;
      await releaseRefresh.future;
      return jsonResponse(200, {
        'accessToken': 'new-access',
        'refreshToken': 'new-refresh',
      });
    });

    final requests = Future.wait([
      apiDio.get('/one'),
      apiDio.get('/two'),
      apiDio.get('/three'),
    ]);
    await allOriginalRequests.future;
    releaseRefresh.complete();
    final responses = await requests;
    expect(responses.map((r) => r.statusCode), everyElement(200));
    expect(refreshRequests, 1);
    expect(oldRequests, 3);
  });
}
