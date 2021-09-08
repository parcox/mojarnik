// import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:mojarnik/page/home.dart';
import 'package:mojarnik/userClass/profilMahasiswa.dart';
import 'package:mojarnik/userClass/user.dart';
import 'package:mojarnik/widgets.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondPage extends StatefulWidget {
  bool isEdit;
  SecondPage({Key key, this.isEdit}) : super(key: key);
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // String phoneNumber = "081351963101";
  // XFile _image;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController hpController = TextEditingController();
  TextEditingController kelasController = TextEditingController();
  SharedPreferences sharedPreferences;
  bool isUpdating = false;
  PickedFile _image;
  bool isLoading = true;
  bool isStart = true;
  bool isStart2 = true;
  User user;
  Mahasiswa profil;
  MultipartFile gambar;
  int _radioValue;
  void _handleRadio(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: source,
        barrierDismissible: true,
        cameraIcon: Icon(
          Icons.camera_alt,
          color: Colors.red,
        ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
        cameraText: Text(
          "From Camera",
          style: TextStyle(color: Colors.red),
        ),
        galleryText: Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    setState(() {
      _image = image;
      print(_image.runtimeType);
    });
    try {
      String token = sharedPreferences.getString("token");
      Dio dioo = Dio();
      dioo.options.headers['content-Type'] = 'multipart/form-data;';
      dioo.options.headers["Authorization"] = "token $token";
      FormData formData = new FormData.fromMap(
          // {"foto": await http.MultipartFile.fromPath("foto", _image.path)});
          {
            "foto": await MultipartFile.fromFile(_image.path),
            "last_login": DateTime.now().toString(),
          });
      var response = await dioo.patch(
        "http://mojarnik.online/api/accounts/customuser/" +
            user.id.toString() +
            "/",
        data: formData,
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        print("sukses update foto");
        var jsonData = response.data;
        sharedPreferences.setString("foto", jsonData["foto"]);
        return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HomePage(
                      page: 2,
                      settingMode: true,
                    )),
            (Route<dynamic> route) => false);
      } else {
        return null;
      }
      // http.Response response;
      // FormData formData = FormData.fromMap({
      //   "foto": await http.MultipartFile.fromPath("foto", _image.path),
      // });
      // String token = sharedPreferences.getString("token");
      // Map<String, String> headers = {'Authorization': 'token ' + token};
      // response = await http.patch(
      //   Uri.parse(
      //     "http://mojarnik.online/api/accounts/customuser/" +
      //         user.id.toString() +
      //         "/",
      //   ),
      //   body: formData,
      //   headers: headers,
      // );
      // if (response.statusCode == 200) {
      //   print("Sukses ganti foto profil");
      // }
    } catch (e) {
      print("gagal update foto");
      print(e);
    }
  }

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  getData() async {
    print(sharedPreferences.getInt("userId"));
    http.Response response;
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
        var jsonData = jsonDecode(response.body);
        user = User.fromJson(jsonData);
        try {
          response = await http.get(
              Uri.parse(
                  "http://mojarnik.online/api/accounts/profilmahasiswa/?user=" +
                      sharedPreferences.getInt("userId").toString()),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'token ' + sharedPreferences.getString("token")
              });
          if (response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            profil = Mahasiswa.fromJson(jsonData[0]);
            setState(() {
              isLoading = false;
              _radioValue = user.gender;
              isStart = false;
            });
          }
        } catch (e) {
          print("Salah get mahasiswa");

          print(e);
        }

        // print(user.username);
      }
    } catch (e) {
      print("Salah get user");
      print(e);
    }
  }

  List<Widget> buildTf() {
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    List<Widget> row = [
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),

            // labelText: "First Name",
            // labelStyle: TextStyle(fontSize: 20),
          ),
          controller: firstNameController,
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            // labelText: "Last Name",
            // labelStyle: TextStyle(fontSize: 20),
          ),
          controller: lastNameController,
        ),
      ),
    ];
    return row;
  }

  ubahProfil(String firstName, String lastName, int gender, String noHp,
      String kelas) async {
    String url1 = "http://mojarnik.online/api/accounts/profilmahasiswa/" +
        profil.id.toString() +
        "/";
    String url2 = "http://mojarnik.online/api/accounts/customuser/" +
        user.id.toString() +
        "/";

    String token = sharedPreferences.getString("token");
    Map<String, String> headers = {'Authorization': 'token ' + token};
    http.Response response;
    try {
      response = await http.patch(Uri.parse(url1),
          body: {
            // "first_name": firstName,
            // "last_name": lastName,
            // "gender": gender,
            // "no_hp": noHp,
            "kelas": kelas,
          },
          headers: headers);
      if (response.statusCode == 200) {
        print("Sukses update mahasiswa");
        try {
          response = await http.patch(Uri.parse(url2),
              body: {
                "first_name": firstName,
                "last_name": lastName,
                "gender": gender.toString(),
                "no_hp": noHp,
                "last_login": DateTime.now().toString(),
                // _image != null
                //     ? "foto"
                //     : http.MultipartFile.fromPath("foto", _image.path): null,
                // "kelas": kelas,
              },
              headers: headers);
          if (response.statusCode == 200) {
            var jsonData = response.body;
            String jsonDataString = jsonData.toString();
            final jsonDataa = jsonDecode(jsonDataString);
            sharedPreferences.setString("user_name",
                jsonDataa["first_name"] + " " + jsonDataa["last_name"]);
            sharedPreferences.setString("foto", jsonDataa["foto"]);
            print("Sukses update user");
            setState(() {
              if (isUpdating) {
                isUpdating = false;
                widget.isEdit = false;
              }
            });
            return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          page: 2,
                          settingMode: false,
                        )),
                (Route<dynamic> route) => false);
          } else {
            print(response.body);
          }
        } catch (e) {
          print("Gagal update user");
          print(e);
          setState(() {
            isUpdating = false;
          });
        }
      }
    } catch (e) {
      print("Gagal update mahasiswa");
      print(e);
    }
  }

  Widget buildPageAfterLoading() {
    return ListView(
      children: [
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Container(
                    clipBehavior: Clip.antiAlias,
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: tampilkanImage2()),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        getImage(ImgSource.Both);
                      },
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
                    )),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: widget.isEdit
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Nama Depan",
                                      style: TextStyle(
                                        color: Color(0xff939393),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Nama Belakang",
                                      style: TextStyle(
                                        color: Color(0xff939393),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Nama",
                                style: TextStyle(
                                  color: Color(0xff939393),
                                  fontSize: 18,
                                ),
                              )),
                    Row(
                      children: widget.isEdit
                          ? buildTf()
                          : [
                              Text(
                                (user.firstName + " " + user.lastName)
                                    .capitalizeFirstofEach,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                    ),
                  ],
                ),
              ),
              SettingsItem(
                title: "NIM",
                content: profil.nim,
                isEditable: false,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Jenis Kelamin",
                        style: TextStyle(
                          color: Color(0xff939393),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: widget.isEdit
                              ? buildRadio()
                              : Text(
                                  user.gender == 1 ? "Laki-laki" : "Perempuan",
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SettingsItem(
                title: "Nomor Telepon",
                content: user.noHp,
                isEditable: widget.isEdit,
                controller: hpController,
              ),
              SettingsItem(
                title: "Kelas",
                content: profil.kelas,
                isEditable: widget.isEdit,
                controller: kelasController,
              ),
            ],
          ),
        ),
        widget.isEdit
            ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff0ABDB6))),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Save"),
                  ),
                  onPressed: () {
                    if (firstNameController.text == "" ||
                        lastNameController.text == "" ||
                        hpController.text == "" ||
                        kelasController.text == "") {
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
                          "Field tidak boleh kosong!",
                          style: TextStyle(color: Color(0xff0ABDB6)),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              "Close",
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
                    } else {
                      setState(() {
                        isStart = true;
                        isUpdating = true;
                      });
                      ubahProfil(
                          firstNameController.text,
                          lastNameController.text,
                          _radioValue,
                          hpController.text,
                          kelasController.text);
                    }
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  Widget buildPageBeforeLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            clipBehavior: Clip.antiAlias,
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey.withOpacity(0.3),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }

  Widget buildRadio() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _handleRadio,
                activeColor: Color(0xff0ABDB6),
              ),
              Text(
                "Laki-laki",
                style: TextStyle(
                  color: Color(0xff0ABDB6),
                  fontWeight:
                      _radioValue == 1 ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Radio(
                value: 2,
                groupValue: _radioValue,
                onChanged: _handleRadio,
                activeColor: Color(0xff0ABDB6),
              ),
              Text(
                "Perempuan",
                style: TextStyle(
                  color: Color(0xff0ABDB6),
                  fontWeight:
                      _radioValue == 2 ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  tampilkanImage2() {
    // if (_image == null) {
    //   return Image(
    //     image: NetworkImage(sharedPreferences.getString("foto")),
    //     fit: BoxFit.cover,
    //   );
    // }
    // return Image.file(
    //   File(_image.path),
    //   fit: BoxFit.cover,
    // );
    try {
      if (_image == null) {
        return Image(
          image: NetworkImage(sharedPreferences.getString("foto")),
          fit: BoxFit.cover,
        );
      }
      return Image.file(
        File(_image.path),
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Image(
        image: AssetImage("asset/markZuck.png"),
        fit: BoxFit.cover,
      );
    }
  }

  NetworkImage tampilkanImage1() {
    try {
      return NetworkImage(
        user.foto,
      );
    } catch (e) {
      tampilkanImage2();
    }
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  void initState() {
    initPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isStart ? getData() : null;
    // getMahasiswa();
    return isLoading
        ? buildPageBeforeLoading()
        : Stack(
            children: [
              buildPageAfterLoading(),
              isUpdating
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey.withOpacity(0.4),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xff0ABDB6),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Updating Data...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
  }
}
