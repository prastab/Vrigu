import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_app/widgets.dart';
import 'package:new_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String username;
  String password;
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    username = value;
                  },
                  validator: (username) {
                    return username.isEmpty
                        ? "Username cannot be empty"
                        : username.length < 4
                            ? "Username must be atleast 4 characters"
                            : null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your username'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  obscureText: true,
                  validator: (password) {
                    return password.isEmpty
                        ? "Password cannot be empty"
                        : password.length < 4
                            ? "Password must be atleast 6 characters"
                            : null;
                  },
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                      errorText: _validate
                          ? "Username or Password do not match"
                          : null),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Log In',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final url =
                            'http://astroguru.herokuapp.com/api/auth/login';
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
                        print(response.body);
                        if (response.statusCode == 400) {
                          _validate = true;
                        } else if (response.statusCode == 200) {
                          final body = json.decode(response.body);
                          final token = body["token"];
                          print(token);
                          setState(() {
                            showSpinner = false;
                          });
                          _validate = false;
                          final user = await http.get(
                              "http://astroguru.herokuapp.com/api/auth/user",
                              headers: {
                                HttpHeaders.authorizationHeader: "Token $token"
                              });
                          print(user.body);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    // try {
                    //   final user = await _auth.signInWithEmailAndPassword(
                    //       email: email, password: password);
                    //   if (user != null) {
                    //     Navigator.pushNamed(context, ChatScreen.id);
                    //   }

                    //   setState(() {
                    //     showSpinner = false;
                    //   });
                    // } catch (e) {
                    //   print(e);
                    // }
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
