import 'package:flutter/material.dart';
import 'package:mojarnik/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'module.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> listMakul = [
    {"id": 1, "name": "Komputer Animasi", "gambar": "asset/binary.jpg"},
    {"id": 2, "name": "Pengolahan Citra Digital", "gambar": "asset/binary.jpg"},
    {"id": 3, "name": "Kewarganegaraan", "gambar": "asset/binary.jpg"},
    {"id": 4, "name": "Sistem Keamanan Informasi", "gambar": "asset/binary.jpg"}
  ];
  FocusNode fcSearch;
  SharedPreferences sharedPreferences;
  TextEditingController searchController = TextEditingController();
  Future<List<Modules>> getModules() async {
    http.Response response;
    // Uri url = 'http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodul/'
    //     as Uri;
    response = await http.get(
        Uri.parse(
            "http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodul/"),
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
                setState(() {
                  
                });
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: FutureBuilder<List<Modules>>(
              future: getModules(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var modul = snapshot.data.where((x) => x.judul.toLowerCase().contains(searchController.text.toLowerCase()) || (listMakul.firstWhere((element) =>
                                    element["id"] == x.mataKuliah)["name"].toLowerCase()).contains(searchController.text.toLowerCase()));
                  return Column(
                      children: modul
                          .map((e) => SearchWidget(
                                modul: e,
                                imageName: listMakul.firstWhere((element) =>
                                    element["id"] == e.mataKuliah)["gambar"],
                                makul: listMakul.firstWhere((element) =>
                                    element["id"] == e.mataKuliah)["name"],
                              ))
                          .toList());
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
