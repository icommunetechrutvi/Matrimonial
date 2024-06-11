import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/blocked_profile/connection_screen.dart';
import 'package:matrimony/blocked_profile/match_list_screen.dart';
import 'package:matrimony/blocked_profile/viewed_contact_screen.dart';
import 'package:matrimony/blocked_profile/viewed_profile_screen.dart';
import 'package:matrimony/login_screen/change_password.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/wishList_screen/blocklist_screen.dart';
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
  var loginId = '';
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
    // prefs.reload();
    emailId = prefs.getString(PrefKeys.KEYEMAIL)!;
    userName = prefs.getString(PrefKeys.KEYNAME) ?? "kmkjlmnkjn";
    imageName = prefs.getString(PrefKeys.KEYAVTAR)!;
    userGender = prefs.getString(PrefKeys.KEYGENDER)!;
    loginId = prefs.getString(PrefKeys.KEYPROFILEID)!;

    print("userName${userName}");
    print("emailId${emailId}");
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
                        color: AppColor.mainAppColor,
                      ),
                      accountEmail: emailId?.isNotEmpty ?? false
                          ? Text(
                              emailId ?? "jghjknn",
                              style: TextStyle(
                                color:AppColor.mainText,
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
                              style: TextStyle(
                                color:AppColor.mainText,
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
                    leading:  Icon(
                      Icons.home,
                      color: AppColor.mainText,
                    ),
                    title:  Text('Home ',
                        style: TextStyle(
                          color: AppColor.mainText,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomMenuScreen(pageId: 0),
                          ));
                    },
                  ),
                  ListTile(
                    leading:  Icon(
                      Icons.person,
                      color: AppColor.mainText,
                    ),
                    title:  Text('My Profile',
                        style: TextStyle(
                          color: AppColor.mainText,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomMenuScreen(pageId: 3),
                          ));
                    },
                  ),
                  ListTile(
                    leading:  Icon(
                      Icons.search,
                      color: AppColor.mainText,
                    ),
                    title:  Text('Search ',
                        style: TextStyle(
                          color: AppColor.mainText,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomMenuScreen(pageId: 1),
                          ));
                    },
                  ),
                /*  ListTile(
                    leading: Icon(
                      Icons.add_photo_alternate,
                      color:AppColor.mainText,
                    ),
                    title: Text(
                      'Edit Photos',
                      style: TextStyle(
                        color:AppColor.mainText,
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
                    leading: Icon(
                      Icons.edit,
                      color:AppColor.mainText,
                    ),
                    title: Text(' Edit Profile',
                        style: TextStyle(
                          color:AppColor.mainText,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return ProfileEditScreen();
                        },
                      ), (route) => false);
                    },
                  ),*/
                  ListTile(
                    leading:  Icon(
                      Icons.connect_without_contact_outlined,
                      color:AppColor.mainText,
                    ),
                    title:  Text('Connection',
                        style: TextStyle(
                          color:AppColor.mainText,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomMenuScreen(pageId: 2),
                          ));
                    },
                  ),
                  ListTile(
                    leading:  Icon(
                      Icons.favorite_border_outlined,
                      color:AppColor.mainText,
                    ),
                    title:  Text('Shortlisted Profile',
                        style: TextStyle(
                          color:AppColor.mainText,
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
                    leading:  Icon(
                      Icons.co_present,
                      color:AppColor.mainText,
                    ),
                    title: Text('Viewed Profile',
                        style: TextStyle(
                          color:AppColor.mainText,
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
                    leading: Icon(
                      Icons.co_present,
                      color:AppColor.mainText,
                    ),
                    title: Text('Viewed Contact',
                        style: TextStyle(
                          color:AppColor.mainText,
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
                    leading: Icon(
                      Icons.recommend_outlined,
                      color:AppColor.mainText,
                    ),
                    title: Text('Recommended Matches',
                        style: TextStyle(
                          color:AppColor.mainText,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return MatchListScreen();
                        },
                      ), (route) => false);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.block_outlined,
                      color:AppColor.mainText,
                    ),
                    title:  Text('Blocked Profile',
                        style: TextStyle(
                          color:AppColor.mainText,
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
                    leading: Icon(
                      Icons.change_circle_outlined,
                      color:AppColor.mainText,
                    ),
                    title: Text('Change Password',
                        style: TextStyle(
                          color:AppColor.mainText,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ChangePasswordScreen();
                      },));
                      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      //   builder: (context) {
                      //     return ChangePasswordScreen();
                      //   },
                      // ), (route) => false);
                    },
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.logout,
                        color:AppColor.mainText,
                      ),
                      title: Text('LogOut',
                          style: TextStyle(
                            color:AppColor.mainText,
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
