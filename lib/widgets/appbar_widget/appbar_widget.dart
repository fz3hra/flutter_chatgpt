import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppBar(
        shape: const Border(
          bottom: BorderSide(color: Colors.orange, width: 1),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: CircleAvatar(
          child: ClipOval(
            child: Image.network(
              "https://images.unsplash.com/photo-1586374579358-9d19d632b6df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Ym90fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text(
          "ChatGPT",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
