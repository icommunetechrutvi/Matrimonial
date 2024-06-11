import 'package:flutter/material.dart';
import 'package:matrimony/notificationservice/notification_list.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  var text;

   CommonAppBar({
    required Key key,
    required this.scaffoldKey,
    required this.text,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height / 8,
      backgroundColor: AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      elevation: 5,
      leading: IconButton(
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
        icon: const Icon(Icons.menu, color: Colors.black),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return NotificationScreen();
              },
            ));
          },
              icon: Icon(Icons.notifications,color: Colors.black,))
        ),
      ],
      title:  Center(
        child: Text(
         "${text}",
            style: TextStyle(
              fontSize: 16,
              color: AppColor.black,
              fontWeight: FontWeight.bold,
              fontFamily:
              FontName.poppinsRegular,)
        ),
      ),
    );
  }
}
