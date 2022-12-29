import 'package:flutter_chatgpt/config/firebase_config.dart';
import 'package:flutter_chatgpt/models/chat_model.dart';

class GetMessageRepository {
  static Stream<List<ChatModel>> getMessages() => FirebaseConfig
      .firebaseFirestore
      .collection("messageCollections")
      .orderBy("timestamp", descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList(),
      );
}
