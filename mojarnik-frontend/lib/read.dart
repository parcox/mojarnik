import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadingPage extends StatefulWidget {
  final String title;
  final String pdf;
  final int page;
  const ReadingPage({Key key, this.title, this.pdf, this.page})
      : super(key: key);
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  PdfViewerController _pdfViewerController;
  OverlayEntry _overlayEntry;
  TextEditingController comment = TextEditingController();
  void showBottom() {
    showFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.7,
      maxHeight: 0.7,
      context: context,
      builder: _buildBottomSheet,
      anchors: [0, 0.5, 1],
    );
  }

  // Future<List<int>> _readDocumentData(String name) async {
  //   final ByteData data = await rootBundle.load("assets/$name");
  //   return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  // }
  @override
  void initState() {
    // TODO: implement initState
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion.center.dy - 55,
        left: details.globalSelectedRegion.bottomLeft.dx,
        child: Container(
          height: 40,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)),
          child: IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  height: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: details.selectedText));
                      print('Text copied to clipboard: ' +
                          details.selectedText.toString());
                      _pdfViewerController.clearSelection();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      // elevation: MaterialStateProperty.all(10),
                    ),
                    child: Text('Copy',
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 2,
                  color: Colors.grey.withOpacity(0.6),
                ),
                SizedBox(
                  height: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // PdfDocument document = PdfDocument(inputBytes: await _readDocumentData(‘pdf_succinctly.pdf’));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      // elevation: MaterialStateProperty.all(10),
                    ),
                    child: Text('Highlight',
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    _overlayState.insert(_overlayEntry);
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          child: NestedScrollView(
            headerSliverBuilder: (context, child) => [
              SliverAppBar(
                pinned: true,
                centerTitle: true,
                toolbarHeight: 30,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Container(
                  color: Colors.transparent,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff0ABDB6).withOpacity(0.7),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      height: 30,
                      width: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Comment",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_downward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                toolbarHeight: 150,
                backgroundColor: Colors.grey[50],
                title: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add Comment",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      TextField(
                        controller: comment,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.send),
                        ),
                        maxLines: null,
                      ),
                      // Row(
                      //   children: [
                      //     TextField(),
                      //     Icon(Icons.send, color: Colors.black,),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
            body: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Colors.green,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Colors.red,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Colors.yellow,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Colors.teal,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Colors.brown,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  goto() {
    _pdfViewerController.jumpToPage(widget.page);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Add Bookmark'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Page"),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "1, 2, 3, ...",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff0ABDB6), width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  // color: Color(0xff0ABDB6),
                  color: Colors.black
                ),
              ),
            ),
            cursorColor: Color(0xff0ABDB6),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xff0ABDB6)),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Add',
            style: TextStyle(color: Color(0xff0ABDB6)),
          ),
        ),
      ],
    );
  }

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
        actions: [
          TextButton(
            onPressed: () {
              // _pdfViewerController.searchText("succinctly");
            },
            child: Icon(
              Icons.search,
              color: Color(0xff0ABDB6),
            ),
          ),
          TextButton(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.bookmark,
                  color: Color(0xff0ABDB6),
                  size: 30,
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            child: SfPdfViewer.network(
              widget.pdf,
              canShowPaginationDialog: true,
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText == null && _overlayEntry != null) {
                  _overlayEntry.remove();
                  _overlayEntry = null;
                } else if (details.selectedText != null &&
                    _overlayEntry == null) {
                  _showContextMenu(context, details);
                }
              },
              enableTextSelection: true,
              initialScrollOffset: Offset(0, 0),
              onDocumentLoaded: goto(),
              interactionMode: PdfInteractionMode.selection,
              searchTextHighlightColor: Colors.blue,
              controller: _pdfViewerController,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Color(0xff0ABDB6).withOpacity(0.7),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        showBottom();
                      },
                      child: Row(
                        children: [
                          Text(
                            "Comment",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_upward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
