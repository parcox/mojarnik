import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({Key key}) : super(key: key);

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  SharedPreferences sharedPreferences;
  Timer timer;
  bool connected = true;
  bool isFalse = false;
  loading(String condition) {
    timer = new Timer(const Duration(seconds: 5), () {
      switch (condition) {
        case "login":
          return Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false);
          break;
        case "home":
          return Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        page: 0,
                        settingMode: false,
                      )),
              (Route<dynamic> route) => false);
          break;
      }
    });
  }

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      print("Success get preference");
    });
  }

  checkConnection() async {
    setState(() {
      isFalse=false;
    });
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
        return checkLoginStatus();
      }
    } catch (e) {
      print("Ndak ngecek");
      isFalse = true;
      setState(() {});
    }
  }

  secondLogin() async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse("http://mojarnik.online/api/accounts/customuser/" +
              sharedPreferences.getInt("userId").toString()),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        var jsonData = response.body;
        String jsonDataString = jsonData.toString();
        final jsonDataa = jsonDecode(jsonDataString);
        sharedPreferences.setString("user_name",
            jsonDataa["first_name"] + " " + jsonDataa["last_name"]);
        sharedPreferences.setString("foto", jsonDataa["foto"]);
        try {
          response = await http.get(
              Uri.parse(
                  "http://mojarnik.online/api/accounts/profilmahasiswa/?user=" +
                      sharedPreferences.getInt("userId").toString()),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'token ' + sharedPreferences.getString("token")
              });
          if (response.statusCode == 200) {
            var jsonData = response.body;
            String jsonDataString = jsonData.toString();
            final jsonDataa = jsonDecode(jsonDataString);
            sharedPreferences.setString("nim", jsonDataa[0]["nim"]);
            setState(() {
              loading("home");
            });
          }
        } catch (e) {
          print("Gagal get profilUser");
          print(e);
        }
        // return Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => HomePage()),
        //     (Route<dynamic> route) => false);
      }
    } catch (e) {
      print("Gagal get customUser");
      print(e);
    }
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      secondLogin();
    } else {
      loading("login");
    }
  }

  @override
  initState() {
    initPreference();
    super.initState();
    checkConnection();
  }

  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 4,
              child: Image(
                image: AssetImage("asset/logoMojarnik.png"),
              ),
            ),
            isFalse
                ? Column(
                    children: [
                      Text("No Internet Connection"),
                      TextButton(
                          onPressed: () {
                            checkConnection();
                          },
                          child: Icon(
                            Icons.replay_outlined,
                          )),
                    ],
                  )
                : Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Checking connection..."),
                    ],
                  )
            // Column(
            //     children: [
            //       Text("No Internet Connection"),
            //       TextButton(
            //           onPressed: () {
            //             checkConnection();
            //           },
            //           child: Icon(
            //             Icons.replay_outlined,
            //           )),
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}
