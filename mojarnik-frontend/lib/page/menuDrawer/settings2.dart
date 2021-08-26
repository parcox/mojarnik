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
  var _image;
  bool isLoading = true;
  bool isStart = true;
  bool isStart2 = true;
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
    String url1 =
        "http://mojarnik-server.herokuapp.com/api/accounts/profilmahasiswa/" +
            profil.id.toString() +
            "/";
    String url2 =
        "https://mojarnik-server.herokuapp.com/api/accounts/customuser/" +
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
                // "kelas": kelas,
              },
              headers: headers);
          if (response.statusCode == 200) {
            var jsonData = response.body;
            String jsonDataString = jsonData.toString();
            final jsonDataa = jsonDecode(jsonDataString);
            sharedPreferences.setString("user_name",
                jsonDataa["first_name"] + " " + jsonDataa["last_name"]);
            print("Sukses update user");
            setState(() {
              if (isUpdating) {
                isUpdating = false;
                widget.isEdit = false;
              }
            });
          }
        } catch (e) {
          print("Gagal update user");
          print(e);
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
                  child: widget.isEdit
                      ? InkWell(
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
                        )
                      : Container(),
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
              // SettingsItem(
              //   title: "Name",
              //   // content: sharedPreferences
              //   //     .getString("user_name")
              //   //     .capitalizeFirstofEach,
              //   content:
              //       (user.username + " " + user.lastName).capitalizeFirstofEach,
              //   isEditable: widget.isEdit,
              //   controller: nameController,
              // ),
              Container(
                // height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        // child: Text(
                        //   widget.isEdit?"Nama Depan & Nama Belakang":"Nama",
                        //   style: TextStyle(
                        //     color: Color(0xff939393),
                        //     fontSize: 18,
                        //   ),
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
                // content: sharedPreferences.getString("noHp"),
                isEditable: widget.isEdit,
                controller: hpController,
              ),
              SettingsItem(
                title: "Kelas",
                content: profil.kelas,
                // content: sharedPreferences.getString("noHp"),
                isEditable: widget.isEdit,
                controller: kelasController,
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
                      isStart = true;
                      isUpdating = true;
                    });
                    ubahProfil(
                        firstNameController.text,
                        lastNameController.text,
                        _radioValue,
                        hpController.text,
                        kelasController.text);
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
            // child: _image != null
            //     ? Image.file(
            //         File(_image.path),
            //         fit: BoxFit.cover,
            //       )
            //     : Image(
            //         image: AssetImage("asset/markZuck.png"),
            //         fit: BoxFit.cover,
            //       ),
            // child: Image(
            //   image: tampilkanImage2(),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey.withOpacity(0.3),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
            // child: Center(
            //   child: CircularProgressIndicator(color: Colors.white),
            // ),

            // // color: Colors.red,
            // child: Column(
            //   children: [
            //     SettingsItem(
            //       title: "Name",
            //       // content: sharedPreferences
            //       //     .getString("user_name")
            //       //     .capitalizeFirstofEach,
            //       content:
            //           (user.username + " " + user.lastName).capitalizeFirstofEach,
            //       isEditable: widget.isEdit,
            //       controller: nameController,
            //     ),
            //     SettingsItem(
            //       title: "NIM",
            //       content: profil.nim,
            //       isEditable: false,
            //     ),
            //     Container(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(top: 10),
            //             child: Text(
            //               "Jenis Kelamin",
            //               style: TextStyle(
            //                 color: Color(0xff939393),
            //                 fontSize: 18,
            //               ),
            //             ),
            //           ),
            //           Row(
            //             children: [
            //               Expanded(
            //                 child: widget.isEdit
            //                     ? buildRadio()
            //                     : Text(
            //                         user.gender == 1 ? "Laki-laki" : "Perempuan",
            //                         style: TextStyle(fontSize: 20),
            //                       ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //     SettingsItem(
            //       title: "Phone Number",
            //       content: user.noHp,
            //       // content: sharedPreferences.getString("noHp"),
            //       isEditable: widget.isEdit,
            //       controller: hpController,
            //     ),
            //   ],
            // ),
            // // child: Column(
            // //   crossAxisAlignment: CrossAxisAlignment.start,
            // //   children: [
            // //     Padding(
            // //       padding: const EdgeInsets.only(top: 10),
            // //       child: Text(
            // //         "Name",
            // //         style: TextStyle(
            // //           color: Color(0xff939393),
            // //           fontSize: 18,
            // //         ),
            // //       ),
            // //     ),
            // //     Row(
            // //       children: [
            // //         Expanded(
            // //           child: Text(
            // //             sharedPreferences?.getString("name") ?? "",
            // //             style: TextStyle(fontSize: 20),
            // //           ),
            // //         ),
            // //         Icon(Icons.edit),
            // //       ],
            // //     )
            // //   ],
            // // ),
          ),
        ),
        // widget.isEdit
        //     ? Padding(
        //         padding: const EdgeInsets.only(top: 20),
        //         child: ElevatedButton(
        //           style: ButtonStyle(
        //               backgroundColor:
        //                   MaterialStateProperty.all(Color(0xff0ABDB6))),
        //           child: Padding(
        //             padding: const EdgeInsets.all(20),
        //             child: Text("Save"),
        //           ),
        //           onPressed: () {
        //             setState(() {
        //               isStart = true;
        //             });
        //           },
        //         ),
        //       )
        //     : Container(),
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
                  fontWeight: _radioValue==1? FontWeight.bold:FontWeight.w400,
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
                  fontWeight: _radioValue==2? FontWeight.bold:FontWeight.w400,
                ),
              ),
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
    return isLoading
        ?
        // Center(
        //     child: CircularProgressIndicator(
        //       color: Color(0xff0ABDB6),
        //     ),
        //   )
        buildPageBeforeLoading()
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
