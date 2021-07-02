import 'package:flutter/material.dart';
import 'package:mojarnik/user.dart';
import 'package:mojarnik/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // String phoneNumber = "081351963101";
  SharedPreferences sharedPreferences;

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<List<User>> getUser() async {
    http.Response response;
    // Uri url = 'http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodul/'
    //     as Uri;
    response = await http.get(
        Uri.parse(
            "http://students.ti.elektro.polnep.ac.id:8000/api/accounts/customuser/"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'token ' + sharedPreferences.getString("token")
        });
    if (response.statusCode == 200) {
      List mapResponse = json.decode(response.body);
      return mapResponse.map((e) => User.fromJson(e)).toList().cast();
    }
    return null;
  }

  @override
  void initState() {
    initPreference();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Image(
                  image: AssetImage("asset/markZuck.png"),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xff0ABDB6)),
                  child: Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            // color: Colors.red,
            child: Column(
              children: [
                SettingsItem(
                  title: "Name",
                  // content: sharedPreferences.getString("nama"),
                  content: sharedPreferences.getString("user_name"),
                  isEditable: true,
                ),
                SettingsItem(
                  title: "NIM",
                  content: "3201816114",
                  isEditable: false,
                ),
                SettingsItem(title: "Gender", content: sharedPreferences.getString("gender"), isEditable: true,),
                SettingsItem(
                  title: "Phone Number",
                  content: sharedPreferences.getString("noHp"),
                  isEditable: true,
                ),
              ],
            ),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(top: 10),
            //       child: Text(
            //         "Name",
            //         style: TextStyle(
            //           color: Color(0xff939393),
            //           fontSize: 18,
            //         ),
            //       ),
            //     ),
            //     Row(
            //       children: [
            //         Expanded(
            //           child: Text(
            //             sharedPreferences?.getString("name") ?? "",
            //             style: TextStyle(fontSize: 20),
            //           ),
            //         ),
            //         Icon(Icons.edit),
            //       ],
            //     )
            //   ],
            // ),
          ),
        ),
      ],
    );
  }
}
