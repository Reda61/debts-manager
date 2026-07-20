import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  final TextEditingController _urlController = TextEditingController(
    text: 'http://192.168.0.100:5000/api/Debts/All/${1011}',
  );

  String _resultText = 'اضغط زر الاختبار للبدء';
  Color _resultColor = Colors.grey;
  bool _isLoading = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _resultText = 'جاري الاختبار...';
      _resultColor = Colors.orange;
    });

    final url = _urlController.text.trim();

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      setState(() {
        _isLoading = false;
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _resultColor = Colors.green;
          _resultText =
              '✅ الاتصال ناجح!\nStatus Code: ${response.statusCode}\n\nResponse:\n${_prettyPrint(response.body)}';
        } else {
          _resultColor = Colors.orange;
          _resultText =
              '⚠️ السيرفر رد لكن فيه مشكلة\nStatus Code: ${response.statusCode}\n\nResponse:\n${response.body}';
        }
      });
    } on TimeoutException {
      setState(() {
        _isLoading = false;
        _resultColor = Colors.red;
        _resultText =
            '❌ انتهى الوقت (Timeout)\n\nالاحتمالات:\n- السيرفر مو شغال\n- IP غلط\n- Firewall يحجب المنفذ\n- الموبايل واللابتوب مو بنفس الشبكة';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _resultColor = Colors.red;
        _resultText = '❌ فشل الاتصال\n\nالخطأ:\n$e';
      });
    }
  }

  String _prettyPrint(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return jsonStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختبار الاتصال بالسيرفر')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'رابط السيرفر (API URL)',
                border: OutlineInputBorder(),
                hintText: 'http://192.168.0.100:5000/api/Debts/All/${1011}',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.wifi_find),
              label: Text(_isLoading ? 'جاري الفحص...' : 'اختبار الاتصال'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: _resultColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                  color: _resultColor.withOpacity(0.08),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _resultText,
                    style: TextStyle(
                      color: _resultColor == Colors.grey
                          ? Colors.black87
                          : _resultColor,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
