import 'package:flutter/material.dart';
import 'package:mojarnik/moduleDetails.dart';

class Module extends StatelessWidget {
  final String imageName;
  final String makul;
  final String date;
  final String title;
  final int jumlahFile;
  const Module(
      {Key key,
      this.imageName,
      this.makul,
      this.date,
      this.title,
      this.jumlahFile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ModuleDetails()));
      },
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          // height: 1200,
          decoration: BoxDecoration(
            color: Color(0xff0EBCB7),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(this.imageName),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              // color: Colors.yellow,
                              child: Text(
                                this.makul,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    Text(
                                      this.date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                this.jumlahFile.toString() + " Files",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        // color: Colors.red,
                        child: Text(
                          this.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  final String title;
  final Function onPressed;
  const DrawerMenu({Key key, @required this.title, @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Container(
        alignment: Alignment.center,
        width: 230,
        height: 30,
        // color: Colors.red,
        child: Text(
          this.title,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black),
        ),
      ),
    );
  }
}

class ModuleFiles extends StatelessWidget {
  final String title;
  final int jumlahPage;
  const ModuleFiles({Key key, this.title, this.jumlahPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          // height: 1200,
          decoration: BoxDecoration(
            color: Color(0xff0EBCB7),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("asset/paper.jpg"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            // color: Colors.yellow,
                            child: Text(
                              this.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Text(
                          this.jumlahPage.toString() + " Files",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  // color: Colors.red,
                  child: Text(
                    "Read",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final String imageName;
  final String makul;
  final String date;
  final String title;
  final int jumlahFile;
  const SearchWidget(
      {Key key,
      this.imageName,
      this.makul,
      this.date,
      this.title,
      this.jumlahFile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PhysicalModel(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        elevation: 5.0,
        shadowColor: Colors.black,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(this.imageName),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Opacity(
              opacity: 0.8,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black,
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 180,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(this.makul,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(this.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                ),
                                Text(
                                  this.date,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            this.jumlahFile.toString() + " Files",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
