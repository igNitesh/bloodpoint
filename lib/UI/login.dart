import 'package:bloodpoint/UI/Widget/customtextfield.dart';
import 'package:bloodpoint/UI/basescreen.dart';
import 'package:bloodpoint/UI/home.dart';
import 'package:bloodpoint/UI/signup.dart';
import 'package:bloodpoint/resources/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String loginText = "LOGIN";
  String signupText = "/SignUp";
  bool isLoading = false;
  bool hiddenText = true;
  // var email = "", password = "";

  var _email = TextEditingController();
  var _pass = TextEditingController();

  var _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return buildLoginForm();
  }

  // void _login() async {
  //   print("email : "+_email.text);
  //   print("password  : "+_pass.text);
  //   if (_formkey.currentState!.validate()) {
  //     _formkey.currentState!.save();
  //     try {
  //       setState(() {
  //         isLoading = true;
  //       });

  //       await FirebaseAuthProvider().login(_email.text, _pass.text);
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => Home()));
  //     } catch (err) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       showSnackbar(err.toString());
  //     }
  //   }
  // }

  showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.purple,
      content: Text(message ?? "Something went wrong, try again later."),
    ));
  }

  buildLoginForm() {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage('assets/login.png'), fit: BoxFit.fill),
      // ),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4,
                    right: 35,
                    left: 35),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                                
                      ),
                      
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _pass,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()));
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                showForgorPassword();
                              },
                              child: Text(
                                'Forget Password',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 54, 60, 244),
                                ),
                              )),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () async {
                                // _login();
                                    try {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            await FirebaseAuthProvider().login(_email.text, _pass.text);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context) => Home()));
                                          } catch (err) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            showSnackbar(err.toString());
                                          }
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    // return Form(
    //   key: _formkey,
    //   child: Column(
    //     children: <Widget>[
    //       CustomTextField(
    //         onSaved: (value) {
    //           print(value);
    //           email = value;
    //         },
    //         inputType: TextInputType.emailAddress,
    //         label: 'Email',
    //         hint: 'Email',
    //         onValidate: (value) {
    //           if (value.isEmpty) return 'This field can\'t be empty';
    //         }, suffixIcon: Container(),
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       CustomTextField(
    //         onSaved: (value) {
    //           password = value;
    //         },
    //         label: 'Passsword',
    //         hint: 'Passsword',
    //         onValidate: (value) {
    //           if (value.isEmpty) return 'This field can\'t be empty';
    //         },
    //         obscure: hiddenText,
    //         suffixIcon: IconButton(
    //           icon: Icon(
    //             hiddenText ? MdiIcons.eye : MdiIcons.eyeOff,
    //             color: Colors.grey,
    //           ),
    //           onPressed: () {
    //             setState(() {
    //               hiddenText = !hiddenText;
    //             });
    //           },
    //         ),
    //       ),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: <Widget>[
    //           GestureDetector(
    //             child: Text(
    //               'Forgot Password ?',
    //               style: TextStyle(color: Colors.red),
    //             ),
    //             onTap: showForgorPassword,
    //           )
    //         ],
    //       ),
    //       SizedBox(
    //         height: 40,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: <Widget>[
    //           SizedBox(
    //             height: 90,
    //             child: ClipPolygon(
    //               sides: 6,
    //               rotate: 120,
    //               borderRadius: 9.0,
    //               child: Container(
    //                 color: Colors.red,
    //                 child: isLoading
    //                     ? Center(
    //                         child: CircularProgressIndicator(
    //                         valueColor:
    //                             AlwaysStoppedAnimation<Color>(Colors.yellow),
    //                       ))
    //                     : IconButton(
    //                         icon: Icon(
    //                           Icons.arrow_forward,
    //                           color: Colors.white,
    //                         ),
    //                         onPressed: _login,
    //                       ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  showForgorPassword() {
    showDialog(
        context: context,
        builder: (context) {
          var email1 = "";
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Forgot password ?",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    email1 = value;
                  },
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Your email address"),
                ),
                SizedBox(height: 15),
                ButtonTheme(
                  child: TextButton(
                    // color: Colors.deepOrange,
                    onPressed: () async {
                      if (email1.isEmpty) {
                        showSnackbar('Email is empty');
                      } else {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseAuthProvider().resetPassword(_email.text);
                          setState(() {
                            isLoading = false;
                          });
                          showSnackbar('Reset Email has been sent ');
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          // message word replaced buy toString()
                          showSnackbar(e.toString());
                        }
                      }

                      Navigator.pop(context);
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.yellow)))
                        : Text("Reset Password"),
                  ),
                )
              ],
            ),
          );
        });
  }
}
