import 'package:couple_schedule_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('비밀번호 표시 버튼을 누르면 비밀번호가 표시된다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AuthField(
            hintText: '비밀번호를 입력해주세요',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
        ),
      ),
    );

    final passwordField = find.byType(TextField);

    expect(tester.widget<TextField>(passwordField).obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));

    await tester.pump();

    expect(tester.widget<TextField>(passwordField).obscureText, isFalse);
  });
}
