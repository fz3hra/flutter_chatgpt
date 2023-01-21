import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/models/chat_model.dart';
import 'package:flutter_chatgpt/repositories/create_message_repository.dart';
import 'package:flutter_chatgpt/repositories/get_message_repository.dart';
import 'package:flutter_chatgpt/repositories/openai_repository.dart';
import 'package:flutter_chatgpt/utils/token.dart';
import 'package:flutter_chatgpt/widgets/appbar_widget/appbar_widget.dart';
import 'package:gap/gap.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late stt.SpeechToText speech;
  late TextEditingController textController;
  String? text;
  bool _isListening = false;
  bool doneListening = false;
  List<ChatModel> texts = [];
  String newlyFormed = "";
  late ChatGPTApi api;

  @override
  void initState() {
    textController = TextEditingController();
    api = ChatGPTApi(sessionToken: Tokens.SESSION_TOKEN, clearanceToken: '');
    super.initState();
    speech = stt.SpeechToText();
  }

  void listen() async {
    if (!_isListening) {
      bool available = await speech.initialize(
        onStatus: (val) {
          print('on status $val');
          if (val == "done") {
            CreateMessageRepository.createMessages(
              ChatModel(
                isChatGPT: _isListening,
                message: text!,
                timestamp: Timestamp.now(),
              ),
            );
            OpenAiRepository.sendMessage(prompt: text);
          }
        },
        onError: (val) => print('on Errir $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        speech.listen(
          onResult: (val) {
            setState(
              () {
                text = val.recognizedWords;
              },
            );
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        speech.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppbarWidget(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatModel>>(
                stream: GetMessageRepository.getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("something went wrong"),
                    );
                  } else if (snapshot.hasData) {
                    final chats = snapshot.data!;
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var chat = chats[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Align(
                            alignment: chat.isChatGPT == false
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                width: 200,
                                decoration: BoxDecoration(
                                  color: chat.isChatGPT == false
                                      ? const Color(0xFFE5E5E5)
                                      : const Color(0xFFD0ECE8),
                                  borderRadius: chat.isChatGPT == false
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(20),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(0),
                                        ),
                                ),
                                child: Center(
                                  child: Text(
                                    chat.message,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const Gap(16),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(_isListening == true ? 0xFF55A99D : 0xFFD0ECE8),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              onPressed: listen,
              child: Icon(_isListening == false ? Icons.mic_none : Icons.mic),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}
