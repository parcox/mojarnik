import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
            child: Container(
                // color: Colors.red,
                height: 200,
                width: 200,
                child: Image(
                  image: AssetImage("asset/logoMojarnik.png"),
                )),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: Column(
                children: [
                  Text("This is the description of this app"),
                ],
              )
            ),
          ),
          Text("Copyright © 2021 Patra Purbaya")
        ],
      ),
    );
  }
}
