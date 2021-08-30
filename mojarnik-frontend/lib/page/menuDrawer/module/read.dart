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
  bool adding = false;
  FocusNode fcComment = FocusNode();
  bool userFilled = false;
  TextEditingController tfBookmark = TextEditingController();
  PdfViewerController _pdfViewerController;
  OverlayEntry _overlayEntry;
  SharedPreferences sharedPreferences;
  TextEditingController comment = TextEditingController();
  bool isError = false;
  bool isLoading = false;
  String error = "";
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

  List mapResponse;
  getUser() async {
    try {
      http.Response response;
      response = await http.get(
          Uri.parse("http://mojarnik.online/api/accounts/customuser/"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'token ' + sharedPreferences.getString("token")
          });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var i = 0; i < jsonData.length; i++) {
          listUser.add(User.fromJson(jsonData[i]));
        }
        setState(() {
          userFilled = true;
        });
      }
    } catch (e) {}
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
                          suffixIcon: adding?CircularProgressIndicator():InkWell(
                            onTap: () {
                              adding=true;
                              addComment(comment.text, widget.modul.id,
                                  sharedPreferences.getInt("userId"));
                            },
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff0ABDB6).withOpacity(0.7),
                                    ),
                                  )
                                : Icon(Icons.send),
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
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: FutureBuilder<List<Komentar>>(
                future: getComment(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var komen = List.from(snapshot.data)
                        .where((element) => element.dokumen == widget.modul.id);
                    return Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: komen.map((e) => CommentWidget(
                              komen: e,
                              user: listUser.firstWhere((element) => element.id==e.user),
                            )).toList(),
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
          Container(
            child: SfPdfViewer.network(
              widget.modul.file,
              canShowPaginationDialog: true,
              enableTextSelection: true,
              initialScrollOffset: Offset(0, 0),
              onDocumentLoaded: goto(),
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
