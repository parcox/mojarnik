import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mojarnik/page/home.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mojarnik",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Mojarnik'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int prodi;
  String semester;
  String kelas;
  List _gender = ["Perempuan", "Laki-laki"];
  SharedPreferences sharedPreferences;
  FocusNode fcPassword = FocusNode();
  FocusNode fcUsername = FocusNode();
  TextEditingController tfUsername = TextEditingController();
  TextEditingController tfPassword = TextEditingController();
  bool _isLoading = false;
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  List mapResponse;
  // getUser() async {
  //   var jsonData = null;
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   http.Response response;
  //   try {
  //     response = await http.get(
  //         Uri.parse(
  //             "https://mojarnik-server.herokuapp.com/api/accounts/customuser/" +
  //                 sharedPreferences.getInt("userId").toString()),
  //         headers: {
  //           'Content-type': 'application/json',
  //           'Accept': 'application/json',
  //           'Authorization': 'token ' + sharedPreferences.getString("token")
  //         });
  //     if (response.statusCode == 200) {
  //       jsonData = response.body;
  //       String jsonDataString = jsonData.toString();
  //       final jsonDataa = jsonDecode(jsonDataString);
  //       sharedPreferences.setString("user_name",
  //           jsonDataa["first_name"] + " " + jsonDataa["last_name"]);
  //       sharedPreferences.setString("gender", _gender[jsonDataa["gender"]]);
  //       sharedPreferences.setString("noHp", jsonDataa["no_hp"]);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  logIn(String username, String password) async {
    if (username == "" || password == "") {
      return NAlertDialog(
        dialogStyle: DialogStyle(backgroundColor: Colors.white),
        title: Text(
          "Peringatan",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff0ABDB6),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Username atau password tidak boleh kosong!",
          style: TextStyle(color: Color(0xff0ABDB6)),
        ),
        actions: [
          TextButton(
            child: Text(
              "Kembali Login",
              style: TextStyle(
                color: Color(0xff0ABDB6),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ).show(context);
    }
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(
          Uri.parse("https://mojarnik-server.herokuapp.com/api/token-auth/"),
          body: {"username": username, "password": password});
      if (response.statusCode == 200) {
        jsonData = response.body;
        String jsonDataString = jsonData.toString();
        final jsonDataa = jsonDecode(jsonDataString);
        sharedPreferences.setString("token", jsonDataa["token"]);
        sharedPreferences.setInt("userId", jsonDataa["user_id"]);
        try {
          response = await http.get(
              Uri.parse(
                  "https://mojarnik-server.herokuapp.com/api/accounts/customuser/" +
                      sharedPreferences.getInt("userId").toString()),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'token ' + sharedPreferences.getString("token")
              });
          if (response.statusCode == 200) {
            jsonData = response.body;
            String jsonDataString = jsonData.toString();
            final jsonDataa = jsonDecode(jsonDataString);
            sharedPreferences.setString("user_name",
                jsonDataa["first_name"] + " " + jsonDataa["last_name"]);
            sharedPreferences.setString("foto", jsonDataa["foto"]);
            // sharedPreferences.setString("gender", jsonDataa["gender"]);
            // sharedPreferences.setString("noHp", jsonDataa["no_hp"]);
            // try {
            //   response = await http.get(
            //       Uri.parse(
            //           "https://mojarnik-server.herokuapp.com/api/accounts/profilmahasiswa/?user=" +
            //               sharedPreferences.getInt("userId").toString()),
            //       headers: {
            //         'Content-type': 'application/json',
            //         'Accept': 'application/json',
            //         'Authorization':
            //             'token ' + sharedPreferences.getString("token")
            //       });
            //   if (response.statusCode == 200) {
            //     var jsonData = jsonDecode(response.body);
            //     String jsonDataString = json.encode(jsonData[0]);
            //     final jsonDataa = jsonDecode(jsonDataString);
            //     sharedPreferences.setInt("profilId", jsonDataa["id"]);
            //     sharedPreferences.setInt("prodi", jsonDataa["prodi"]);
            //     sharedPreferences.setString("semester", jsonDataa["semester"]);
            //     sharedPreferences.setString("kelas", jsonDataa["kelas"]);
            return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        // kelas: sharedPreferences.getString("kelas"),
                        // prodi: sharedPreferences.getInt("prodi"),
                        // semester: sharedPreferences.getString("semester"),
                        )),
                (Route<dynamic> route) => false);
            //   }
            //   return null;
            // } catch (e) {
            //   print(e);
            // }
          }
        } catch (e) {
          print(e);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        return NAlertDialog(
          dialogStyle: DialogStyle(backgroundColor: Colors.white),
          title: Text(
            "Peringatan",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff0ABDB6),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Username atau password salah!",
            style: TextStyle(color: Color(0xff0ABDB6)),
          ),
          actions: [
            TextButton(
              child: Text(
                "Kembali Login",
                style: TextStyle(
                  color: Color(0xff0ABDB6),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ).show(context);
      }
    } catch (e) {
      setState(() {});
    }
    // if (username == "tes" && password == "tes") {
    //   return Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => HomePage(),
    //     ),
    //   );
    // }
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => new HomePage(

                  // kelas: sharedPreferences.getString("kelas"),
                  // prodi: sharedPreferences.getInt("prodi"),
                  // semester: sharedPreferences.getString("semester"),
                  )),
          (Route<dynamic> route) => false);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new NAlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit ?'),
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

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          fcPassword.unfocus();
          fcUsername.unfocus();
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff06BEB6),
                        Color(0xff48B1BF),
                        Color(0xff00E1FF).withOpacity(0.43),
                      ]),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                        "asset/polnep.png",
                      ),
                      height: 150,
                      width: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "MOJARNIK",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Stormfaze",
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      width: 300,
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            // color: Colors.red,
                            child: Container(
                              child: Image(
                                image: AssetImage("asset/person.png"),
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            width: 0,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                focusNode: fcUsername,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),
                                controller: tfUsername,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                                cursorColor: Color(0xff00FFFF),
                                style: TextStyle(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      width: 300,
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            // color: Colors.red,
                            child: Container(
                              // transformAlignment: ,
                              child: Transform.rotate(
                                angle: 3.9,
                                child: Image(
                                  image: AssetImage("asset/key.png"),
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            width: 0,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: tfPassword,
                                focusNode: fcPassword,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) {
                                  node.unfocus();
                                  logIn(tfUsername.text, tfPassword.text);
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                                cursorColor: Color(0xff00FFFF),
                                style: TextStyle(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    _isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              logIn(tfUsername.text, tfPassword.text);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xff00FFFF),
                                    Color(0xff00C9C9),
                                    Color(0xff00FFFF),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  alignment: Alignment.bottomCenter,
                  child: Text("Copyright © 2021 Patra Purbaya"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
