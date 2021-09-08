import 'package:flutter/material.dart';
import 'package:mojarnik/instansi/jurusan.dart';
import 'package:mojarnik/instansi/makul.dart';
import 'package:mojarnik/moduleClass/module.dart';
import 'package:mojarnik/userClass/profilMahasiswa.dart';
import 'package:mojarnik/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> makul;
  const SearchPage({Key key, this.mahasiswa, this.makul}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode fcSearch;
  SharedPreferences sharedPreferences;
  TextEditingController searchController = TextEditingController();
  List<Jurusan> jurusan = [];
  List<MataKuliah> makul = [];
  bool done = false;

  Future<List<Modules>> getModules() async {
    http.Response response;
    response = await http.get(
        Uri.parse("http://mojarnik.online/api/emodul/emodul/"),
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
        // jurusan = Jurusan.fromJson(jsonData);
        // List.from(jsonData).forEach((element) {
        //   jurusan.add(Jurusan.fromJson(element));
        // });
        //mata kuliah
        try {
          http.Response response;
          response = await http.get(
              Uri.parse(
                  "http://mojarnik.online/api/akademik/matakuliah/"),
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
                        var modul1 = List.from(snapshot.data.where((mo) =>
                        (makul
                            .firstWhere((ma) => ma.id == mo.mataKuliah)
                            .programStudi) ==
                        widget.mahasiswa.prodi&&(makul
                            .firstWhere((ma) => ma.id == mo.mataKuliah)
                            .semester) ==
                        widget.mahasiswa.semester));
                        var modul = modul1.where((x) =>
                            x.judul.toLowerCase().contains(
                                searchController.text.toLowerCase()) ||
                            // (makul.where(
                            //         (element) => element.id == x.mataKuliah))
                            //     .contains(searchController.text.toLowerCase()));
                            (makul.firstWhere(
                                    (m) => m.id == x.mataKuliah)).nama.toLowerCase()
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
