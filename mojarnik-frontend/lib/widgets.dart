import 'package:flutter/material.dart';

class Module extends StatelessWidget {
  final String imageName;
  final String makul;
  final String date;
  final String title;
  final int jumlahFile;
  const Module({Key key, this.imageName, this.makul,this.date,this.title, this.jumlahFile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
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
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.date_range, color: Colors.white,size: 15,),
                                  Text(
                                    this.date,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              this.jumlahFile.toString()+" Files",
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
    );
  }
}
