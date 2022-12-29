class ChatModel {
  String message;
  bool isChatGPT;
  dynamic timestamp;

  ChatModel({
    required this.message,
    required this.isChatGPT,
    required this.timestamp,
  });
  Map<String, dynamic> toJson() => {
        'message': message,
        'isChatGPT': isChatGPT,
        'timestamp': timestamp,
      };
  static ChatModel fromJson(Map<String, dynamic> json) => ChatModel(
        isChatGPT: json["isChatGPT"],
        message: json["message"],
        timestamp: json["timestamp"],
      );
}
