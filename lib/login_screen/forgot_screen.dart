import 'package:flutter/material.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _MyForgotScreen();
}

class _MyForgotScreen extends State<ForgotScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
          /*  image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg_pink.jpg",
                ),
                fit: BoxFit.fill),*/
            color: AppColor.mainAppColor,
          ),
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                 /* image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg_white.jpg",
                      ),
                      fit: BoxFit.fill),*/
                  color: AppColor.white,
                ),
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 350),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const FlutterLogo(size: 100),
                      _gap(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Forgot your Password?",
                          style: AppTheme.nameText(),
                          // style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Text(
                          "Enter your Email to continue.",
                          // "Enter your email and password to continue.",
                          // style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                          style: AppTheme.profileTexts(),
                        ),
                      ),
                      _gap(),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email Id',
                          hintText:
                          'Enter Email Id',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                          prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Text(
                      //       textAlign: TextAlign.end, 'Forgot Password'),
                      // ),
                      // _gap(),
                      // CheckboxListTile(
                      //   value: _rememberMe,
                      //   onChanged: (value) {
                      //     if (value == null) return;
                      //     setState(() {
                      //       _rememberMe = value;
                      //     });
                      //   },
                      //   title: const Text('Remember me'),
                      //   controlAffinity: ListTileControlAffinity.leading,
                      //   dense: true,
                      //   contentPadding: const EdgeInsets.all(0),
                      // ),
                      _gap(),
                      _gap(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor:
                              AppColor.mainText),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              // 'Sign in',
                              'Send',
                              style: AppTheme.buttonBold(),
                            ),
                          ),
                          onPressed: () {}
                          /*  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BottomMenuScreen(pageId: 1,)));
                            // if (_formKey.currentState?.validate() ?? false) {
                            //   /// do something
                            // }
                          },*/
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     const Text('Don`t have an account?'),
                      //     TextButton(
                      //       child: const Text(
                      //         'Register Now!',
                      //         style: TextStyle(fontSize: 15),
                      //       ),
                      //       onPressed: () {
                      //         //signup screen
                      //       },
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
