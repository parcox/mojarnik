import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mojarnik/instansi/jurusan.dart';
import 'package:mojarnik/instansi/makul.dart';
import 'package:mojarnik/instansi/prodi.dart';
import 'package:mojarnik/moduleClass/module.dart';
import 'package:mojarnik/userClass/profilMahasiswa.dart';
import 'package:mojarnik/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numerus/numerus.dart';
import '../search.dart';

class FirstPage extends StatefulWidget {
  final int prodi;
  final String semester;
  final String kelas;
  const FirstPage({Key key, this.prodi, this.semester, this.kelas})
      : super(key: key);
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool done = false;
  bool secondDone = false;
  int jumlahModul = 0;
  int idProdi;
  Mahasiswa mahasiswa;
  List<Prodi> prodi = [];
  List<Jurusan> jurusan = [];
  List<MataKuliah> makul = [];
  Prodi prodiMhs;
  Jurusan jurusanMhs;
  SharedPreferences sharedPreferences;
  List mapResponse;
  List<Widget> listWidget=[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ];

  Future<List<Modules>> getModules() async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse("https://mojarnik-server.herokuapp.com/api/emodul/emodul/"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        List mapResponse = json.decode(response.body);
        if (jumlahModul == 0) {
          setState(() {
            jumlahModul = mapResponse.length;
          });
        }
        return mapResponse.map((e) => Modules.fromJson(e)).toList().cast();
      }

      return null;
    } catch (e) {}
  }

  getData() async {
    //jurusan
    try {
      http.Response response;
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
        mahasiswa = Mahasiswa.fromJson(jsonData[0]);
        try {
          http.Response response;
          response = await http.get(
              Uri.parse(
                  "https://mojarnik-server.herokuapp.com/api/akademik/programstudi/"),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'token ' + sharedPreferences.getString("token")
              });
          print(response.statusCode);
          if (response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            for (var i = 0; i < jsonData.length; i++) {
              prodi.add(Prodi.fromJson(jsonData[i]));
            }
            try {
              http.Response response;
              response = await http.get(
                  Uri.parse(
                      "https://mojarnik-server.herokuapp.com/api/akademik/jurusan/"),
                  headers: {
                    'Content-type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization':
                        'token ' + sharedPreferences.getString("token")
                  });
              print(response.statusCode);
              if (response.statusCode == 200) {
                var jsonData = jsonDecode(response.body);
                for (var i = 0; i < jsonData.length; i++) {
                  jurusan.add(Jurusan.fromJson(jsonData[i]));
                }
                try {
                  http.Response response;
                  response = await http.get(
                      Uri.parse(
                          "https://mojarnik-server.herokuapp.com/api/akademik/matakuliah/"),
                      headers: {
                        'Content-type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization':
                            'token ' + sharedPreferences.getString("token")
                      });
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    var jsonData = jsonDecode(response.body);
                    for (var i = 0; i < jsonData.length; i++) {
                      makul.add(MataKuliah.fromJson(jsonData[i]));
                    }
                    setState(() {
                      prodiMhs = prodi.firstWhere(
                          (element) => element.id == mahasiswa.prodi);
                      jurusanMhs = jurusan
                          .firstWhere((element) => element.id == prodiMhs.id);
                      done = true;
                      secondDone = done;
                    });
                  }
                } catch (e) {
                  print("Gagal get makul");
                }
              }
            } catch (e) {
              print("Gagal get jurusan");
            }
          }
        } catch (e) {
          print("Gagal get prodi");
        }
      }
    } catch (e) {
      print("Gagal get mahasiswa");
      print(e);
    }
  }

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 3));
    // done = false;

    setState(() {
      secondDone = false;
    });
  }

  void initState() {
    super.initState();
    initPreference();
    // setData();
  }

  @override
  Widget build(BuildContext context) {
    done == false ? getData() : null;
    secondDone == false ? getData() : null;
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
                  // done == false
                  //     ? Center(
                  //         child: CircularProgressIndicator(
                  //           color: Color(0xff0ABDB6),
                  //         ),
                  //       )
                  // :
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          done
                              ? jurusanMhs.nama.capitalizeFirstofEach
                              : "Jurusan",
                          // widget.prodi.toString(),
                          // "tes",
                          // "jurusan",
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            done
                                ? prodiMhs.nama.capitalizeFirstofEach
                                : "Program Studi",
                            // widget.prodi.toString(),
                            // "prodi",
                            // "tes",
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Text(
                          "Semester " +
                              (done
                                  ? int.parse(mahasiswa.semester)
                                      .toRomanNumeralString()
                                  : "0"),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "Kelas " +
                              (done ? mahasiswa.kelas.toUpperCase() : " "),
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
              // pinned: true,
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
          body:
              // secondDone == false
              // ?
              // Center(
              //     child: CircularProgressIndicator(
              //       color: Color(0xff0ABDB6),
              //     ),
              //   )
              // :
              RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<List<Modules>>(
              future: getModules(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var modul = List.from(snapshot.data);
                  return GridView.count(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2,
                      children: secondDone?modul
                          .map((e) => Module(
                                modul: e,
                                makul: makul,
                              ))
                          .toList():listWidget);
                } else if (snapshot.hasError) {
                  return Container(
                    color: Colors.black.withOpacity(0.1),
                    child: Center(
                      child: Text("Error Occured"),
                    ),
                  );
                }
                return GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                  children: listWidget,
                );
              },
            ),
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
