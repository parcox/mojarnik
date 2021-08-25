// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:mojarnik/userClass/profilMahasiswa.dart';
import 'package:mojarnik/userClass/user.dart';
import 'package:mojarnik/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondPage extends StatefulWidget {
  final bool isEdit;
  const SecondPage({Key key, this.isEdit}) : super(key: key);
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // String phoneNumber = "081351963101";
  // XFile _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController hpController = TextEditingController();
  SharedPreferences sharedPreferences;
  var _image;
  bool isLoading = true;
  bool isStart = true;
  User user;
  Mahasiswa profil;
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
    });
  }

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  getData() async {
    http.Response response;
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
        var jsonData = jsonDecode(response.body);
        user = User.fromJson(jsonData);
        try {
          response = await http.get(
              Uri.parse(
                  "https://mojarnik-server.herokuapp.com/api/accounts/profilmahasiswa/?user=" +
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
          print(e);
          return print("Salah get mahasiswa");
        }

        // print(user.username);
      }
    } catch (e) {
      print(e);
      return print("Salah get user");
    }
  }

  ubahProfil(
    String first_name,
    String last_name,
    int gender,
    String email,
    String kelas,
  ) async {
    http.Response response;
    try {
      response = await http.patch(
          Uri.parse(
              "http://mojarnik-server.herokuapp.com/api/accounts/profilmahasiswa/" +
                  sharedPreferences.getInt("profilId").toString()),
          body: {
            "kelas": kelas,
          },
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        setState(() {});
      }
    } catch (e) {}
  }

  // _imgFromCamera() async {
  //   XFile image = await ImagePicker.pickImage(
  //       source: ImageSource.camera, imageQuality: 50);

  //   setState(() {
  //     _image = image;
  //   });
  // }

  // _imgFromGallery() async {
  //   XFile image = await ImagePicker.pickImage(
  //       source: ImageSource.gallery, imageQuality: 50);

  //   setState(() {
  //     _image = image;
  //   });
  // }
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
                activeColor: Theme.of(context).accentColor,
              ),
              Text(
                "Laki-laki",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
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
                activeColor: Theme.of(context).accentColor,
              ),
              Text("Perempuan",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  AssetImage tampilkanImage2() {
    return AssetImage("asset/markZuck.png");
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

  void initState() {
    initPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isStart ? getData() : null;
    // getMahasiswa();
    print(nameController.text.split(" "));
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xff0ABDB6),
            ),
          )
        : ListView(
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
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        // child: _image != null
                        //     ? Image.file(
                        //         File(_image.path),
                        //         fit: BoxFit.cover,
                        //       )
                        //     : Image(
                        //         image: AssetImage("asset/markZuck.png"),
                        //         fit: BoxFit.cover,
                        //       ),
                        child: Image(
                          image: tampilkanImage2(),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                                shape: BoxShape.circle,
                                color: Color(0xff0ABDB6)),
                            child: Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                // color: Colors.red,
                child: Column(
                  children: [
                    SettingsItem(
                      title: "Name",
                      // content: sharedPreferences
                      //     .getString("user_name")
                      //     .capitalizeFirstofEach,
                      content: (user.username + " " + user.lastName)
                          .capitalizeFirstofEach,
                          isEditable: widget.isEdit,
                      controller: nameController,
                    ),
                    SettingsItem(
                      title: "NIM",
                      content: "3201816094",
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
                                        user.gender == 1
                                            ? "Laki-laki"
                                            : "Perempuan",
                                        style: TextStyle(fontSize: 20),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SettingsItem(
                      title: "Phone Number",
                      content: user.noHp,
                      // content: sharedPreferences.getString("noHp"),
                      isEditable: widget.isEdit,
                      controller: hpController,
                    ),
                  ],
                ),
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(top: 10),
                //       child: Text(
                //         "Name",
                //         style: TextStyle(
                //           color: Color(0xff939393),
                //           fontSize: 18,
                //         ),
                //       ),
                //     ),
                //     Row(
                //       children: [
                //         Expanded(
                //           child: Text(
                //             sharedPreferences?.getString("name") ?? "",
                //             style: TextStyle(fontSize: 20),
                //           ),
                //         ),
                //         Icon(Icons.edit),
                //       ],
                //     )
                //   ],
                // ),
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
                          setState(() {
                            isStart=true;
                          });
                        },
                      ),
                    )
                  : Container(),
            ],
          );
  }
}
