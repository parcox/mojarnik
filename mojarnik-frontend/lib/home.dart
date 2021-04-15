import 'package:flutter/material.dart';
import 'package:mojarnik/home1.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 0;
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
        // leading: FlatButton(
        //   onPressed: () {
        //     scaffoldKey.currentState.openDrawer();
        //   },
        //   child: Icon(
        //     Icons.menu,
        //     color: Colors.grey,
        //   ),
        // ),
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                  color: Colors.black.withOpacity(0.6),
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
                  style: TextStyle(fontSize: 17, color: Color(0xff818181)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "3201816100",
                  style: TextStyle(fontSize: 17, color: Color(0xff818181)),
                ),
                Divider(),
                Container(
                  height: 50,
                  color: Colors.red,
                ),
                Container(
                  height: 50,
                  color: Colors.red,
                ),
                Container(
                  height: 50,
                  color: Colors.red,
                ),
                Container(
                  height: 50,
                  color: Colors.red,
                ),
                Container(
                  height: 50,
                  color: Colors.red,
                ),
                Container(
                  height: 50,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
      body: <Widget>[
        FirstPage(),
      ][page],
    );
  }
}
