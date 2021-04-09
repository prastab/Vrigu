import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.colour, @required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

showDialog(BuildContext context) {
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text('No Connection'),
    content: Text('Make sure you are connected to internet and try again.'),
    actions: [
      CupertinoDialogAction(
        child: Text('OK'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );

  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class AskQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Ask Question',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.lightBlueAccent,
          ),
        ),
        TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          onChanged: (newText) {},
        ),
        FlatButton(
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Colors.lightBlueAccent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
