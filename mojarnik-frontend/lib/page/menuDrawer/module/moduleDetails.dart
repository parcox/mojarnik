import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mojarnik/instansi/makul.dart';
import 'package:mojarnik/moduleClass/module.dart';
import 'package:mojarnik/moduleClass/moduleDetail.dart';
import 'package:mojarnik/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleDetails extends StatefulWidget {
  final Modules modul;
  final MataKuliah makul;
  const ModuleDetails({
    Key key,
    this.modul,
    this.makul,
  }) : super(key: key);
  @override
  _ModuleDetailsState createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  SharedPreferences sharedPreferences;
  Future<List<ModuleDetail>> getModuleDetail() async {
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
      List mapResponse = json.decode(response.body);
      return mapResponse.map((e) => ModuleDetail.fromJson(e)).toList().cast();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Module Details",
          style: TextStyle(color: Color(0xff0ABDB6)),
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
      body: NestedScrollView(
        headerSliverBuilder: (context, child) => [
          SliverToBoxAdapter(
            child: Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Opacity(
                      opacity: 0.25,
                      child: Image(
                        image: AssetImage("asset/binary.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.makul.nama,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.modul.judul.capitalizeFirstofEach,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.modul.jumlahModul.toString() + " Files",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder<List<ModuleDetail>>(
            future: getModuleDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                snapshot.data.sort(
                      (a, b) => a.id.compareTo(b.id));
                var modulD = List.from(snapshot.data)
                    .where((x) => x.emodul == widget.modul.id);
                return GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 2,
                    children: modulD
                        .map((e) => ModuleFiles(module: e, page: 1))
                        .toList());
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
