import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mojarnik/instansi/makul.dart';
import 'package:mojarnik/page/menuDrawer/module/moduleDetails.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mojarnik/page/menuDrawer/module/read.dart';
import 'package:mojarnik/userClass/profilMahasiswa.dart';
import 'package:mojarnik/userClass/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numerus/numerus.dart';

import 'instansi/jurusan.dart';
import 'instansi/prodi.dart';
import 'moduleClass/bookmarks.dart';
import 'moduleClass/komen.dart';
import 'moduleClass/module.dart';
import 'moduleClass/moduleDetail.dart';

class Module extends StatelessWidget {
  final Modules modul;
  final List<MataKuliah> makul;
  const Module({Key key, this.modul, this.makul}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> listMakul = [
    //   {"id": 1, "name": "Komputer Animasi", "gambar": "asset/binary.jpg"},
    //   {
    //     "id": 2,
    //     "name": "Pengolahan Citra Digital",
    //     "gambar": "asset/binary.jpg"
    //   },
    //   {"id": 3, "name": "Kewarganegaraan", "gambar": "asset/binary.jpg"},
    //   {
    //     "id": 4,
    //     "name": "Sistem Keamanan Informasi",
    //     "gambar": "asset/binary.jpg"
    //   }
    // ];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ModuleDetails(
                  modul: modul,
                  makul: makul
                      .firstWhere((element) => element.id == modul.mataKuliah),
                )));
      },
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          // height: 1200,
          decoration: BoxDecoration(
            color: Color(0xff0EBCB7),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("asset/binary.jpg"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              // color: Colors.yellow,
                              child: Text(
                                makul
                                    .firstWhere((element) =>
                                        element.id == modul.mataKuliah)
                                    .nama
                                    .capitalizeFirstofEach,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text(
                                      DateFormat('dd MMMM yy')
                                          .format(modul.tanggal),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                modul.jumlahModul.toString() + " Files",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        // color: Colors.red,
                        child: Text(
                          modul.judul.capitalizeFirstofEach,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  final String title;
  final Function onPressed;
  const DrawerMenu({Key key, @required this.title, @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Container(
        alignment: Alignment.center,
        width: 230,
        height: 30,
        // color: Colors.red,
        child: Text(
          this.title,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black),
        ),
      ),
    );
  }
}

class ModuleFiles extends StatelessWidget {
  
  final ModuleDetail module;
  final int page;
  const ModuleFiles({Key key, this.module, this.page}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ReadingPage(
                // title: module.judul,
                // pdf: module.file,
                // page: this.page,
                // id: module.id,
                modul: this.module,
                page: this.page,
              ),
            ));
      },
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          // height: 1200,
          decoration: BoxDecoration(
            color: Color(0xff0EBCB7),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("asset/paper.jpg"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            // color: Colors.yellow,
                            child: Text(
                              module.judul.capitalizeFirstofEach,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Text(
                          module.jumlahHalaman.toString() + " Pages",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  // color: Colors.red,
                  child: Text(
                    "Read",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final String imageName;
  final MataKuliah makul;
  // final String date;
  // final String title;
  // final int jumlahFile;
  final Modules modul;
  const SearchWidget({
    Key key,
    this.modul,
    this.imageName,
    this.makul,
    // this.date,
    // this.title,
    // this.jumlahFile
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ModuleDetails(
                  modul: modul,
                  makul: makul,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          elevation: 5.0,
          shadowColor: Colors.black,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("asset/binary.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Opacity(
                opacity: 0.8,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(makul.nama.capitalizeFirstofEach,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              Text(
                                modul.judul.capitalizeFirstofEach,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                modul.judul.capitalizeFirstofEach,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 0.5
                                      ..color = Color(0xff0ABDB6),
                                    // color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    DateFormat("dd MMMM yyyy")
                                        .format(modul.tanggal),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              modul.jumlahModul.toString() + " Files",
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String content;
  final bool isEditable;
  final TextEditingController controller;
  final bool nameMode;
  SettingsItem(
      {Key key,
      @required this.title,
      @required this.content,
      @required this.isEditable,
      this.nameMode,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildTf() {
      controller.text = this.content;
      return TextField(
        decoration: InputDecoration(
            // labelText: this.content,
            // labelStyle: TextStyle(fontSize: 20),
            ),
        controller: controller,
      );
    }

    return Container(
      // height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              this.title,
              style: TextStyle(
                color: Color(0xff939393),
                fontSize: 18,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: isEditable
                    ? buildTf()
                    : Text(
                        this.content,
                        style: TextStyle(fontSize: 20),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingItems extends StatelessWidget {
  final User user;
  const SettingItems({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Name",
              style: TextStyle(
                color: Color(0xff939393),
                fontSize: 18,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  user.firstName + " " + user.lastName,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Icon(Icons.edit),
            ],
          )
        ],
      ),
    );
  }
}

class BookmarksWidget extends StatelessWidget {
  // final String moduleTitle;
  // final String moduleSubtitle;
  // final String moduleDetailTitle;
  // final int page;
  final MataKuliah makul;
  final Modules module;
  final ModuleDetail moduleDetail;
  final Bookmarks bookmark;
  const BookmarksWidget({
    Key key,
    @required this.bookmark,
    this.moduleDetail,
    this.makul,
    this.module,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TextButton(
    //   onPressed: () {
    //
    //   },
    //   child: Text("Goto page 5"),
    // )
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ReadingPage(
              modul: moduleDetail,
              page: bookmark.halaman,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 6, left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  [
                    Colors.purple,
                    Colors.green,
                    Colors.black,
                    Colors.blue,
                    Colors.brown,
                  ][bookmark.id % 5],
                  // Color(0xff0083B0),
                  [
                    Colors.green,
                    Colors.purple,
                    Colors.brown,
                    Colors.black,
                    Colors.blue,
                  ][bookmark.id % 5],
                  [
                    Colors.purple,
                    Colors.green,
                    Colors.black,
                    Colors.blue,
                    Colors.brown,
                  ][bookmark.id % 5],
                  // Color(0xff00B4DB),
                  // Color(0xff0083B0),
                ],
              ),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 7,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mata Kuliah " + makul.nama.capitalizeFirstofEach,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Modul " + module.judul.capitalizeFirstofEach,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Di dokumen " + moduleDetail.judul,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Halaman " + bookmark.halaman.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Icon(Icons.date_range, size: 15, color: Colors.white,),
                        Text(
                          "Ditandai pada tanggal " +
                              DateFormat("dd MMMM yyyy")
                                  .format(bookmark.tanggal),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(),
            padding: EdgeInsets.all(0),
            width: double.infinity,
            alignment: Alignment.topRight,
            height: MediaQuery.of(context).size.height / 7,
            // child: Icon(Icons.bookmark, size: 40),
            child: Transform.rotate(
              child: Icon(Icons.push_pin_sharp, size: 40, color: Color(0xff0ABDB6)),
              angle: 45 * 3.14 / 180,
            ),
            // color: Colors.green.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final User user;
  final Komentar komen;
  const CommentWidget({Key key, this.komen, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.grey,
              ),
              child: Image(image: AssetImage("asset/markZuck.png"),)
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.2)),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user.firstName + " " + user.lastName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(komen.comment),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Test extends StatelessWidget {
  final Mahasiswa users;
  const Test({
    Key key,
    @required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(users.kelas),
    );
  }
}

class DashMahasiswa extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final Jurusan jurusan;
  final Prodi prodi;
  // final String jurusan;
  // final String prodi;
  // final String semester;
  // final String kelas;
  const DashMahasiswa({Key key, this.jurusan, this.prodi, this.mahasiswa})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff1ABAB9),
          ),
          Center(
            child: Opacity(
              opacity: 0.25,
              child: Image(
                height: 200,
                image: AssetImage("asset/polnep.png"),
              ),
            ),
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff19B5B4).withOpacity(0.37),
                  Colors.white.withOpacity(0.37),
                  Color(0xff19B5B4).withOpacity(0.37),
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.21),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jurusan.nama,
                  // "tes",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    // listProdi.firstWhere((element) => element["id"] == sharedPreferences.getInt("prodi"))["name"],
                    prodi.nama,
                    // "tes",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Text(
                  "Semester " +
                      int.parse(mahasiswa.semester).toRomanNumeralString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  "Kelas " + mahasiswa.kelas,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
