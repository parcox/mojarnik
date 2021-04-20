import 'package:flutter/material.dart';
import 'package:mojarnik/widgets.dart';

class ModuleDetails extends StatefulWidget {
  @override
  _ModuleDetailsState createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  @override
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
                        image: AssetImage("asset/math.jpg"),
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
                          "Matematika",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "5 Files",
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
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 2),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: [
              ModuleFiles(
                title: "Cover",
                jumlahPage: 1,
              ),
              ModuleFiles(
                title: "BAB I",
                jumlahPage: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
