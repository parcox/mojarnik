import 'package:flutter/material.dart';
import 'package:mojarnik/instansi/jurusan.dart';
import 'package:mojarnik/instansi/makul.dart';
import 'package:mojarnik/instansi/prodi.dart';
import 'package:mojarnik/moduleClass/bookmarks.dart';
import 'package:mojarnik/moduleClass/module.dart';
import 'package:mojarnik/moduleClass/moduleDetail.dart';
import 'package:mojarnik/page/home.dart';
import 'package:mojarnik/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  SharedPreferences sharedPreferences;
  List<Jurusan> jurusan = [];
  List<Prodi> prodi = [];
  List<Modules> moduls = [];
  List<MataKuliah> makul = [];
  bool done = false;
  Future<ModuleDetail> getModuleDetail() async {
    http.Response response;
    response = await http.get(
        Uri.parse(
            "http://mojarnik.online/api/emodul/emoduldetail/"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'token ' + sharedPreferences.getString("token")
        });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      String jsonDataString = json.encode(jsonData[0]);
      final jsonDataa = jsonDecode(jsonDataString);
    }
    return null;
  }

  Future<List<ModuleDetail>> getModuleDetails() async {
    http.Response response;
    // Uri url = 'http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodul/'
    //     as Uri;
    response = await http.get(
        Uri.parse(
            "http://mojarnik.online/api/emodul/emoduldetail/"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'token ' + sharedPreferences.getString("token")
        });
    if (response.statusCode == 200) {
      List mapResponse = json.decode(response.body);
      return mapResponse.map((e) => ModuleDetail.fromJson(e)).toList().cast();
    }
    return null;
  }

  Future<List<Bookmarks>> getBookmark() async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse(
              "http://mojarnik.online/api/emodul/emodulbookmark/"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        List mapResponse = json.decode(response.body);
        return mapResponse.map((e) => Bookmarks.fromJson(e)).toList().cast();
      }

      return null;
    } catch (e) {
      setState(() {});
    }
  }

  getData() async {
    try {
      http.Response response;
      response = await http.get(
          Uri.parse(
              "http://mojarnik.online/api/akademik/programstudi/"),
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
                  "http://mojarnik.online/api/akademik/jurusan/"),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'token ' + sharedPreferences.getString("token")
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
                      "http://mojarnik.online/api/akademik/matakuliah/"),
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
                try {
                  response = await http.get(
                      Uri.parse(
                          "http://mojarnik.online/api/emodul/emodul/"),
                      headers: {
                        'Content-type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization':
                            'token ' + sharedPreferences.getString("token")
                      });
                  if (response.statusCode == 200) {
                    var jsonData = jsonDecode(response.body);
                    for (var i = 0; i < jsonData.length; i++) {
                      moduls.add(Modules.fromJson(jsonData[i]));
                    }
                    setState(() {
                      done = true;
                    });
                  }
                } catch (e) {
                  print("Gagal get modul");
                }
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
    done == false ? getData() : null;
    return Scaffold(
      body: done == false
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xff0ABDB6),
              ),
            )
          : FutureBuilder<List<Bookmarks>>(
              future: getBookmark(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  snapshot.data.sort(
                      (a, b) => b.id.compareTo(a.id));
                  var bookmarks = List.from(snapshot.data).reversed.where((element) =>
                      element.user == sharedPreferences.getInt("userId"));
                  return ListView(
                      children: bookmarks
                          .map((e) => FutureBuilder<List<ModuleDetail>>(
                                future: getModuleDetails(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var modul = List.from(snapshot.data)
                                        .firstWhere((element) =>
                                            element.id == e.dokumen);
                                    return BookmarksWidget(
                                      bookmark: e,
                                      moduleDetail: modul,
                                      module: moduls.firstWhere((element) =>
                                          element.id == modul.emodul),
                                      makul: makul.firstWhere(
                                        (element) =>
                                            element.id ==
                                            (moduls
                                                .firstWhere((element) =>
                                                    element.id == modul.emodul)
                                                .mataKuliah),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ))
                          .toList());
                }

                return Container();
              },
            ),
    );
  }
}
