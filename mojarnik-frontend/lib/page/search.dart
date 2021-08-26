import 'package:flutter/material.dart';
import 'package:mojarnik/instansi/jurusan.dart';
import 'package:mojarnik/instansi/makul.dart';
import 'package:mojarnik/moduleClass/module.dart';
import 'package:mojarnik/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // List<Map<String, dynamic>> listMakul = [
  //   {"id": 1, "name": "Komputer Animasi", "gambar": "asset/binary.jpg"},
  //   {"id": 2, "name": "Pengolahan Citra Digital", "gambar": "asset/binary.jpg"},
  //   {"id": 3, "name": "Kewarganegaraan", "gambar": "asset/binary.jpg"},
  //   {"id": 4, "name": "Sistem Keamanan Informasi", "gambar": "asset/binary.jpg"}
  // ];
  FocusNode fcSearch;
  SharedPreferences sharedPreferences;
  TextEditingController searchController = TextEditingController();
  List<Jurusan> jurusan = [];
  List<MataKuliah> makul = [];
  bool done = false;

  Future<List<Modules>> getModules() async {
    http.Response response;
    // Uri url = 'http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodul/'
    //     as Uri;
    response = await http.get(
        Uri.parse("https://mojarnik-server.herokuapp.com/api/emodul/emodul/"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'token ' + sharedPreferences.getString("token")
        });
    if (response.statusCode == 200) {
      List mapResponse = json.decode(response.body);
      return mapResponse.map((e) => Modules.fromJson(e)).toList().cast();
    }
    return null;
  }

  getData() async {
    //jurusan
    try {
      http.Response response;
      response = await http.get(
          Uri.parse(
              "https://mojarnik-server.herokuapp.com/api/akademik/jurusan/"),
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
        // jurusan = Jurusan.fromJson(jsonData);
        // List.from(jsonData).forEach((element) {
        //   jurusan.add(Jurusan.fromJson(element));
        // });
        //mata kuliah
        try {
          http.Response response;
          response = await http.get(
              Uri.parse(
                  "https://mojarnik-server.herokuapp.com/api/akademik/matakuliah/"),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'token ' + sharedPreferences.getString("token")
              });
          print(response.statusCode);
          if (response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            for (var i = 0; i < jsonData.length; i++) {
              makul.add(MataKuliah.fromJson(jsonData[i]));
            }
            setState(() {
              done = true;
            });
            // print(jurusan.runtimeType);
          }
        } catch (e) {
          print("Gagal get jurusan");
        }
        // print(jurusan.runtimeType);
      }
    } catch (e) {
      print("Gagal get jurusan");
      print(e);
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
    // try {
    //   print(makul[0]);
    // } catch (e) {
    //   print(e);
    //   print("no data makul");
    // }
    final node = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        node.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.only(top: 5),
            // color: Colors.blue,
            child: TextField(
              cursorColor: Color(0xff0ABDB6),
              onChanged: (_) {
                setState(() {});
              },
              focusNode: fcSearch,
              controller: searchController,
              style: TextStyle(color: Color(0xff0ABDB6)),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Color(0xff0ABDB6).withOpacity(0.5),
                ),
                hintText: "Search",
                border: InputBorder.none,
                suffixIcon: Container(
                  width: 70,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          FocusScope.of(context).unfocus();
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.black.withOpacity(0.5),
                        size: 20,
                      )),
                ),
              ),
            ),
          ),
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xff0ABDB6),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: done == false
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0ABDB6),
                    ),
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: FutureBuilder<List<Modules>>(
                    future: getModules(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var modul = snapshot.data.where((x) =>
                            x.judul.toLowerCase().contains(
                                searchController.text.toLowerCase()) ||
                            (makul.where(
                                    (element) => element.id == x.mataKuliah))
                                .contains(searchController.text.toLowerCase()));
                        return Column(
                            children: modul
                                .map((e) => SearchWidget(
                                      modul: e,
                                      // imageName: listMakul.firstWhere((element) =>
                                      //     element["id"] == e.mataKuliah)["gambar"],
                                      imageName: "asset/binary.jpg",
                                      // makul: listMakul.firstWhere((element) =>
                                      //     element["id"] == e.mataKuliah)["name"],
                                      makul: makul.firstWhere((element) =>
                                          element.id == e.mataKuliah),
                                    ))
                                .toList());
                      }
                      if (snapshot.data == null) {
                        return Container();
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff0ABDB6),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
