import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mojarnik/module.dart';
import 'package:mojarnik/search.dart';
import 'package:mojarnik/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int jumlahModul;
  SharedPreferences sharedPreferences;
  List<Map<String, dynamic>> listMakul = [
    {"id": 1, "name": "Komputer Animasi", "gambar": "asset/binary.jpg"},
    {"id": 2, "name": "Pengolahan Citra Digital", "gambar": "asset/binary.jpg"},
    {"id": 3, "name": "Kewarganegaraan", "gambar": "asset/binary.jpg"},
    {"id": 4, "name": "Sistem Keamanan Informasi", "gambar": "asset/binary.jpg"}
  ];
  List mapResponse;

  Future<List<Modules>> getModules() async {
    http.Response response;
    // Uri url = 'http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodul/'
    //     as Uri;
    try {
      response = await http.get(
          Uri.parse(
              "http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodul/"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        mapResponse = json.decode(response.body);
        if (jumlahModul==null){
          setState(() {
            jumlahModul=mapResponse.length;
          });
        }
        return mapResponse.map((e) => Modules.fromJson(e)).toList().cast();
      }
      
    return null;
    } catch (e) {
    }
  }

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPreference();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, child) => [
            SliverToBoxAdapter(
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
                          "Teknik Elektro",
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "D-III Teknik Informatika",
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Text(
                          "Semester VI",
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
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              pinned: true,
              centerTitle: true,
              title: Center(
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                      color: Color(0xff11BCB7).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "$jumlahModul Modules Available",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
          body: FutureBuilder<List<Modules>>(
            future: getModules(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var modul = List.from(snapshot.data);
                return GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 2,
                    children: modul
                        .map((e) => Module(
                              modul: e,
                            ))
                        .toList());
              }

              return Container();
            },
          ),
          // Module(
          //   date: "13 March 2021",
          //   imageName: "asset/website.jpg",
          //   jumlahFile: 13,
          //   makul: "Pemrograman Web",
          //   title: "Praktikum 1",
          // ),
          // Module(
          //   date: "10 March 2021",
          //   imageName: "asset/binary.jpg",
          //   jumlahFile: 34,
          //   makul: "Sistem Operasi",
          //   title: "Bahasa Mesin",
          // ),
          // Module(
          //   date: "8 March 2021",
          //   imageName: "asset/math.jpg",
          //   jumlahFile: 5,
          //   makul: "Matematika",
          //   title: "Metode Krammer",
          // ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // color: Colors.red,
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SearchPage()));
              },
              child: PhysicalModel(
                shape: BoxShape.circle,
                color: Colors.transparent,
                elevation: 5.0,
                shadowColor: Colors.black,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff0BBDB7),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
