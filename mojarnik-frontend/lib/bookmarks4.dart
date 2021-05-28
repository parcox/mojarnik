import 'package:flutter/material.dart';
import 'package:mojarnik/read.dart';
import 'package:mojarnik/widgets.dart';

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text("Bookmarks"),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReadingPage(
                      pdf:
                          "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
                      title: "Tes",
                      page: 5,
                    ),
                  ),
                );
              },
              child: Text("Goto page 5"),
            )
          ],
        ),
      ),
    );
  }
}
