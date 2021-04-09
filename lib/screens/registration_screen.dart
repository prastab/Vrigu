import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_app/widgets.dart';
import 'package:new_app/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String username;
  String password;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    'AstroGuru',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
                SizedBox(
                  height: 120.0,
                ),
                TextFormField(
                  controller: _usernameController,
                  validator: (username) {
                    return username.isEmpty
                        ? "Username cannot be empty"
                        : username.length < 4
                            ? "Username must be atleast 4 characters"
                            : null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your username',
                      errorText:
                          _validate ? "The username already exists" : null),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (password) {
                    return password.isEmpty
                        ? "Password cannot be empty"
                        : password.length < 4
                            ? "Password must be atleast 6 characters"
                            : null;
                  },
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Register',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        final url =
                            'https://astroguru.herokuapp.com/api/auth/register';
                        final response = await http.post(url,
                            headers: {"Content-Type": "application/json"},
                            body: json.encode({
                              "username": "$username",
                              "password": "$password"
                            }));
                        print(json.encode({
                          "username": "$username",
                          "password": "$password"
                        }));
                        print(response.statusCode);
                        if (response.statusCode == 400) {
                          _validate = true;
                        }
                        // final newUser = await _auth.createUserWithEmailAndPassword(
                        //     email: email, password: password);
                        // if (newUser != null) {
                        //   Navigator.pushNamed(context, ChatScreen.id);
                        // }

                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
