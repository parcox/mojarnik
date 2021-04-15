import 'package:flutter/material.dart';
import 'package:mojarnik/about3.dart';
import 'package:mojarnik/home1.dart';
import 'package:mojarnik/main.dart';
import 'package:mojarnik/settings2.dart';
import 'package:mojarnik/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 0;
  logOut() {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Text(
            "MOJARNIK",
            style: TextStyle(
                letterSpacing: 2,
                fontSize: 30,
                fontFamily: "StormFaze",
                color: Color(0xff0ABDB6)),
          ),
        ),
        leading: TextButton(
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: Color(0xff0ABDB6),
            size: 30,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            // child: Image(image: AssetImage("asset/help.png"),)
            child: Image(
              height: 30,
              width: 30,
              image: AssetImage(
                "asset/help.png",
              ),
            ),
          ),
        ],
      ),
      key: scaffoldKey,
      drawer: Align(
        alignment: Alignment.topLeft,
        child: Container(
          color: Colors.white,
          width: 230,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image(
                        height: 30,
                        width: 30,
                        image: AssetImage("asset/polnep.png"),
                      ),
                    ),
                    Text(
                      "MOJARNIK",
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 25,
                          fontFamily: "StormFaze",
                          color: Color(0xff0ABDB6)),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black.withOpacity(0.5),
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("asset/markZuck.png"),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Mark Zuckerberg",
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff818181),
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "3201816100",
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff818181),
                    fontWeight: FontWeight.w400),
              ),
              Divider(
                color: Colors.black.withOpacity(0.5),
              ),
              DrawerMenu(
                title: "Home",
                onPressed: () {
                  setState(() {
                    page = 0;
                  });
                },
              ),
              DrawerMenu(
                title: "Settings",
                onPressed: () {
                  setState(() {
                    page = 1;
                  });
                },
              ),
              DrawerMenu(
                title: "About",
                onPressed: () {
                  setState(() {
                    page = 2;
                  });
                },
              ),
              Expanded(child: Container()),
              // Container(
              //     width: 300,
              //     height: 40,
              //     color: Colors.black,
              //   child: TextButton(
              //     style: ButtonStyle(),
              //     onPressed: () {
              //       logOut();
              //     },
              //     child: Container(
              //       color: Colors.red.withOpacity(0.8),
              //       child: Text(
              //         "Log Out",
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       alignment: Alignment.center,
              //     ),
              //   ),
              // ),
              TextButton(
                onPressed: () {
                  logOut();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.power_settings_new, color: Colors.red),
                    SizedBox(width: 3,),
                    Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: <Widget>[
        FirstPage(),
        SecondPage(),
        ThirdPage(),
      ][page],
    );
  }
}
