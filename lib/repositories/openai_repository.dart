import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatgpt/models/chat_model.dart';
import 'package:flutter_chatgpt/repositories/create_message_repository.dart';
import 'package:flutter_chatgpt/utils/token.dart';
import 'package:http/http.dart' as http;

class OpenAiRepository {
  static var client = http.Client();

  static Future<Map<String, dynamic>> sendMessage({required prompt}) async {
    const endpoint = "https://api.openai.com/v1/";
    const aiToken = Tokens.SESSION_TOKEN;
    try {
      var headers = {
        'Authorization': 'Bearer $aiToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('${endpoint}completions'));
      request.body = json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        "temperature": 0,
        "max_tokens": 2000
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        var question = json.decode(data)["choices"][0]["text"];
        prompt != null
            ? CreateMessageRepository.createMessages(
                ChatModel(
                  isChatGPT: false,
                  message: question,
                  timestamp: Timestamp.now(),
                ),
              )
            : print("NOPE");
        return json.decode(data);
      } else {
        return {
          "status": false,
          "message": "Oops, there was an error",
        };
      }
    } catch (_) {
      return {
        "status": false,
        "message": "Oops, there was an error",
      };
    }
  }
}
