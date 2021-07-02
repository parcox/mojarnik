import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mojarnik/bookmarks.dart';
import 'package:mojarnik/moduleDetail.dart';
import 'package:mojarnik/moduleDetails.dart';
import 'package:mojarnik/read.dart';
import 'package:mojarnik/user.dart';

import 'module.dart';

class Module extends StatelessWidget {
  
  // List matakuliah = ["Komputer Animasi", "Pengolahan Citra Dgigital", "Kewarganegaraan", "Sistem Keamanan Informasi"];
  // final String imageName;
  // final String makul;
  // final String date;
  // final String title;
  // final int jumlahFile;
  final Modules modul;
  const Module({
    Key key,
    this.modul,
    // this.date,
    // this.title,
    // this.jumlahFile
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listMakul = [
    {"id": 1, "name": "Komputer Animasi", "gambar": "asset/binary.jpg"},
    {"id": 2, "name": "Pengolahan Citra Digital", "gambar": "asset/binary.jpg"},
    {"id": 3, "name": "Kewarganegaraan", "gambar": "asset/binary.jpg"},
    {"id": 4, "name": "Sistem Keamanan Informasi", "gambar": "asset/binary.jpg"}
  ];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ModuleDetails(
              modul: modul,
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
                        image: AssetImage(listMakul.firstWhere((element) =>
                                  element["id"] == modul.mataKuliah)["gambar"]),
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
                                listMakul.firstWhere((element) =>
                                  element["id"] == modul.mataKuliah)["name"],
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
                          modul.judul,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
  const ModuleFiles({Key key, this.module, this.page})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ReadingPage(
                title: module.judul,
                pdf: module.file,
                page: this.page,
                id: module.id,
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
                              module.judul,
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
  final String makul;
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
    return Padding(
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
                  image: AssetImage(this.imageName),
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
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(this.makul,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(modul.judul,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
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
                                  DateFormat("dd MMMM yyyy").format(modul.tanggal),
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
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
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String content;
  final bool isEditable;
  const SettingsItem(
      {Key key,
      @required this.title,
      @required this.content,
      @required this.isEditable})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
                child: Text(
                  this.content,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              this.isEditable ? Icon(Icons.edit) : Container(),
            ],
          )
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
  final Bookmarks bookmark;
  const BookmarksWidget({
    Key key,
    @required this.bookmark,
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
      // onTap: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => ReadingPage(
      //         pdf:
      //             "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      //         title: this.moduleDetailTitle,
      //         page: bookmark.halaman,
      //       ),
      //     ),
      //   );
      // },
      child: Container(
        margin: EdgeInsets.only(top: 2, left: 3, right: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0083B0),
              Color(0xff00B4DB),
              Color(0xff0083B0),
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
                "Mata Kuliah ",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Module ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                "On " + "'s File",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                "Page "+bookmark.halaman.toString(),
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
                      "Bookmarked on "+DateFormat("dd MMMM yyyy").format(bookmark.tanggal),
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
    );
  }
}
