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
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Dosen Pembimbing :",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Fitri Wibowo, S.ST. MT."),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Front End Developer :",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Patra Purbaya"),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Back End Developer :",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Haris Hijazi"),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Please provide feedback for further development of the application", textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                )),
          ),
          Text("Copyright © 2021 Patra Purbaya")
        ],
      ),
    );
  }
}
