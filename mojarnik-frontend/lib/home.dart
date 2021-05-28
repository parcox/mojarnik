import 'package:flutter/material.dart';
import 'package:mojarnik/about3.dart';
import 'package:mojarnik/bookmarks4.dart';
import 'package:mojarnik/home1.dart';
import 'package:mojarnik/main.dart';
import 'package:mojarnik/settings2.dart';
import 'package:mojarnik/widgets.dart';
import 'package:ndialog/ndialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 0;
  String helpContent =
      "\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed molestie congue orci, pellentesque rhoncus eros sollicitudin quis. Quisque varius tempus nisl gravida scelerisque. Nullam diam arcu, consequat a massa vehicula, vehicula dictum urna. Nam enim nunc, malesuada eu tincidunt sit amet, vehicula vitae enim. Sed quis lobortis odio. In fermentum facilisis magna, ac dignissim nulla. Aenean id scelerisque nisl, at egestas ante. Quisque imperdiet, justo quis hendrerit condimentum, tortor ex varius odio, eu fermentum velit quam eget sapien. Donec scelerisque, tortor non elementum vestibulum, augue libero scelerisque eros, vitae eleifend elit eros sit amet magna. Morbi molestie eros non purus maximus, quis egestas ante tincidunt. Ut interdum sapien at tellus finibus molestie. Duis euismod eros nisl. Aenean scelerisque justo eget ultrices interdum. Vestibulum a nisi orci. Quisque facilisis dolor eu pellentesque euismod.";
  logOut() {
    return NAlertDialog(
      title: Text("Are you sure ?"),
      content: Text("Do you want to log out from your account ?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginPage(),
              ),
              ModalRoute.withName("/")
            );
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
    )) ?? false;
  }

  @override
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
            TextButton(
              onPressed: () {
                return NAlertDialog(
                  title: Text(
                    "Help",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xff0ABDB6)),
                  ),
                  content: Container(
                    child: Text(helpContent, textAlign: TextAlign.justify),
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
                    Navigator.pop(context);
                  },
                ),
                DrawerMenu(
                  title: "Bookmarks",
                  onPressed: () {
                    setState(() {
                      page = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
                DrawerMenu(
                  title: "Settings",
                  onPressed: () {
                    setState(() {
                      page = 2;
                    });
                    Navigator.pop(context);
                  },
                ),
                DrawerMenu(
                  title: "About",
                  onPressed: () {
                    setState(() {
                      page = 3;
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
        body: <Widget>[
          FirstPage(),
          FourthPage(),
          SecondPage(),
          ThirdPage(),
        ][page],
      ),
    );
  }
}
