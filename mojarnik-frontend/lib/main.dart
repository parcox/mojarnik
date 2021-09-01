import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mojarnik/page/home.dart';
import 'package:mojarnik/page/launcher.dart';
import 'package:ndialog/ndialog.dart';
import 'dart:io';
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
      // home: LoginPage(title: 'Mojarnik'),
      home: LauncherPage(),
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

  // checkConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('connected');
  //     }
  //   } on SocketException catch (_) {
  //     print('not connected');
  //   }
  // }

  List mapResponse;
  // secondLogin() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   http.Response response;
  //   try {
  //     response = await http.get(
  //         Uri.parse("http://mojarnik.online/api/accounts/customuser/" +
  //             sharedPreferences.getInt("userId").toString()),
  //         headers: {
  //           'Content-type': 'application/json',
  //           'Accept': 'application/json',
  //           'Authorization': 'token ' + sharedPreferences.getString("token")
  //         });
  //     if (response.statusCode == 200) {
  //       var jsonData = response.body;
  //       String jsonDataString = jsonData.toString();
  //       final jsonDataa = jsonDecode(jsonDataString);
  //       sharedPreferences.setString("user_name",
  //           jsonDataa["first_name"] + " " + jsonDataa["last_name"]);
  //       sharedPreferences.setString("foto", jsonDataa["foto"]);
  //       try {
  //         response = await http.get(
  //             Uri.parse(
  //                 "http://mojarnik.online/api/accounts/profilmahasiswa/?user=" +
  //                     sharedPreferences.getInt("userId").toString()),
  //             headers: {
  //               'Content-type': 'application/json',
  //               'Accept': 'application/json',
  //               'Authorization': 'token ' + sharedPreferences.getString("token")
  //             });
  //         if (response.statusCode == 200) {
  //           var jsonData = response.body;
  //           String jsonDataString = jsonData.toString();
  //           final jsonDataa = jsonDecode(jsonDataString);
  //           sharedPreferences.setString("nim", jsonDataa[0]["nim"]);
  //           return Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(
  //                   builder: (context) => HomePage(
  //                         page: 0,
  //                       )),
  //               (Route<dynamic> route) => false);
  //         }
  //       } catch (e) {
  //         print("Gagal get profilUser");
  //         print(e);
  //       }
  //       // return Navigator.of(context).pushAndRemoveUntil(
  //       //     MaterialPageRoute(builder: (context) => HomePage()),
  //       //     (Route<dynamic> route) => false);
  //     }
  //   } catch (e) {
  //     print("Gagal get customUser");
  //     print(e);
  //   }
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
          Uri.parse("http://mojarnik.online/api/token-auth/"),
          body: {"username": username, "password": password});
      if (response.statusCode == 200) {
        jsonData = response.body;
        String jsonDataString = jsonData.toString();
        final jsonDataa = jsonDecode(jsonDataString);
        sharedPreferences.setString("token", jsonDataa["token"]);
        sharedPreferences.setInt("userId", jsonDataa["user_id"]);
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
            jsonData = response.body;
            String jsonDataString = jsonData.toString();
            final jsonDataa = jsonDecode(jsonDataString);
            if (jsonDataa["role"] != 1 || jsonDataa["username"] == "admin") {
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
                  "Anda tidak memiliki akses untuk masuk",
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
                      sharedPreferences.clear();
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  )
                ],
              ).show(context);
            }
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
                    'Authorization':
                        'token ' + sharedPreferences.getString("token")
                  });
              if (response.statusCode == 200) {
                var jsonData = response.body;
                String jsonDataString = jsonData.toString();
                final jsonDataa = jsonDecode(jsonDataString);
                sharedPreferences.setString("nim", jsonDataa[0]["nim"]);
                try {
                  response = await http.patch(
                      Uri.parse(
                          "http://mojarnik.online/api/accounts/customuser/" +
                              sharedPreferences.getInt("userId").toString() +
                              "/"),
                      body: {
                        "last_login": DateTime.now().toString()
                      },
                      headers: {
                        'Authorization':
                            'token ' + sharedPreferences.getString("token")
                      });
                  if (response.statusCode == 200) {
                    var jsonData = response.body;
                    String jsonDataString = jsonData.toString();
                    final jsonDataa = jsonDecode(jsonDataString);
                    print("Sukses patch");
                    print(jsonDataa["last_login"].toString());
                    return Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  page: 0,
                                  settingMode: false,
                                )),
                        (Route<dynamic> route) => false);
                  } else {
                    print(response.body);
                  }
                } catch (e) {
                  print("Salah patch");
                  print(e);
                }
              }
            } catch (e) {
              print("Gagal get profilUser");
              print(e);
            }
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
  }

  // checkLoginStatus() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.getString("token") != null) {
  //     secondLogin();
  //   }
  // }

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
  void initState() {
    // checkConnection();
    super.initState();
    // checkLoginStatus();
  }

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
                  mainAxisSize: MainAxisSize.min,
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
                              node.unfocus();
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
            ],
          ),
        ),
      ),
    );
  }
}
