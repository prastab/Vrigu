import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../screens/question_screen.dart';

import 'profile_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets.dart' as widget;

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    loadProfiles();
  }

  bool setSpinner = true;
  String savedToken;
  List profileList = [];
  String data;

  void loadProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedToken = prefs.getString("token");
    print(savedToken);
    setState(() {
      setSpinner = true;
    });
    try {
      final url = 'http://astroguru.herokuapp.com/api/profiles/';
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Token $savedToken"
        },
      );
      print(response.body);
      if (response.statusCode == 400) {
      } else if (response.statusCode == 200) {
        setState(() {
          data = response.body;
          profileList = json.decode(response.body);
          setSpinner = false;
        });
      }
      setState(() {
        setSpinner = false;
      });
    } catch (e) {
      setState(() {
        setSpinner = false;
      });
      widget.showDialog(context);
      print(e);
      print("yup");
    }
  }

  void passDataToForm(dynamic jsonBody, BuildContext context) {
    dynamic object = jsonBody;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => ProfileForm(
                  id: object["id"],
                  name: object["name"],
                  dobYear: object["dob_year"],
                  dobMonth: object["dob_month"],
                  dobAmPm: object["dob_am_pm"],
                  dobDay: object["dob_day"],
                  dobHour: object["dob_hour"],
                  dobMins: object["dob_minutes"],
                  gender: object["gender"],
                  birthCountry: object["birth_country"],
                  birthPlace: object["birth_place"],
                )));
  }

  void deleteProfile(dynamic jsonBody, BuildContext context) async {
    try {
      final url =
          'http://astroguru.herokuapp.com/api/profiles/${jsonBody["id"]}';
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Token $savedToken"
        },
      );
      print(response.body);
      if (response.statusCode == 400) {
      } else if (response.statusCode == 200) {
        setState(() {
          setSpinner = false;
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Profile deleted Successfully")),
        );
      }
      setState(() {
        setSpinner = false;
      });
    } catch (e) {
      setState(() {
        setSpinner = false;
      });
      widget.showDialog(context);
      print(e);
    }
  }

  void passDataToQuestion(dynamic jsonBody, BuildContext context) {
    dynamic object = jsonBody;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => QuestionScreen(
                  id: object["id"],
                  name: object["name"],
                  dobYear: object["dob_year"],
                  dobMonth: object["dob_month"],
                  dobAmPm: object["dob_am_pm"],
                  dobDay: object["dob_day"],
                  dobHour: object["dob_hour"],
                  dobMins: object["dob_minutes"],
                  gender: object["gender"],
                  birthCountry: object["birth_country"],
                  birthPlace: object["birth_place"],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("AstroGuru"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          loadProfiles();
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => ProfileForm()));
        },
        label: Text("Add Profile"),
        icon: Icon(Icons.add),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: setSpinner,
          child: ListView.builder(
            itemCount: profileList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Material(
                  elevation: 3.0,
                  color: Color(0xFFffd5cd),
                  borderRadius: BorderRadius.circular(10.0),
                  child: ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          passDataToForm(profileList[index], context);
                        },
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Name : ",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                              Text(profileList[index]["name"],
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Gender : ",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                              Text(profileList[index]["gender"],
                                  style: TextStyle(
                                    fontSize: 18,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "DOB : ",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                          Text(
                              "${profileList[index]["dob_year"]}/${profileList[index]["dob_month"]}/${profileList[index]["dob_day"]}",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        ],
                      ),
                      onTap: () {
                        passDataToQuestion(profileList[index], context);
                      }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
