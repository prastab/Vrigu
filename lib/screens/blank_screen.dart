import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import 'package:device_info/device_info.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../saved_datas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets.dart' as widget;

class BlankScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _BlankScreenState createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  SharedPrefs sharedPrefs = SharedPrefs();
  @override
  void initState() {
    super.initState();
    deviceDetail();
    loadPref();
  }

  String savedToken;
  String username;
  String password;
  bool showSpinner = true;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String id;
  loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedToken = prefs.getString("token");
    print(savedToken);
    savedToken == null
        ? registrationProcess()
        : Future.delayed(Duration.zero, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          });
  }

  Future<void> deviceDetail() async {
    try {
      if (Platform.isAndroid) {
        var buildInfo = await deviceInfoPlugin.androidInfo;

        setState(() {
          id = buildInfo.androidId;
          username = id;
          password = id;
        });
      } else if (Platform.isIOS) {
        var buildInfo = await deviceInfoPlugin.iosInfo;

        setState(() {
          id = buildInfo.localizedModel;
          username = id;
          password = id;
        });
      }
    } catch (e) {}
  }

  Future registrationProcess() async {
    try {
      final url = 'https://astroguru.herokuapp.com/api/auth/register';
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body:
              json.encode({"username": "$username", "password": "$password"}));
      print(json.encode({"username": "$username", "password": "$password"}));
      print(response.statusCode);
      if (response.statusCode == 400) {
        loginprocess();
      } else if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final token = body["token"];
        print(token);
        setState(() {
          showSpinner = false;
        });
        sharedPrefs.savedToken = token;
        sharedPrefs.saveToken(token);
        sharedPrefs.saveUser(body["user"]["username"]);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      }

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      widget.showDialog(context);
    }
  }

  Future loginprocess() async {
    try {
      final url = 'http://astroguru.herokuapp.com/api/auth/login';
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body:
              json.encode({"username": "$username", "password": "$password"}));
      print(json.encode({"username": "$username", "password": "$password"}));
      print(response.body);
      if (response.statusCode == 400) {
      } else if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final token = body["token"];
        print(token);
        setState(() {
          showSpinner = false;
        });
        sharedPrefs.savedToken = token;
        sharedPrefs.saveToken(token);
        sharedPrefs.saveUser(body["user"]["username"]);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } catch (e) {
      print(e);

      widget.showDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        color: Colors.orange,
        opacity: 0.8,
        inAsyncCall: showSpinner,
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}
