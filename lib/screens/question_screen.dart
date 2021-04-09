import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:new_app/widgets.dart' as widget;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'answer_screen.dart';

class QuestionScreen extends StatefulWidget {
  QuestionScreen(
      {this.id,
      this.name,
      this.gender,
      this.dobYear,
      this.dobMonth,
      this.dobMins,
      this.dobHour,
      this.dobDay,
      this.dobAmPm,
      this.birthPlace,
      this.birthCountry});
  final int id;
  final String name;
  final String gender;
  final int dobYear;
  final int dobMonth;
  final int dobDay;
  final int dobHour;
  final int dobMins;
  final String dobAmPm;
  final String birthPlace;
  final String birthCountry;
  @override
  _QuestionScreenState createState() => _QuestionScreenState(
      id: id,
      name: name,
      gender: gender,
      dobYear: dobYear,
      dobAmPm: dobAmPm,
      dobDay: dobDay,
      dobHour: dobHour,
      dobMins: dobMins,
      dobMonth: dobMonth,
      birthPlace: birthPlace,
      birthCountry: birthCountry);
}

class _QuestionScreenState extends State<QuestionScreen> {
  _QuestionScreenState(
      {this.id,
      this.name,
      this.gender,
      this.dobYear,
      this.dobMonth,
      this.dobMins,
      this.dobHour,
      this.dobDay,
      this.dobAmPm,
      this.birthPlace,
      this.birthCountry});

  // 'id','name','gender','dob_year','dob_month','dob_day','dob_hour','dob_minutes','dob_am_pm','birth_place','birth_country'
  bool showSpinner = false;

  int id;
  String name;
  String gender;
  int dobYear;
  int dobMonth;
  int dobDay;
  int dobHour;
  int dobMins;
  String dobAmPm;
  String birthPlace;
  String birthCountry;
  String selectMonth;
  String selectCountry;
  String selectGender;
  String selectAmPm;
  List questions = [];
  List questionId = [];

  String token;
  String newQuestion;

  void getQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    setState(() {
      showSpinner = true;
    });
    try {
      final url = 'http://astroguru.herokuapp.com/api/profiles/$id/questions/';
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );
      print(response.body);
      if (response.statusCode == 400) {
      } else if (response.statusCode == 200) {
        setState(() {
          questions = json.decode(response.body);
          dynamic body = response.body;
        });
      }
      showSpinner = false;
    } catch (e) {
      showSpinner = false;
      widget.showDialog(context);
      print(e);
      print("yup");
    }
  }

  int ques;
  postQuestion() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final url = 'http://astroguru.herokuapp.com/api/profiles/$id/questions/';
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: json.encode({"question_text": "$newQuestion"}));
      print(response.body);
      if (response.statusCode == 400) {
      } else if (response.statusCode == 200) {
        dynamic obj = response.body;
        ques = obj["id"];
        print(ques);
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
    getQuestions();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Name : $name",
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Gender : $gender",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "DOB : $dobYear/$dobMonth/$dobDay",
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "BirthTime : $dobHour:$dobMins $dobAmPm",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Birth Location: $birthPlace,$birthCountry",
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Text("Questions"),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Q: ${questions[index]["question_text"]}",
                            style: TextStyle(fontSize: 16)),
                        // subtitle: Text(
                        //   questions[index]["final_answer"] == ""
                        //       ? "Your answer is being processed"
                        //       : "${questions[index]["final_answer"]}",
                        //   style: TextStyle(fontSize: 18),
                        // ),
                        trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              print(questions[index]["id"]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => AnswerScreen(
                                          questions[index]["id"], id)));
                            }),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        onChanged: (newValue) {
                          newQuestion = newValue;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        height: 50,
                        onPressed: () {
                          postQuestion();
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      AnswerScreen(id, ques)));
                        },
                        child: Text(
                          'Add Question',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.lightBlueAccent,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        label: Text("Ask Question"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
