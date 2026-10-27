import 'package:couple_schedule_app/features/auth/data/datasources/auth_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TokenTestPage extends StatefulWidget {
  const TokenTestPage({super.key});

  @override
  State<TokenTestPage> createState() => _TokenTestPageState();
}

class _TokenTestPageState extends State<TokenTestPage> {
  bool _isLoading = false;
  String _result = '아직 API 요청을 보내지 않았습니다.';

  Future<void> _testTokenRefresh() async {
    setState(() {
      _isLoading = true;
      _result = 'API 요청 중...';
    });

    try {
      final response = await AuthApi().getMyInfo();

      debugPrint('API 요청 성공: ${response.statusCode}');
      debugPrint('서버 응답: ${response.data}');

      if (!mounted) return;

      setState(() {
        _result = 'API 요청 성공!\n상태 코드: ${response.statusCode}';
      });
    } on DioException catch (e) {
      debugPrint('API 요청 실패: ${e.response?.statusCode}');
      debugPrint('오류 내용: ${e.message}');

      if (!mounted) return;

      setState(() {
        _result =
            'API 요청 실패!\n'
            '상태 코드: ${e.response?.statusCode}\n'
            '오류: ${e.message}';
      });
    } catch (e) {
      debugPrint('예상하지 못한 오류: $e');

      if (!mounted) return;

      setState(() {
        _result = '오류 발생: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JWT 자동 재발급 테스트')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'JWT 자동 재발급 테스트',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              '1. 로그인 후 1분 10초 기다립니다.\n'
              '2. 아래 버튼을 누릅니다.\n'
              '3. 자동 재발급이 성공하는지 확인합니다.',
            ),

            const SizedBox(height: 30),

            FilledButton(
              onPressed: _isLoading ? null : _testTokenRefresh,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('API 요청 테스트'),
            ),

            const SizedBox(height: 30),

            const Text(
              '테스트 결과',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(_result),
          ],
        ),
      ),
    );
  }
}
