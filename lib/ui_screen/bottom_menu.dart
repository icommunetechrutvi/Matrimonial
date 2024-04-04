import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/extra_page.dart';
import 'package:matrimony/home_screen/home_screen.dart';
import 'package:matrimony/search_screen/search_screen.dart';

class BottomMenuScreen extends StatefulWidget {
  const BottomMenuScreen({Key? key}) : super(key: key);

  @override
  State<BottomMenuScreen> createState() => _MyBottomMenuPageState();
}

class _MyBottomMenuPageState extends State<BottomMenuScreen> {
  final _pageController = PageController(initialPage: 1);

  // final _controller = NotchBottomBarController(index: 0);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    HomeScreen(),
    SearchScreen(),
    HomeScreen(),
    MyExtraPage(),
  ];

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
              color: Color.fromARGB(255, 248, 205, 206),
              showLabel: false,
              notchColor: Color.fromARGB(255, 248, 205, 206),

              // removeMargins: false,
              // bottomBarWidth: 500,
              // durationInMilliSeconds: 300,

              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.pink,
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
                    color: Colors.pink,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.chat,
                    color: Colors.black,
                  ),
                  activeItem: Icon(
                    Icons.chat,
                    color: Colors.pink,
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
                    color: Colors.pink,
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
