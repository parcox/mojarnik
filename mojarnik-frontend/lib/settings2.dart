import 'package:flutter/material.dart';
import 'package:mojarnik/widgets.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String phoneNumber = "081351963101";
  @override
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
                    shape: BoxShape.circle,
                    color: Color(0xff0ABDB6)
                  ),
                  child: Icon(Icons.photo_camera_outlined, color: Colors.white, size: 25,),
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
                SettingsItem(title: "Name",content: "Patra Purbaya", isEditable: true,),
                SettingsItem(title: "NIM",content: "3201816094", isEditable: false,),
                SettingsItem(title: "Gender", content: "Men", isEditable: true),
                SettingsItem(title: "Phone Number", content: phoneNumber.replaceRange(8, phoneNumber.length , "x"*(phoneNumber.length-8)), isEditable: true,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
