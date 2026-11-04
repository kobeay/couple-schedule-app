import 'package:couple_schedule_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('비밀번호가 일치하지 않으면 오류 메시지가 표시된다', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SignUpPage())),
    );

    await tester.enterText(find.byType(TextFormField).at(1), 'Password123!');

    await tester.enterText(find.byType(TextFormField).at(2), 'Different123!');

    final signupButton = find.widgetWithText(FilledButton, '회원가입');

    await tester.ensureVisible(signupButton);

    await tester.tap(signupButton);

    await tester.pump();

    expect(find.text('비밀번호가 일치하지 않습니다.'), findsOneWidget);
  });
}
