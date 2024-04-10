import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/blocked_profile/viewed_contact_screen.dart';
import 'package:matrimony/blocked_profile/viewed_profile_screen.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/blocklist_screen.dart';
import 'package:matrimony/profile_edit_screen/image_edit_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_edit_screen.dart';
import 'package:matrimony/wishList_screen/wishlist_screen.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<SideDrawer> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SideDrawer> {
  var userName = '';
  var emailId = '';
  var imageName = '';
  var userGender = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      getValue();
    });
  }

  Future<void> getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailId = prefs.getString(PrefKeys.KEYEMAIL)!;
    userName = prefs.getString(PrefKeys.KEYNAME) ?? "kmkjlmnkjn";
    imageName = prefs.getString(PrefKeys.KEYAVTAR)!;
    userGender = prefs.getString(PrefKeys.KEYGENDER)!;
  }

  @override
  Widget build(BuildContext context) {
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
      width: 250,
      child: FutureBuilder(
          future: getValue(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: <Widget>[
                  Container(
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 248, 205, 206),
                      ),
                      accountEmail: emailId?.isNotEmpty ?? false
                          ? Text(
                              emailId ?? "jghjknn",
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            )
                          : const Text(
                              'N/A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      accountName: userName?.isNotEmpty ?? false
                          ? Text(
                              userName ?? "nckjndjk",
                              style: const TextStyle(
                                color: Colors.pink,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : const Text(
                              'N/A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      currentAccountPicture: CachedNetworkImage(
                        imageUrl:
                            "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/${imageName.toString()}" ??
                                "",
                        imageBuilder: (context, imageProvider) => Container(
                          padding: EdgeInsets.all(10),
                          // height: 0.5,
                          // width: 0.5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                100,
                              ),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.colorBurn,
                              ),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => userGender == "2"
                            ? Image.asset("assets/profile_image/girl.png")
                            : Image.asset("assets/profile_image/boy.png"),
                      ),
                    ),
                  ),
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
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageEditScreen()),
                          (route) => false);
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
                    title: const Text('Shortlisted Profile',
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
                      Icons.co_present,
                      color: Color.fromARGB(255, 126, 143, 130),
                    ),
                    title: const Text('Viewed Profile',
                        style: TextStyle(
                          color: Color.fromARGB(255, 126, 143, 130),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return ViewedProfileScreen();
                        },
                      ), (route) => false);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.co_present,
                      color: Color.fromARGB(255, 126, 143, 130),
                    ),
                    title: const Text('Viewed Contact',
                        style: TextStyle(
                          color: Color.fromARGB(255, 126, 143, 130),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return ViewedContactScreen();
                        },
                      ), (route) => false);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.block_outlined,
                      color: Color.fromARGB(255, 126, 143, 130),
                    ),
                    title: const Text('Blocked Profile',
                        style: TextStyle(
                          color: Color.fromARGB(255, 126, 143, 130),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return BlockListScreen();
                        },
                      ), (route) => false);
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
              );
            }
          }),
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
