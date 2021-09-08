import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pdfdownload/pdfdownload.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mojarnik/moduleClass/komen.dart';
import 'package:mojarnik/moduleClass/moduleDetail.dart';
import 'package:mojarnik/userClass/user.dart';
import 'package:mojarnik/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadingPage extends StatefulWidget {
  final int page;
  final ModuleDetail modul;
  const ReadingPage({Key key, this.modul, this.page}) : super(key: key);
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool adding = false;
  FocusNode fcComment = FocusNode();
  bool userFilled = false;
  TextEditingController tfBookmark = TextEditingController();
  PdfViewerController _pdfViewerController = PdfViewerController();
  OverlayEntry _overlayEntry;
  SharedPreferences sharedPreferences;
  TextEditingController comment = TextEditingController();
  bool isError = false;
  bool isLoading = false;
  Uint8List _documentBytes;
  String error = "";
  double yOffset = 0.0;
  double xOffset = 0.0;
  List<User> listUser = [];
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

  getBytes() async {
    _documentBytes = await http.readBytes(Uri.parse(widget.modul.file));
    setState(() {});
  }

  List mapResponse;
  getUser() async {
    print(sharedPreferences.getString("token"));
    try {
      http.Response response;
      response = await http.get(
          Uri.parse("http://mojarnik.online/api/accounts/customuser/?role=1"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var i = 0; i < jsonData.length; i++) {
          listUser.add(User.fromJson(jsonData[i]));
          print(User.fromJson(jsonData[i]).username);
        }
        setState(() {
          userFilled = true;
        });
      }
    } catch (e) {
      print("gagal get user");
      print(e);
      setState(() {
        userFilled = true;
      });
    }
  }

  // Future<List<User>> futureGetUser() async {
  //   try {
  //     http.Response response;
  //     response = await http.get(
  //         Uri.parse("http://mojarnik.online/api/accounts/customuser/"),
  //         headers: {
  //           'Content-type': 'application/json',
  //           'Accept': 'application/json',
  //           'Authorization': 'token ' + sharedPreferences.getString("token")
  //         });
  //     if (response.statusCode == 200) {
  //       mapResponse = json.decode(response.body);
  //       return mapResponse.map((e) => User.fromJson(e)).toList().cast();
  //     }
  //   } catch (e) {}
  // }

  Future<List<Komentar>> getComment() async {
    http.Response response;
    try {
      response = await http.get(
          Uri.parse("http://mojarnik.online/api/emodul/emodulcomment"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        mapResponse = json.decode(response.body);
        return mapResponse.map((e) => Komentar.fromJson(e)).toList().cast();
      }
      return null;
    } catch (e) {}
  }

  addBookmark(int halaman, int dokumen, int user) async {
    var jsonData = null;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(
          Uri.parse("http://mojarnik.online/api/emodul/emodulbookmark/"),
          body: {
            "halaman": "$halaman",
            "dokumen": "$dokumen",
            "user": "$user"
          },
          headers: {
            'Authorization': 'token ' + sharedPreferences.getString("token"),
          });
      if (response.statusCode == 201) {
        print("Success");
      } else
        print(response.statusCode);
    } catch (e) {}
  }

  addComment(String _comment, int _dokumen, int _user) async {
    var jsonData = null;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(
          Uri.parse("http://mojarnik.online/api/emodul/emodulcomment/"),
          body: {
            "comment": "$_comment",
            "dokumen": "$_dokumen",
            "user": "$_user"
          },
          headers: {
            'Authorization': 'token ' + sharedPreferences.getString("token"),
          });
      if (response.statusCode == 201) {
        setState(() {
          comment.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          adding = false;
        });
        //
      } else
        print(response.statusCode);
    } catch (e) {}
  }

  initPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getBytes();
    _pdfViewerController = PdfViewerController();
    super.initState();
    initPreference();
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return SafeArea(
      child: Material(
        // color: Colors.transparent,
        child: Container(
          child: NestedScrollView(
            headerSliverBuilder: (context, child) => [
              SliverAppBar(
                pinned: true,
                centerTitle: true,
                toolbarHeight: 30,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Container(
                  // color: Colors.transparent,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Color(0xff0ABDB6).withOpacity(0.7),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(15),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                // pinned: true,
                toolbarHeight: 100,
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
                        // focusNode: fcComment,
                        controller: comment,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          suffixIcon: adding
                              ? CircularProgressIndicator()
                              : InkWell(
                                  onTap: () {
                                    if (comment.text != "") {
                                      addComment(comment.text, widget.modul.id,
                                          sharedPreferences.getInt("userId"));
                                    }
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Icon(Icons.send),
                                ),
                        ),
                        maxLength: 500,
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
            body: listUser == null
                ? Container()
                : GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: FutureBuilder<List<Komentar>>(
                      future: getComment(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          snapshot.data.sort((a, b) => b.id.compareTo(a.id));
                          var komen = List.from(snapshot.data).where(
                              (element) => element.dokumen == widget.modul.id);
                          return Container(
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: komen
                                      .map((e) => CommentWidget(
                                            komen: e,
                                            user: listUser.firstWhere(
                                                (element) =>
                                                    element.id == e.user),
                                          ))
                                      .toList(),
                                  // children: komen
                                  //     .map(
                                  //       (e) => FutureBuilder<List<User>>(
                                  //         future: getUser(),
                                  //         builder: (context, snapshot) {
                                  //           try {
                                  //             var user = List.from(snapshot.data)
                                  //                 .firstWhere((element) =>
                                  //                     element.id == e.user);
                                  //             if (snapshot.hasData) {
                                  //               return CommentWidget(
                                  //                 komen: e,
                                  //                 user: user,
                                  //               );
                                  //             }
                                  //           } catch (e) {}
                                  //           return Container();
                                  //         },
                                  //       ),
                                  //     )
                                  //     .toList(),
                                  // children: komen
                                  //     .map(
                                  //       (e) => FutureBuilder<List<User>>(
                                  //         future: futureGetUser(),
                                  //         builder: (context, snapshot) {
                                  //           try {
                                  //             var user = List.from(snapshot.data)
                                  //                 .firstWhere((element) =>
                                  //                     element.id == e.user);
                                  //             if (snapshot.hasData) {
                                  //               return CommentWidget(
                                  //                 komen: e,
                                  //                 user: user,
                                  //               );
                                  //             }
                                  //           } catch (e) {}
                                  //           return Container();
                                  //         },
                                  //       ),
                                  //     )
                                  //     .toList(),
                                ),
                              ));
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff0ABDB6).withOpacity(0.7),
                          ),
                        );
                      },
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
    tfBookmark.clear();
    return new AlertDialog(
      title: const Text('Add Bookmark'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Page"),
          TextField(
            keyboardType: TextInputType.number,
            controller: tfBookmark,
            // autofocus: true,
            // onTap: () {
            //   tfBookmark.clear();
            // },
            decoration: InputDecoration(
              hintText: widget.modul.jumlahHalaman == 1
                  ? "1"
                  : "1 sampai " + widget.modul.jumlahHalaman.toString(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff0ABDB6), width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    // color: Color(0xff0ABDB6),
                    color: Colors.black),
              ),
              errorText: error == "" ? null : error,
              errorStyle: TextStyle(
                height: 2,
              ),
            ),

            cursorColor: Color(0xff0ABDB6),
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          onPressed: () {
            if (tfBookmark.text.isEmpty) {
              setState(() {
                error = "Masukkan nomor halaman";
              });
              Navigator.of(context).pop();
              return showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            } else if (int.parse(tfBookmark.text) >
                widget.modul.jumlahHalaman) {
              setState(() {
                error = "Tidak dapat melebihi halaman " +
                    widget.modul.jumlahHalaman.toString();
              });
              Navigator.of(context).pop();
              return showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            } else if (int.parse(tfBookmark.text) < 1) {
              setState(() {
                error = "Tidak dapat kurang dari halaman " +
                    widget.modul.jumlahHalaman.toString();
              });
              Navigator.of(context).pop();
              return showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            }
            error = "";
            addBookmark(int.parse(tfBookmark.text), widget.modul.id,
                sharedPreferences.getInt("userId"));
            Navigator.of(context).pop();
          },
          child: const Text(
            'Add',
            style: TextStyle(color: Color(0xff0ABDB6)),
          ),
        ),
      ],
    );
  }

  _showContextMenu(
    BuildContext context,
    PdfTextSelectionChangedDetails details,
  ) {
    final RenderBox renderBoxContainer =
        context.findRenderObject() as RenderBox;
    if (renderBoxContainer != null) {
      final double _kContextMenuHeight = 30;
      final double _kContextMenuWidth = 100;
      final double _kHeight = 18;
      final Offset containerOffset = renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.topLeft,
      );
      if (details != null &&
              containerOffset.dy < details.globalSelectedRegion.topLeft.dy ||
          (containerOffset.dy <
                  details.globalSelectedRegion.center.dy -
                      (_kContextMenuHeight / 2) &&
              details.globalSelectedRegion.height > _kContextMenuWidth)) {
        double top = 0.0;
        double left = 0.0;
        final Rect globalSelectedRect = details.globalSelectedRegion;
        if ((globalSelectedRect.top) > MediaQuery.of(context).size.height / 2) {
          top = globalSelectedRect.topLeft.dy +
              details.globalSelectedRegion.height +
              _kHeight;
          left = globalSelectedRect.bottomLeft.dx;
        } else {
          top = globalSelectedRect.height > _kContextMenuWidth
              ? globalSelectedRect.center.dy - (_kContextMenuHeight / 2)
              : globalSelectedRect.topLeft.dy +
                  details.globalSelectedRegion.height +
                  _kHeight;
          left = globalSelectedRect.height > _kContextMenuWidth
              ? globalSelectedRect.center.dx - (_kContextMenuWidth / 2)
              : globalSelectedRect.bottomLeft.dx;
        }
        final OverlayState _overlayState =
            Overlay.of(context, rootOverlay: true);
        _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: top,
            left: left,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.14),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              constraints: BoxConstraints.tightFor(
                  width: _kContextMenuWidth, height: _kContextMenuHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _addAnnotation('Highlight', details.selectedText),
                  // _addAnnotation('Underline', details.selectedText),
                  // _addAnnotation('Strikethrough', details.selectedText),
                ],
              ),
            ),
          ),
        );
        _overlayState?.insert(_overlayEntry);
      }
    }
  }

  Widget _addAnnotation(String annotationType, String selectedText) {
    return Container(
      height: 30,
      width: 100,
      child: RawMaterialButton(
        onPressed: () async {
          _checkAndCloseContextMenu();
          await Clipboard.setData(ClipboardData(text: selectedText));
          _drawAnnotation(annotationType);
        },
        child: Text(
          annotationType,
          style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 10,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  ///Draw the annotation in a PDF document.
  void _drawAnnotation(String annotationType) {
    final PdfDocument document = PdfDocument(inputBytes: _documentBytes);
    switch (annotationType) {
      case 'Highlight':
        {
          _pdfViewerKey.currentState
              .getSelectedTextLines()
              .forEach((pdfTextLine) {
            final PdfPage _page = document.pages[pdfTextLine.pageNumber];
            final PdfRectangleAnnotation rectangleAnnotation =
                PdfRectangleAnnotation(
                    pdfTextLine.bounds, 'Highlight Annotation',
                    author: 'Syncfusion',
                    color: PdfColor.fromCMYK(0, 0, 255, 0),
                    innerColor: PdfColor.fromCMYK(0, 0, 255, 0),
                    opacity: 0.5);
            _page.annotations.add(rectangleAnnotation);
            _page.annotations.flattenAllAnnotations();
            xOffset = _pdfViewerController.scrollOffset.dx;
            yOffset = _pdfViewerController.scrollOffset.dy;
          });
          final List<int> bytes = document.save();
          setState(() {
            _documentBytes = Uint8List.fromList(bytes);
          });
        }
        break;
      // case 'Underline':
      //   {
      //     _pdfViewerKey.currentState
      //         .getSelectedTextLines()
      //         .forEach((pdfTextLine) {
      //       final PdfPage _page = document.pages[pdfTextLine.pageNumber];
      //       final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
      //         [
      //           pdfTextLine.bounds.left.toInt(),
      //           (document.pages[pdfTextLine.pageNumber].size.height –
      //                   pdfTextLine.bounds.bottom)
      //               .toInt(),
      //           pdfTextLine.bounds.right.toInt(),
      //           (document.pages[pdfTextLine.pageNumber].size.height –
      //                   pdfTextLine.bounds.bottom)
      //               .toInt()
      //         ],
      //         'Underline Annotation',
      //         author: 'Syncfusion',
      //         innerColor: PdfColor(0, 255, 0),
      //         color: PdfColor(0, 255, 0),
      //       );
      //       _page.annotations.add(lineAnnotation);
      //       _page.annotations.flattenAllAnnotations();
      //       xOffset = _pdfViewerController.scrollOffset.dx;
      //       yOffset = _pdfViewerController.scrollOffset.dy;
      //     });
      //     final List<int> bytes = document.save();
      //     setState(() {
      //       _documentBytes = Uint8List.fromList(bytes);
      //     });
      //   }
      //   break;
      // case 'Strikethrough':
      //   {
      //     _pdfViewerKey.currentState!
      //         .getSelectedTextLines()
      //         .forEach((pdfTextLine) {
      //       final PdfPage _page = document.pages[pdfTextLine.pageNumber];
      //       final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
      //         [
      //           pdfTextLine.bounds.left.toInt(),
      //           ((document.pages[pdfTextLine.pageNumber].size.height –
      //                       pdfTextLine.bounds.bottom) +
      //                   (pdfTextLine.bounds.height / 2))
      //               .toInt(),
      //           pdfTextLine.bounds.right.toInt(),
      //           ((document.pages[pdfTextLine.pageNumber].size.height –
      //                       pdfTextLine.bounds.bottom) +
      //                   (pdfTextLine.bounds.height / 2))
      //               .toInt()
      //         ],
      //         'Strikethrough Annotation',
      //         author: 'Syncfusion',
      //         innerColor: PdfColor(255, 0, 0),
      //         color: PdfColor(255, 0, 0),
      //       );
      //       _page.annotations.add(lineAnnotation);
      //       _page.annotations.flattenAllAnnotations();
      //       xOffset = _pdfViewerController.scrollOffset.dx;
      //       yOffset = _pdfViewerController.scrollOffset.dy;
      //     });
      //     final List<int> bytes = document.save();
      //     setState(() {
      //       _documentBytes = Uint8List.fromList(bytes);
      //     });
      //   }
      //   break;
    }
  }

  /// Check and close the context menu.
  void _checkAndCloseContextMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    userFilled ? null : getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.modul.judul.capitalizeFirstofEach,
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
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: DownloandPdf(
              isUseIcon: true,
              pdfUrl: widget.modul.file,
              fileNames: widget.modul.judul + ".pdf",
              color: Color(0xff0ABDB6),
              iconSize: 32,
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
              tfBookmark.clear();
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Container(
          //   child: SfPdfViewer.network(
          //     widget.modul.file,
          //     canShowPaginationDialog: true,
          //     enableTextSelection: true,
          //     initialScrollOffset: Offset(0, 0),
          //     onDocumentLoaded: goto(),
          //     searchTextHighlightColor: Colors.blue,
          //     controller: _pdfViewerController,
          //   ),),
          _documentBytes != null
              ? Container(
                  child: SfPdfViewer.memory(
                    _documentBytes,
                    key: _pdfViewerKey,
                    canShowPaginationDialog: true,
                    controller: _pdfViewerController,
                    onDocumentLoaded: goto(),
                    initialScrollOffset: Offset(0, 0),
                    onTextSelectionChanged:
                        (PdfTextSelectionChangedDetails details) {
                      if (details.selectedText == null &&
                          _overlayEntry != null) {
                        _checkAndCloseContextMenu();
                      } else if (details.selectedText != null &&
                          _overlayEntry == null) {
                        _showContextMenu(context, details);
                      }
                    },
                  ),
                )
              : Container(),
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
