import 'package:flutter/material.dart';
import 'package:mojarnik/main.dart';
import 'package:mojarnik/page/launcher.dart';
import 'package:mojarnik/page/testUploadImage.dart';
import 'package:mojarnik/tes.dart';
import 'package:mojarnik/widgets.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'menuDrawer/about3.dart';
import 'menuDrawer/bookmarks4.dart';
import 'menuDrawer/home1.dart';
import 'menuDrawer/settings2.dart';

class HomePage extends StatefulWidget {
  // final int prodi;
  // final String semester;
  // final String kelas;
  int page;
  bool settingMode;
  HomePage({
    Key key,
    this.page,
    this.settingMode,
    //  this.prodi, this.semester, this.kelas
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List _gender = ["Perempuan", "Laki-laki"];
  SharedPreferences sharedPreferences;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool edit = false;
  String helpContent = """ 
  MOJARNIK (Modul Ajar Elektronik) adalah aplikasi pembelajaran yang memudahkan pengajar dan pembelajar mewujudkan pendistribusian materi secara efektif. 
  """;

  List mapResponse;

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  logOut() {
    return NAlertDialog(
      title: Text("Are you sure ?"),
      content: Text("Do you want to log out from your account ?"),
      actions: [
        TextButton(
          onPressed: () {
            sharedPreferences.clear();
            sharedPreferences.commit();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
          },
          child: Text(
            "Yes",
            style: TextStyle(color: Color(0xff0ABDB6)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "No",
            style: TextStyle(color: Color(0xff0ABDB6)),
          ),
        ),
      ],
    ).show(context);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new NAlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  getImage() {
    // if (sharedPreferences.getString("foto") == null) {
    //   return AssetImage("asset/markZuck.png");
    // } else {
    //   try {
    //     return NetworkImage(
    //       sharedPreferences.getString("foto"),
    //     );
    //   } catch (e) {
    //     return AssetImage("asset/markZuck.png");
    //   }
    // }
    try {
      return Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(),
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              sharedPreferences.getString("foto"),
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
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
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initPreference();
    // getUser();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            widget.settingMode
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        if (edit == true) {
                          edit = false;
                        } else if (edit == false) {
                          edit = true;
                        }
                      });
                    },
                    child: Icon(Icons.edit, color: Color(0xff0ABDB6)),
                  )
                : TextButton(
                    onPressed: () {
                      return NAlertDialog(
                        title: Text(
                          "Help",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0ABDB6)),
                        ),
                        content: Container(
                          height: 100,
                          child:
                              Text(helpContent, textAlign: TextAlign.center,maxLines: 10,),
                        ),
                        dismissable: false,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "I understand",
                              style: TextStyle(color: Color(0xff0ABDB6)),
                            ),
                          ),
                          //
                        ],
                      ).show(context);
                    },
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
                getImage(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences.getString("user_name") != null
                      ? sharedPreferences
                          .getString("user_name")
                          .capitalizeFirstofEach
                      : "Name",
                  style: TextStyle(
                      fontSize: 17,
                      color: Color(0xff818181),
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  sharedPreferences.getString("nim") != null
                      ? sharedPreferences.getString("nim")
                      : "NIM",
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
                      widget.page = 0;
                      widget.settingMode = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                DrawerMenu(
                  title: "Bookmarks",
                  onPressed: () {
                    setState(() {
                      widget.page = 1;
                      widget.settingMode = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                DrawerMenu(
                  title: "Settings",
                  onPressed: () {
                    setState(() {
                      widget.page = 2;
                      widget.settingMode = true;
                    });
                    Navigator.pop(context);
                  },
                ),
                DrawerMenu(
                  title: "About",
                  onPressed: () {
                    setState(() {
                      widget.page = 3;
                      widget.settingMode = false;
                    });
                    Navigator.pop(context);
                  },
                ),
                Expanded(child: Container()),
                TextButton(
                  onPressed: () {
                    logOut();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.power_settings_new, color: Colors.red),
                      SizedBox(
                        width: 3,
                      ),
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
        body: [
          FirstPage(
              // kelas: widget.kelas,
              // prodi: widget.prodi,
              // semester: widget.semester,
              ),
          FourthPage(),
          SecondPage(
            key: widget.key,
            isEdit: edit,
          ),
          ThirdPage(),
        ][widget.page],
      ),
    );
    // );
  }
}
