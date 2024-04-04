import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_screen/image_edit_screen.dart';
import 'package:matrimony/profile_screen/profile_edit_screen.dart';
import 'package:matrimony/profile_screen/wishlist_screen.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget  {
  @override
  State<SideDrawer> createState() => _SecondScreenState();
}
class _SecondScreenState extends State<SideDrawer> {
   var userName="";
   var emailId="";
   var imageName="";

  @override
  void initState() {
    super.initState();
    setState(() {
      getValue();
    });
  }
  Future<void> getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userName = prefs.getString('userName')?? "null";
     emailId = prefs.getString('emailId')?? "null";
     imageName = prefs.getString('imageName')?? "null";
  }


  @override
  Widget build(BuildContext context) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final stringValue = prefs.getString('accessToken')?? "null";
    // print("stringValue~~~${stringValue}");
    return Drawer(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(55),
          // You can adjust the radius as needed
          bottomRight:
              Radius.circular(55), // You can adjust the radius as needed
        ),
      ),
      elevation: 8,
      width: 270,
      child: ListView(
        children: [
          Container(
            height: 200,
            child: DrawerHeader(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 205, 206),
                ),
                accountName: Text(
                  userName.isEmpty?"Test":"${userName}",
                  style: TextStyle(fontSize: 20, color: Colors.pink),
                ),
                accountEmail: Text(
                  emailId.isEmpty?"Test":"${emailId}",
                  style: TextStyle(color: Colors.black),
                ),
                currentAccountPictureSize: Size.square(70),
                currentAccountPicture: Container(
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage("https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/${imageName}"),
                        fit: BoxFit.cover),
                  ),
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ),
          ), //DrawerHeader
          ListTile(
            leading: const Icon(
              Icons.add_photo_alternate,
              color: Color.fromARGB(255, 126, 143, 130),
            ),
            title: const Text(
              'Edit Photos',
              style: TextStyle(
                color: Color.fromARGB(255, 126, 143, 130),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) =>
                   ImageEditScreen()

              ), (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.search,
              color: Color.fromARGB(255, 126, 143, 130),
            ),
            title: const Text('Search ',
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 143, 130),
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomMenuScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 126, 143, 130),
            ),
            title: const Text(' Edit Profile',
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 143, 130),
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return ProfileEditScreen();
                },
              ), (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite_border_outlined,
              color: Color.fromARGB(255, 126, 143, 130),
            ),
            title: const Text('Wishlist',
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 143, 130),
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return WishlistScreen();
                },
              ), (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.workspace_premium,
              color: Color.fromARGB(255, 126, 143, 130),
            ),
            title: const Text('Terms and Condition ',
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 143, 130),
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 126, 143, 130),
            ),
            title: const Text('LogOut',
                style: TextStyle(
                  color: Color.fromARGB(255, 126, 143, 130),
                )),
            onTap: () {
              _logout(context);
            }
            //   Navigator.pop(context);
            //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            //     builder: (context) {
            //       return LoginScreen();
            //     },
            //   ), (route) => false);
            // },
          ),
        ],
      ),
    );
  }
}


void _logout(BuildContext context) async {
  // Remove token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');

  // Navigate back to login screen
  Navigator.pop(context);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    builder: (context) {
      return LoginScreen();
    },
  ), (route) => false);
}