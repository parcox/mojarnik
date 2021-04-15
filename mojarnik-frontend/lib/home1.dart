import 'package:flutter/material.dart';
import 'package:mojarnik/widgets.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, child) => [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff1ABAB9),
                  ),
                  Center(
                    child: Opacity(
                      opacity: 0.25,
                      child: Image(
                        height: 200,
                        image: AssetImage("asset/polnep.png"),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xff19B5B4).withOpacity(0.37),
                          Colors.white.withOpacity(0.37),
                          Color(0xff19B5B4).withOpacity(0.37),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Teknik Elektro",
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "D-III Teknik Informatika",
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Text(
                          "Semester V",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              pinned: true,
              centerTitle: true,
              title: Center(
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                      color: Color(0xff11BCB7).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "10 Modules Available",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
          body: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 2),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: [
              Module(
                date: "13 March 2021",
                imageName: "asset/website.jpg",
                jumlahFile: 13,
                makul: "Pemrograman Web",
                title: "Praktikum 1",
              ),
              Module(
                date: "10 March 2021",
                imageName: "asset/binary.jpg",
                jumlahFile: 34,
                makul: "Sistem Operasi",
                title: "Bahasa Mesin",
              ),
              Module(
                date: "8 March 2021",
                imageName: "asset/math.jpg",
                jumlahFile: 5,
                makul: "Matematika",
                title: "Metode Krammer",
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // color: Colors.red,
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: TextButton(
              onPressed: (){},
              child: PhysicalModel(
                shape: BoxShape.circle,
                color: Colors.transparent,
                elevation: 5.0,
                shadowColor: Colors.black,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff0BBDB7),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
