import 'package:couple_schedule_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('이메일과 비밀번호 미입력 시 오류 메시지가 표시된다', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginPage())),
    );

    await tester.ensureVisible(find.text('로그인'));

    await tester.tap(find.text('로그인'));

    await tester.pump();

    expect(find.text('이메일을 입력해 주세요.'), findsOneWidget);

    expect(find.text('비밀번호를 입력해 주세요.'), findsOneWidget);
  });
}
