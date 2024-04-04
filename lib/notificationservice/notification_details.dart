import 'package:flutter/material.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';



class NotificationDetailsScreen extends StatefulWidget {
  var id;
  var name;

  NotificationDetailsScreen({super.key,required this.id,required this.name});

  @override
  State<StatefulWidget> createState() {  return _NotificationDetailScreenState();
  }
}

class _NotificationDetailScreenState extends  State<NotificationDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    print("TEXT~~~${widget.id}");
    print("TEXT~~~${widget.name}");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 255, 241, 241),
      appBar: CommonAppBar(
        text: "Notification Page",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Image.asset(
          "assets/images/bg_pink.jpg",
          fit: BoxFit.fill,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        ),
      ]),
    );
  }

}
