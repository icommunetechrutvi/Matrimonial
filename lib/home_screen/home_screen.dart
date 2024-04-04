import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:matrimony/search_screen/search_screen.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'dart:developer';

import 'package:matrimony/ui_screen/side_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenNewState();
  }
}

class _HomeScreenNewState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final imageList = [
    'assets/card_image/imgs.jpg',
    'assets/card_image/benner_img.jpg',
    'assets/card_image/benner_img1.jpg',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = screenHeight > screenWidth;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CommonAppBar(
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
        text: "Home",
      ),
      // drawer: SideDrawer(onMenuItemSelected: (p0) => 0),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/bg_white.jpg",
              ),
              fit: BoxFit.cover
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(9),
                height: 240,
                // width: 500,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Swiper(
                  index: 1,
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length,
                  autoplay: true,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      // width: 900,
                      height: 100,
                      imageList[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i <= 4; i++)
                      Container(
                        height: 188,
                        width: 163,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            side: BorderSide(width: 3, color: Colors.transparent),
                          ),
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Image.asset(
                                  fit: BoxFit.fill,
                                  "assets/card_image/benner_img2.jpg",
                                  width: 146,
                                  height: 135,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(" Charlene Haig,24\n Cooperstown",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 800,
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        scaffoldKey: _scaffoldKey,
        key: Key("cv",),
        text: "Category",
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/bg_white.jpg",
            ),
            fit: BoxFit.fitHeight
          ),
        ),
      ),
    );
  }
}
