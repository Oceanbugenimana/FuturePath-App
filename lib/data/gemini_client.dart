import 'dart:convert';
import 'package:http/http.dart' as http;

/// Gemini REST API client — mirrors GeminiApiClient.kt
class GeminiClient {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  // Set your Gemini API key here or load from environment / secure storage
  static const String apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static Future<String> callGemini(
    String prompt, {
    String? systemPrompt,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('API_KEY_EMPTY');
    }

    final uri = Uri.parse('$_baseUrl?key=$apiKey');

    final body = <String, dynamic>{
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 1024},
    };

    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      body['systemInstruction'] = {
        'parts': [
          {'text': systemPrompt}
        ]
      };
    }

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = json['candidates'] as List<dynamic>?;
        final text = candidates
            ?.firstOrNull?['content']?['parts']
            ?.firstOrNull?['text'] as String?;
        return text ?? 'Empty response from Gemini.';
      } else {
        return 'API_NETWORK_ERROR: HTTP ${response.statusCode}';
      }
    } catch (e) {
      return 'API_NETWORK_ERROR: $e';
    }
  }
}
