import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:matrimony/profile_screen/view_model/profile_detail_model.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({Key? key}) : super(key: key);

  @override
  State<ImageEditScreen> createState() => _MyImageEditPageState();
}

class _MyImageEditPageState extends State<ImageEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<bool> isImageSelected = List.filled(4, false);
  bool _isLoading = false;
  List<ProfileDetailModel> alGetProfileDetail = [];
  List<ProfileImages> profileImages = [];
  List<File?> images = List.filled(4, null);

  @override
  void initState() {
    super.initState();
    setState(() {
      getProfileDetailApi();
    });
  }

  Future<void> pickImage(int index, ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          images[index] = File(pickedImage.path);
          isImageSelected[index] = true;
        });
      } else {
        print('User didn\'t pick any image.');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> getProfileDetailApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final stringValue = prefs.getString('userId')!;
    print("userId~~~**${stringValue}");
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/profile_detail/${stringValue}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        var jsonList = jsonDecode(response.body) as Map<String, dynamic>;
        print("jsonList$jsonList");
        final localPickData = ProfileDetailModel.fromJson(jsonList);
        print("localPickData${localPickData}");

        alGetProfileDetail.add(localPickData);

        _isLoading = false;
        profileImages.addAll(localPickData.data?.profileImages ?? []);

        String? defaultImageName;

        for (var image in profileImages) {
          if (image.isDefault == 1) {
            defaultImageName = image.imageName;
            break;
          }
        }

        prefs.setString('imageName', defaultImageName!);




        // for (var pro in alGetProfileDetail[0].data?.profileImages ?? []) {
        //   profileImages.add(pro);
        //   print("img####${profileImages[0].imageName}");
        // }
      });
    } else {
      throw Exception('Failed to load education_list');
    }
  }

  // Future<dynamic> postProfileImageEdit() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final stringValue = prefs.getString('userId')!;
  //   // showDialog(
  //   //     context: context,
  //   //     builder: (context) {
  //   //       return Center(
  //   //         child: CircularProgressIndicator(
  //   //           color: AppColor.mainAppColor,
  //   //         ),
  //   //       );
  //   //     });
  //   var url = Uri.parse(
  //       'https://matrimonial.icommunetech.com/public/api/edit_profile_img/${stringValue}');
  //
  //   var jsonData = json.encode({
  //     'imageId0': '',
  //     'imageId1': '',
  //     'imageId2': '',
  //     'imageId3': '',
  //   });
  //   print("formData!!!${jsonData}");
  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: (jsonData),
  //     );
  //     print('Response status: ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       print('Response DATA#######: ${response.body}');
  //
  //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       //   content: Text("${alGetProfileDetail[0].message}"),
  //       //   backgroundColor: AppColor.lightGreen,
  //       // ));
  //       Navigator.pushReplacement(context, MaterialPageRoute(
  //         builder: (context) {
  //           return SearchScreen();
  //         },
  //       ));
  //       return json.decode(response.body);
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     print('Exception: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = screenHeight > screenWidth;
    double width = MediaQuery.of(context).size.width - 16.0;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CommonAppBar(
        text: "Edit Photos",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/bg_pink.jpg", fit: BoxFit.fill),
          SingleChildScrollView(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor.buttonColor,
                    ),
                    widthFactor: 60,
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < profileImages.length; i++)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Card(
                                margin: EdgeInsets.all(20),
                                // color: Colors.white,
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: isImageSelected[i]
                                      ? Image.file(images[i]!,
                                          fit: BoxFit.contain)
                                      : profileImages[i].imageName! .endsWith('.mp4') ||
                                              profileImages[i] .imageName!  .isNull ||   profileImages[i]
                                                  .imageName!    .endsWith('.txt')
                                          ? Container(
                                              padding: EdgeInsets.all(23),
                                              child: Text("Add Image",
                                                  style: AppTheme.nameText()),
                                            )
                                          : Image.network(
                                              "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/${profileImages[i].imageName}",
                                              fit: BoxFit.fill,
                                            ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _showPicker(context, i);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(12),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: AppColor.buttonColor),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  pickImage(index, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  pickImage(index, ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
