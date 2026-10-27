import 'package:couple_schedule_app/app/theme/app_theme.dart';
import 'package:couple_schedule_app/core/network/dio_client.dart';
import 'package:couple_schedule_app/features/auth/presentation/pages/login_page.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/auto_login_provider.dart';
import 'package:couple_schedule_app/features/main/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  // Flutter 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Dio 인터셉터 등록
  DioClient.initialize();

  // 상태바 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Couple Schedule',
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoLoginState = ref.watch(autoLoginProvider);

    return autoLoginState.when(
      loading: () {
        debugPrint('자동 로그인 확인 중');

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },

      data: (isLoggedIn) {
        debugPrint('자동 로그인 결과: $isLoggedIn');

        if (isLoggedIn) {
          return const MainPage();
        }

        return const LoginPage();
      },

      error: (error, stackTrace) {
        debugPrint('자동 로그인 오류: $error');

        return Scaffold(
          body: Center(child: Text('로그인 상태 확인 중 오류가 발생했습니다: $error')),
        );
      },
    );
  }
}
