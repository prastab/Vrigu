import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:new_app/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:new_app/widgets.dart' as widget;
import 'package:shared_preferences/shared_preferences.dart';

class AnswerScreen extends StatefulWidget {
  AnswerScreen(this.questionid, this.id);
  final id;
  final questionid;

  @override
  _AnswerScreenState createState() => _AnswerScreenState(id, questionid);
}

String currentUser;
String messageText;

class _AnswerScreenState extends State<AnswerScreen> {
  _AnswerScreenState(this.id, this.questionid);

  List messages;
  List<Widget> messageBubbles = [];

  bool showSpinner = false;
  String token;
  int id;
  int questionid;
  dynamic question = {
    "question_text": "Loading...",
    "final_answer": "Loading..."
  };
  int messageId;
  showMessage(context, messageBubbles) {
    final messageTextController = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(messageBubbles: messageBubbles),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      sendMessage(messageText);
                      messageTextController.clear();
                      setState(() {
                        getMessages();
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage(reply) async {
    setState(() {
      showSpinner = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    try {
      final url =
          'http://astroguru.herokuapp.com/api/profiles/$id/questions/$questionid/messages/$messageId/';
      final response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: json.encode({"reply_text": reply, "is_replied": true}));
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {});
      }
      setState(() {
        showSpinner = false;
      });
      print("bhayo");
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      widget.showDialog(context);
      print(e);
      print("yup");
    }
  }

  void getMessages() async {
    setState(() {
      showSpinner = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    try {
      final url =
          'http://astroguru.herokuapp.com/api/profiles/$id/questions/$questionid/messages';
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );
      messageBubbles.clear();
      print(response.body);
      if (response.statusCode == 400) {
      } else if (response.statusCode == 200) {
        messages = json.decode(response.body);
        print(messages);
        for (var message in messages) {
          messageText = message['message_text'];
          String replyText = message['reply_text'];

          messageId = message['id'];

          final messageBubble = MessageBubble(
            text: messageText,
          );

          final replyBubble = ReplyBubble(
            text: replyText,
          );

          messageBubbles.add(messageBubble);

          if (replyText != null) {
            messageBubbles.add(replyBubble);
          }
        }
      }
      setState(() {
        showSpinner = false;
      });
      print("bhayo");
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      widget.showDialog(context);
      print(e);
      print("yup");
    }
  }

  void getQuestionInfo() async {
    setState(() {
      showSpinner = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    try {
      final url =
          'http://astroguru.herokuapp.com/api/profiles/$id/questions/$questionid';
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          question = json.decode(response.body);
        });
      }
      setState(() {
        showSpinner = false;
      });
      print("bhayo");
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      widget.showDialog(context);
      print(e);
      print("yup");
    }
  }

  @override
  void initState() {
    getQuestionInfo();
    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AstroGuru"),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Question :",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      question["question_text"] == ""
                          ? "Loading..."
                          : question["question_text"],
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Answer :",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      question["final_answer"] == ""
                          ? "Your answer is being processed"
                          : "${question["final_answer"]}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMessage(context, messageBubbles);
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({this.messageBubbles});
  final List<Widget> messageBubbles;
  @override
  Widget build(BuildContext context) {
    return Container(
      // builder:s
      //  (context, snapshot) {
      // if (!snapshot.hasData) {
      //   return Center(
      //     child: CircularProgressIndicator(
      //       backgroundColor: Colors.lightBlueAccent,
      //     ),
      //   );
      // }

      child: Expanded(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles),
      ),
      // },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   sender.toString(),
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyBubble extends StatelessWidget {
  ReplyBubble({
    this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Text(
          //   sender.toString(),
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
