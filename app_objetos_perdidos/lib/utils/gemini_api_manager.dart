import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiAPIManager {
  late final GenerativeModel _model;

  GeminiAPIManager() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null) {
      throw Exception("API KEY couldn't be found in .env");
    }

    _model = GenerativeModel(
      model: 'models/gemini-2.5-flash', 
      apiKey: apiKey,
    );
  }
  

  Future<String> generateResponse(String prompt) async {
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text!;
    } catch (e) {
      print('Error generating prompt: $e');
      return "";
    }
  }
}