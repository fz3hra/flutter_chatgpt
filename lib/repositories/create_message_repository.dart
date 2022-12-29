import 'package:flutter_chatgpt/config/firebase_config.dart';
import 'package:flutter_chatgpt/models/chat_model.dart';

class CreateMessageRepository {
  static Future createMessages(ChatModel chat) async {
    final createMssage =
        FirebaseConfig.firebaseFirestore.collection('messageCollections').doc();
    final messages = ChatModel(
      isChatGPT: chat.isChatGPT,
      message: chat.message,
      timestamp: chat.timestamp,
    );
    var json = messages.toJson();
    await createMssage.set(json);
  }
}
