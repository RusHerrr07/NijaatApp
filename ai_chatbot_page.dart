import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _AiChatPage();
}

class _AiChatPage extends State<AiChatPage> {
  TextEditingController message = TextEditingController();
  ScrollController scroll = ScrollController();
  final List<Map<String, dynamic>> messages = [];
  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  void add(String message, [bool isUser = true]) {
    messages.add({'isUser': isUser, 'message': message});
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask to Ai"),
      ),
      body: GestureDetector(
        onTap: () {
          final currFocus = FocusScope.of(context);
          if (!currFocus.hasPrimaryFocus) {
            currFocus.unfocus();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  child: ListView.separated(
                    controller: scroll,
                    itemCount: messages.length,
                    separatorBuilder: (_, index) =>
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: messages[index]['isUser']
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 14),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: const Radius.circular(
                                      20,
                                    ),
                                    topRight: const Radius.circular(20),
                                    bottomRight: Radius.circular(
                                        messages[index]['isUser'] ? 0 : 20),
                                    topLeft: Radius.circular(
                                        messages[index]['isUser'] ? 20 : 0),
                                  ),
                                  color: messages[index]['isUser']
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade500.withOpacity(0.8)),
                              constraints: BoxConstraints(maxWidth: w * 2 / 3),
                              child: Text(
                                messages[index]['message'],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: message,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: "Enter the text",
                          hintStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CircleAvatar(
                      radius: 23,
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded),
                        onPressed: () async {
                          add(message.text);
                          setState(() {
                            scroll.jumpTo(scroll.position.extentTotal);
                          });
                          add(await openAi(message.text), false);
                          setState(() {
                            message.clear();
                            scroll.jumpTo(scroll.position.extentTotal);
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const apiKey = "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";
Future<String> openAi(String message) async {
  try {
    final result = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ],
      }),
    );


    return jsonDecode(result.body)['choices'][0]['message']['content'];
  } catch (e) {
    return "Something went worng!\nPlease try later";
  }
}