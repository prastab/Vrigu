import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../saved_datas.dart';
import '../widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets.dart' as widget;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileForm extends StatefulWidget {
  ProfileForm(
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
  _ProfileFormState createState() => _ProfileFormState(
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

class _ProfileFormState extends State<ProfileForm> {
  _ProfileFormState(
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
  String savedToken;

  bool showSpinner = false;
  loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedToken = prefs.getString("token");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person Form"),
      ),
      body: SafeArea(
          child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    "Name",
                    style: TextStyle(fontSize: 20, color: Color(0xff1a1c20)),
                  ),
                ),
                TextFormField(
                  initialValue: name,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.name,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: "Enter Name",
                  ),
                  onChanged: (val) {
                    name = val;
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    "BirthDate",
                    style: TextStyle(fontSize: 20, color: Color(0xff1a1c20)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: dobDay.toString() == "null"
                            ? null
                            : dobDay.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(fontSize: 20),
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: "Date",
                        ),
                        onChanged: (val) {
                          dobDay = int.parse(val);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: kBoxDecorationDropDown,
                        height: 50,
                        padding:
                            EdgeInsets.only(bottom: 1.0, left: 10, right: 10),
                        child: DropdownButton(
                          dropdownColor: Colors.grey.shade300,
                          focusColor: Color(0xFFf9813a),
                          hint: Text("Month"),
                          elevation: 10,
                          value:
                              dobMonth == null ? selectMonth : months[dobMonth],
                          isExpanded: true,
                          items: months
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                        child: Text(e),
                                        value: e,
                                      ))
                              .toList(),
                          onChanged: (val) {
                            dobMonth = months.indexOf(val);
                            setState(() {
                              selectMonth = val;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: dobYear.toString() == "null"
                            ? null
                            : dobYear.toString(),
                        style: TextStyle(fontSize: 20),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: "Year",
                        ),
                        onChanged: (val) {
                          dobYear = int.parse(val);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    "BirthTime",
                    style: TextStyle(fontSize: 20, color: Color(0xff1a1c20)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: dobHour.toString() == "null"
                            ? null
                            : dobHour.toString(),
                        style: TextStyle(fontSize: 20),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: "Hour",
                        ),
                        onChanged: (val) {
                          dobHour = int.parse(val);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: dobMins.toString() == "null"
                            ? null
                            : dobMins.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(fontSize: 20),
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: "Min",
                        ),
                        onChanged: (val) {
                          dobMins = int.parse(val);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: kBoxDecorationDropDown,
                        height: 50,
                        padding:
                            EdgeInsets.only(bottom: 1.0, left: 20, right: 20),
                        child: DropdownButton(
                          dropdownColor: Colors.grey.shade300,
                          focusColor: Color(0xFFf9813a),
                          hint: Text("Am"),
                          elevation: 10,
                          isExpanded: true,
                          value: dobAmPm ?? selectAmPm,
                          items: amPm
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                        child: Text(e),
                                        value: e,
                                      ))
                              .toList(),
                          onChanged: (val) {
                            dobAmPm = val;
                            setState(() {
                              selectAmPm = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    "Location",
                    style: TextStyle(fontSize: 20, color: Color(0xff1a1c20)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: birthPlace,
                        style: TextStyle(fontSize: 20),
                        decoration: kTextFieldDecoration.copyWith(
                          labelText: "Place",
                        ),
                        onChanged: (val) {
                          birthPlace = val;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: kBoxDecorationDropDown,
                        height: 50,
                        padding:
                            EdgeInsets.only(bottom: 1.0, left: 20, right: 20),
                        child: DropdownButton(
                          dropdownColor: Colors.grey.shade300,
                          focusColor: Color(0xFFf9813a),
                          hint: Text("Country"),
                          elevation: 10,
                          isExpanded: true,
                          value: birthCountry ?? selectCountry,
                          items: countries
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                        child: Text(e),
                                        value: e,
                                      ))
                              .toList(),
                          onChanged: (val) {
                            birthCountry = val;
                            setState(() {
                              selectCountry = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    "Gender",
                    style: TextStyle(fontSize: 20, color: Color(0xff1a1c20)),
                  ),
                ),
                Container(
                  decoration: kBoxDecorationDropDown,
                  height: 50,
                  padding: EdgeInsets.only(bottom: 1.0, left: 20, right: 20),
                  child: DropdownButton(
                    dropdownColor: Colors.grey.shade300,
                    focusColor: Color(0xFFf9813a),
                    hint: Text("Select your gender"),
                    elevation: 10,
                    value: gender == null
                        ? selectGender
                        : gender == "M"
                            ? "Male"
                            : gender == "F"
                                ? "Female"
                                : "Other",
                    isExpanded: true,
                    items: genders
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                                  child: Text(e),
                                  value: e,
                                ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectGender = val;
                      });
                      if (val == 'Male') {
                        gender = 'M';
                      } else if (val == 'Female') {
                        gender = 'F';
                      } else {
                        gender = 'O';
                      }
                    },
                  ),
                ),
                Center(
                  child: RoundedButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      print(savedToken);
                      if (id == null) {
                        createProfile();
                      } else {
                        editProfile();
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    title: "Save Profile",
                    colour: Colors.orange,
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  void createProfile() async {
    try {
      final url = 'http://astroguru.herokuapp.com/api/profiles/';
      print(url);
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            HttpHeaders.authorizationHeader: "Token $savedToken",
          },
          body: json.encode({
            "name": name,
            "gender": gender,
            "dob_year": dobYear,
            "dob_month": dobMonth,
            "dob_day": dobDay,
            "dob_hour": dobHour,
            "dob_minutes": dobMins,
            "dob_am_pm": dobAmPm,
            "birth_place": birthPlace,
            "birth_country": birthCountry,
          }));
      print(response.statusCode);
      if (response.statusCode == 400) {
        final body = json.decode(response.body);
        print(body);
      } else if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print(body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      widget.showDialog(context);
    }
  }

  void editProfile() {
    void createProfile() async {
      try {
        final url = 'https://astroguru.herokuapp.com/api/profiles/';
        print(url);
        final response = await http.put(url,
            headers: {
              "Content-Type": "application/json",
              HttpHeaders.authorizationHeader: "Token $savedToken",
            },
            body: json.encode({
              "name": name,
              "gender": gender,
              "dob_year": dobYear,
              "dob_month": dobMonth,
              "dob_day": dobDay,
              "dob_hour": dobHour,
              "dob_minutes": dobMins,
              "dob_am_pm": dobAmPm,
              "birth_place": birthPlace,
              "birth_country": birthCountry,
            }));
        print(response.statusCode);
        if (response.statusCode == 400) {
          final body = json.decode(response.body);
          print(body);
        } else if (response.statusCode == 200) {
          final body = json.decode(response.body);
          print(body);
        } else {
          print(response.body);
        }
      } catch (e) {
        print(e);
        widget.showDialog(context);
      }
    }
  }
}
