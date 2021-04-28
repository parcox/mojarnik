import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadingPage extends StatefulWidget {
  final String title;
  final String pdf;
  const ReadingPage({Key key, this.title, this.pdf}) : super(key: key);
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [

      //     ],
      //   ),
      // ),
      body: Stack(
        children: [
          Container(
            child: SfPdfViewer.network(
              widget.pdf,
              canShowPaginationDialog: true,
              enableTextSelection: true,
              interactionMode: PdfInteractionMode.selection,
              searchTextHighlightColor: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Text("Comment", style: TextStyle(color: Colors.white),),
                  SizedBox(width: 10,),
                  Icon(Icons.arrow_upward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
