import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/blocked_profile/connection_screen.dart';
import 'package:matrimony/blocked_profile/extra.dart';
import 'package:matrimony/chating_screen/chat_page.dart';
import 'package:matrimony/home_screen/home_screen.dart';
import 'package:matrimony/profile_edit_screen/my_profile.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/search_screen/search_screen.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomMenuScreen extends StatefulWidget {
  int pageId ;
  BottomMenuScreen({required this.pageId});
  @override
  State<BottomMenuScreen> createState() => _MyBottomMenuPageState();
}

class _MyBottomMenuPageState extends State<BottomMenuScreen> {
  late PageController _pageController;
  late List<Widget> bottomBarPages;
  var loginId = "";
  var loginFName = "";
  var loginLName = "";
  // final _pageController = PageController(initialPage: 1);

  // final _controller = NotchBottomBarController(index: 0);

  int maxCount = 4;


  @override
  void initState() {
    super.initState();
    setState(() {
      _pageController = PageController(initialPage: widget.pageId);
      getValue();
      bottomBarPages = [
        HomeScreen(),
        SearchScreen(selectedAge: "",selectedAgeS: "",selectedGender: "",selectedMaritalStatus:""),
        ConnectionListScreen(),
        ProfileDetailScreen(profileId: loginId,profileFullName: "${loginFName} ${loginLName}"),
      ];
    });
  }
  Future<void> getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginId = prefs.getString(PrefKeys.KEYPROFILEID) ?? "";
      loginFName = prefs.getString(PrefKeys.KEYNAME) ?? "";
      loginLName = prefs.getString(PrefKeys.KEYLNAME) ?? "";

      bottomBarPages = [
        HomeScreen(),
        SearchScreen(selectedAge: "",selectedAgeS: "",selectedGender: "",selectedMaritalStatus:""),
        ConnectionListScreen(),
        // ProfileDetailScreen(profileId: loginId,profileFullName: "${loginFName} ${loginLName}"),
        MyProfileScreen(profileId: loginId,profileFullName: "${loginFName} ${loginLName}"),
      ];
    });
    // _isLoading = false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  // /// widget list
  // final List<Widget> bottomBarPages = [
  //   HomeScreen(),
  //   SearchScreen(),
  //   HomeScreen(),
  //   PersistentBottomNavPage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              // notchBottomBarController: _controller,
              color: AppColor.white,
              showLabel: false,
              notchColor: AppColor.mainText,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color:AppColor.mainAppColor,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.search,
                    color:AppColor.mainAppColor,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.connect_without_contact_rounded,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.connect_without_contact_rounded,
                    color:AppColor.mainAppColor,
                  ),
                  itemLabel: 'Page 4',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: AppColor.mainAppColor,
                  ),
                  itemLabel: 'Page 5',
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              pageController: _pageController)
          : null,
    );
  }
}
