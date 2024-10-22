import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/PackagesModel.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageScreen extends StatefulWidget {
  PackageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PackageScreen> createState() => _MyMatchListPageState();
}

class _MyMatchListPageState extends State<PackageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<MainData> alGetMatchList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      packageListApi();
    });
  }

  Future<void> packageListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN)?? "null";
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse( '${Webservices.baseUrl+Webservices.planView}');
    print("url~~${url}");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = PackagesModel.fromJson(jsonList);
      for (var prod in localPickData.plans! ?? []) {
        print("prod${prod}");
        alGetMatchList.add(prod);
        _isLoading = false;
      }
      // alGetMatchList = localPickData.data ?? [];
      print("DATA!!!${alGetMatchList}");
      setState(() {
        _isLoading = false;
      });
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Token is Expire!! Please Login Again"),
        backgroundColor: AppColor.red,
      ));
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ));
    } else {
      setState(() {
        _isLoading = false;
      });
      print("alGetFavoriteList~~~${alGetMatchList.length}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Nothing"),
        backgroundColor: AppColor.red,
      ));
      print("Nothing Data");
      throw Exception('Failed to load education_list');
    }
  }

  Future<void> _launchUrl() async {
    var _url = Uri.parse("http://rishtaforyou.com/packages");

    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final screenSize=MediaQuery.of(context).size;
    bool isPortrait = screenHeight > screenWidth;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 255, 241, 241),
      // backgroundColor: Color.fromARGB(255, 255, 241, 241),
      appBar: CommonAppBar(
        text: "Membership",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Container(color: AppColor.mainAppColor,),
      /*  Image.asset(
          "assets/images/bg_white.jpg",
          fit: BoxFit.fill,
        ),*/
        SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.mainText,
                ),
              )
                  : alGetMatchList.isNotEmpty
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                  itemCount: alGetMatchList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: screenSize.height*0.03,),
                        Container(
                          padding: EdgeInsets.all(3),
                          margin: EdgeInsets.all(3),
                          // height: MediaQuery.of(context).size.height * 0.4,
                          child: Card(
                            color: Color.fromARGB(255, 245, 245, 245),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                  width: 3, color: Colors.transparent),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment:  CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: screenSize.height*0.02,),
                                  AutoSizeText(
                                    "${alGetMatchList[index].plansName}",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height*0.02,),
                                  AutoSizeText(
                                    "₹ ${alGetMatchList[index].plansPrice}",style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(height: screenSize.height*0.02,),
                                  Divider(height: 2,color: Colors.grey,),
                                  SizedBox(height: screenSize.height*0.01,),
                                  AutoSizeText("No of Contacts",style: TextStyle(fontSize: 17),),
                                  SizedBox(height: screenSize.height*0.01,),
                                  AutoSizeText("${alGetMatchList[index].contactView!}",style: TextStyle(fontSize: 28,color: Colors.grey,fontWeight: FontWeight.w600),),
                                  // SizedBox(height: screenSize.height*0.01,),
                                  // AutoSizeText("Package Validity",style: TextStyle(fontSize: 17),),
                                  // SizedBox(height: screenSize.height*0.01,),
                                  // AutoSizeText("${alGetMatchList[index].duration} Months",style: TextStyle(fontSize: 20,color: Colors.grey),),
                                  // SizedBox(height: screenSize.height*0.02,),
                                  AutoSizeText("No of Connection Requests: ",style: TextStyle(fontSize: 17),),
                                  SizedBox(height: screenSize.height*0.01,),
                                  AutoSizeText("${alGetMatchList[index].connectionRequest!}",style: TextStyle(fontSize: 28,color: Colors.grey,fontWeight: FontWeight.w600),),

                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0,right: 20),
                                      child: Text("${alGetMatchList[index].plansDescription}",style: TextStyle(fontSize: 19),maxLines: 3),
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height*0.04,),
                                  ElevatedButton(onPressed: () {
                                    setState(() {
                                      _launchUrl();
                                    });
                                  }, child: AutoSizeText("Buy Now",style: TextStyle(fontSize: 19),),style: ButtonStyle(backgroundColor:
                                  MaterialStatePropertyAll(AppColor.mainText),padding:
                                  MaterialStatePropertyAll(EdgeInsets.only(left:screenSize.height*0.06,top:screenSize.height*0.01,bottom:screenSize.height*0.01,right: screenSize.height*0.06))),),
                                  SizedBox(height: screenSize.height*0.01,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
                  : Container(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    "EMPTY",
                    style: AppTheme.nameText(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
