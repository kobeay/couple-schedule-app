import 'package:couple_schedule_app/features/auth/data/models/user_response.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_response.dart';
import 'package:couple_schedule_app/features/couple/presentation/pages/couple_management_page.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/received_invitations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testUser = UserResponse(
    id: 1,
    email: 'test@example.com',
    nickname: '테스트 사용자',
    inviteCode: 'ABCD1234',
  );

  const disconnectedCouple = CoupleResponse(
    connected: false,
    partnerNickname: null,
    connectedAt: null,
  );

  final connectedCouple = CoupleResponse(
    connected: true,
    partnerNickname: '민수',
    connectedAt: DateTime(2025, 3, 7),
  );

  Future<void> pumpPage(WidgetTester tester, CoupleResponse couple) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coupleProvider.overrideWith((ref) async => couple),
          userInfoProvider.overrideWith((ref) async => testUser),
          receivedInvitaionsProvider.overrideWith((ref) async => []),
        ],
        child: const MaterialApp(home: CoupleManagementPage()),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('커플 미연결 상태의 안내와 초대 버튼이 표시된다', (tester) async {
    await pumpPage(tester, disconnectedCouple);

    expect(find.text('아직 연결된 커플이 없어요'), findsOneWidget);
    expect(find.text('상대방 초대 코드 입력'), findsOneWidget);
  });

  testWidgets('커플 연결 상태의 상대방 정보와 해제 버튼이 표시된다', (tester) async {
    await pumpPage(tester, connectedCouple);

    expect(find.text('민수님과 연결됨'), findsOneWidget);
    expect(find.text('2025.03.07'), findsOneWidget);
    expect(find.text('커플 연결 해제'), findsOneWidget);
  });

  testWidgets('커플 연결 해제 버튼을 누르면 확인 다이얼로그가 표시된다', (tester) async {
    await pumpPage(tester, connectedCouple);

    final disconnectButton = find.text('커플 연결 해제');

    await tester.ensureVisible(disconnectButton);
    await tester.tap(disconnectButton);

    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);

    expect(dialog, findsOneWidget);
    expect(
      find.descendant(of: dialog, matching: find.text('커플 연결을 해제할까요?')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialog, matching: find.text('취소')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialog, matching: find.text('연결 해제')),
      findsOneWidget,
    );

    await tester.tap(find.descendant(of: dialog, matching: find.text('취소')));
    await tester.pumpAndSettle();
  });
}
