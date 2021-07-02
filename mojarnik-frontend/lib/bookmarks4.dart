import 'package:flutter/material.dart';
import 'package:mojarnik/bookmarks.dart';
import 'package:mojarnik/read.dart';
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
  Future<List<Bookmarks>> getBookmark() async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse(
              "http://students.ti.elektro.polnep.ac.id:8000/api/emodul/emodulbookmark/"),
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
    return Scaffold(
      body: FutureBuilder<List<Bookmarks>>(
            future: getBookmark(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var bookmarks = List.from(snapshot.data).where((element) => element.user==sharedPreferences.getInt("userId"));
                return ListView(
                  children: bookmarks
                        .map((e) => BookmarksWidget(
                              bookmark: e,
                            ))
                        .toList()
                );
              }

              return Container();
            },
          ),
        // child: Column(
        //   children: [
        //     BookmarksWidget(
        //       moduleTitle: "Pemrograman Web",
        //       moduleSubtitle: "Praktikum 1",
        //       moduleDetailTitle: "Latihan 1",
        //       page: 5,
        //     ),
        //     // TextButton(
        //     //   onPressed: () {
        //     //     Navigator.of(context).push(
        //     //       MaterialPageRoute(
        //     //         builder: (BuildContext context) => ReadingPage(
        //     //           pdf:
        //     //               "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
        //     //           title: "Tes",
        //     //           page: 5,
        //     //         ),
        //     //       ),
        //     //     );
        //     //   },
        //     //   child: Text("Goto page 5"),
        //     // )
        //   ],
        // ),
      
    );
  }
}
