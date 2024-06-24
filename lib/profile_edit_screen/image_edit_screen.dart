import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/view_model/ImageEditModel.dart';
import 'package:matrimony/profile_edit_screen/view_model/profile_detail_model.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/ProgressHUD.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({Key? key}) : super(key: key);

  @override
  State<ImageEditScreen> createState() => _MyImageEditPageState();
}

class _MyImageEditPageState extends State<ImageEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  List<ProfileDetailModel> alGetProfileDetail = [];
  List<ProfileImages> profileImages = [];
  List<File?> images = List.filled(4, null);
  var loginId;
  int? selectedRadioValue;


  @override
  void initState() {
    super.initState();
    setState(() {
      getProfileDetailApi();
    });
  }

  Future<void> pickImage(int index, int imageId, ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          images[index] = File(pickedImage.path);
          print("images~~${images}");
        });
        await postProfileImageEdit(images[index]!, imageId);
      } else {
        print('User didn\'t pick any image.');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> getProfileDetailApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginId = prefs.getString(PrefKeys.KEYPROFILEID)!;

    print("userId~~~**${loginId}");
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        '${Webservices.baseUrl + Webservices.profileDetail + loginId.toString()}');
    print("url!!!${url}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        var jsonList = jsonDecode(response.body) as Map<String, dynamic>;
        print("jsonList$jsonList");
        final localPickData = ProfileDetailModel.fromJson(jsonList);
        print("localPickData${localPickData}");

        alGetProfileDetail.add(localPickData);

        _isLoading = false;
        for (var pro in alGetProfileDetail[0].data?.profileImages ?? []) {
          profileImages.add(pro);
        }
        // isDefault=profileImages[0].isDefault;

        for (var i = 0; i < profileImages.length; i++) {
          if(profileImages[i].isDefault==1){
            selectedRadioValue=profileImages[i].id;
            print("selectedRadioValue${selectedRadioValue}");
            prefs.setString(PrefKeys.KEYAVTAR, profileImages[i].imageName.toString());
          }
          else{
          }
          // selectedRadioValues[i] = profileImages[i].isDefault == "0" ? i.toString() : "yes";
        }

      });
    } else {
      throw Exception('Failed to load education_list');
    }
  }

  Future<dynamic> postProfileImageEdit(File image, int imageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('${Webservices.baseUrl + Webservices.updateProfileImg}');
    print("url~~$url");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $userToken';

    print("formData!!!${request}");

    // Add the image file to the request
    String imageName = 'imageId$imageId';
    request.files.add(
      await http.MultipartFile.fromPath(imageName, image.path),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("streamedResponse~~${streamedResponse.statusCode}");
      print("response~~$response");

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response DATA#######: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Profile Images Successfully Updated"),
          backgroundColor: AppColor.lightGreen,
        ));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return ImageEditScreen();
          },
        ));
        _isLoading = false;
        return json.decode(response.body);
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
      } else if (response.statusCode == 422) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Only image files (jpeg, png, jpg) are allowed."),
          backgroundColor: AppColor.red,
        ));
        _isLoading = false;
      }
    } catch (e) {
      _isLoading = false;
      print('Exception: $e');
    }
  }

  Future<dynamic> postIsDefaultEdits(String selectedRadioValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('${Webservices.baseUrl + Webservices.updateProfileImg}');
    print("url~~$url");

    // var request = http.MultipartRequest('POST', url);
    // request.headers['Authorization'] = 'Bearer $userToken';
    //
    // print("formData!!!${request}");

    // String isDefault = selectedRadioValues[imageId] == imageId.toString() ? '1' : '0';
    var jsonData = json.encode({
      'is_default': '$selectedRadioValue',
    });
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: (jsonData),
      );

      print("streamedResponse~~${response.statusCode}");
      print("response~~$response");

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final userMap = json.decode(response.body);
        final allData= ImageEditModel.fromJson(userMap);
        print('Response DATA#######: ${response.body}');

        // List<ProfileImages> profileImages = [];
        //
        // for( int i=0; i< allData.allImages!.length; i++){
        //   if(profileImages[i].isDefault==1){
        //    prefs.setString(PrefKeys.KEYAVTAR,allData.allImages![0].imageName.toString());
        //   }
        // }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Profile Images Successfully Updated"),
          backgroundColor: AppColor.lightGreen,
        ));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return ImageEditScreen();
          },
        ));
        _isLoading = false;
        return json.decode(response.body);
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
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("The confirm password and new password must match."),
          backgroundColor: AppColor.red,
        ));
        _isLoading = false;
      }
    } catch (e) {
      _isLoading = false;
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: _isLoading,
      opacity: 0.3,
      key: Key("new"),
      valueColor: AlwaysStoppedAnimation(AppColor.mainAppColor),
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar:AppBar(
        backgroundColor: AppColor.white,
        title: Text(
          "Edit Photo",
          style: TextStyle(
            fontSize: 16,
            color: AppColor.black,
            fontWeight: FontWeight.bold,
            fontFamily: FontName.poppinsRegular,
          ),
        ),
        leading:IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
              image: AssetImage("assets/icon/back_app_bar.png"),
              height: screenHeight * 0.02),
        ),
      ),
      drawer: SideDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColor.mainAppColor,),
          // Image.asset("assets/images/bg_pink.jpg", fit: BoxFit.fill),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < profileImages.length; i++)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Card(
                        margin: EdgeInsets.all(18),
                        // color: Colors.white,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        child: Container(
                          color: AppColor.white,
                          padding: EdgeInsets.only(
                              top: 35, left: 12, right: 12, bottom: 12),
                          child:images[i] != null
                              ? Image.file(images[i]!, fit: BoxFit.contain)
                              : profileImages[i].imageName!.isEmpty
                                  ? Container(
                                      padding: EdgeInsets.all(23),
                                      child: Text("Add Image",
                                          style: AppTheme.nameText()),
                                    )
                                  : InstaImageViewer(
                                      child: profileImages[i].imageName!.isNull
                                          ? Image.asset(
                                              "assets/profile_image/girl.png")
                                          : Image.network(
                                        width: screenWidth*1,
                                              "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/${profileImages[i].imageName}",
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 0,
                          right: 8.0,
                        ),
                        child: RadioListTile(
                          activeColor: AppColor.radioButton,
                          title:  Text("Profile Photo", style: TextStyle(fontSize: 22)),
                          value: profileImages[i].id,
                          // value:selectedRadioValue,
                          // value: (i+1).toString(),
                          // groupValue: selectedRadioValues[i],
                          // groupValue: i,
                          groupValue: selectedRadioValue,
                          onChanged: (value) {
                            setState(() { selectedRadioValue = value;
                            });
                            postIsDefaultEdits(value.toString());
                            print( "selectedRadioValues~~${selectedRadioValue}");

                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showPicker(context, profileImages[i].id!.toInt(), i);
                        },
                        child: Container(
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: AppColor.white),
                          child: Icon(
                            Icons.edit_outlined,
                            color: AppColor.mainText,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context, int imageId, int index) {
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
                  pickImage(index, imageId, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  pickImage(index, imageId, ImageSource.camera);
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
