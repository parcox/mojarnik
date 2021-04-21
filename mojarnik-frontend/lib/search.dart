import 'package:flutter/material.dart';
import 'package:mojarnik/widgets.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode fcSearch;
  TextEditingController searchController = TextEditingController();
  @override
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
              onChanged: (_){},
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
          child: Column(
            children: [
              SearchWidget(
                makul: "Pemrograman Web",
                title: "Praktikum 1",
                date: "13 March 2021",
                jumlahFile: 13,
                imageName: "asset/website.jpg",
              ),
              SearchWidget(
                makul: "Sistem Operasi",
                title: "Bahasa Mesin",
                date: "10 March 2021",
                jumlahFile: 34,
                imageName: "asset/binary.jpg",
              ),
              SearchWidget(
                makul: "Matematika",
                title: "Metode Krammer",
                date: "8 March 2021",
                jumlahFile: 5,
                imageName: "asset/math.jpg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
