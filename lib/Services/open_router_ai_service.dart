import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenRouterAiService {
  static String url = 'https://openrouter.ai/api/v1/chat/completions';
  static String apiKey = dotenv.get('API_KEY');

  static Future<Map<String, dynamic>> callOpenRoute(
    String systemPrompt,
    String userPrompt,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'openai/gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        'temperature': 0.2,
        'max_tokens': 1300,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur OpenAI: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'];
    print(content);
    return jsonDecode(content); // JSON strict attendu
  }
}
