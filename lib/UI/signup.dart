import 'package:bloodpoint/UI/Widget/customtextfield.dart';
import 'package:bloodpoint/UI/basescreen.dart';
import 'package:bloodpoint/UI/login.dart';
import 'package:bloodpoint/resources/firebase_auth_provider.dart';
import 'package:bloodpoint/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:bloodpoint/UI/map.dart';
import 'package:bloodpoint/model/user_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _email = TextEditingController();
  var _user = TextEditingController();
  var _pass = TextEditingController();
  var _cpass = TextEditingController();
  late String selectedValue = '';
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  String signupText = "SignUp";
  String locationName = 'Location';
  bool index = true;
  bool isLoading = false;
  bool hiddenText = true;
  UserModel user = UserModel(
      id: "",
      name: "",
      blood: "",
      contact: "",
      longitude: 0,
      latitude: 0,
      email: "");
  final List<String> BloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-'];
  // static const blood = <String>['A+', 'A-', 'B+', 'B-', 'O+', 'O-'];

  // final List<DropdownMenuItem<String>> _bloodgroups = blood
  //     .map(
  //       (String value) => DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value,
  //             style: TextStyle(
  //               color: Colors.red,
  //             )),
  //       ),
  //     )
  //     .toList();
  void _check() {
    print("hello world");
  }

  void _signup() async {
    print("clicked");
    // if (_formkey.currentState!.validate()) {
    //   _formkey.currentState!.save();
    // } else
    //   return;
    if (_pass.text != _cpass.text) {
      showSnackbar('Password do not match');
    } else {
      try {
        setState(() {
          isLoading = true;
        });

        var fUser = await FirebaseAuthProvider()
            .signup(_email.text, _pass.text, _user.text);
        // FirestoreProvider().addUser(user..id = fUser.uid);

        setState(() {
          _email.text = "";
          _pass.text = "";

          index = true;
          isLoading = false;
        });
        showSnackbar('Sucessfully signed up login now');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackbar(err.toString());
      }
    }
  }

  showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.purple,
      content: Text(message ?? "Something went wrong, try again later."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 35,
                left: 35),
            child: Column(
              children: [
                TextField(
                  controller: _user,
                  decoration: InputDecoration(
                      hintText: 'Full Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _pass,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _cpass,
                  decoration: InputDecoration(
                      hintText: 'Re - Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 30,
                ),
                //..................Dropdown
                Column(
                  children: [
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                        //Add isDense true and zero Padding.
                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //Add more decoration as you want here
                        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Your Blood Group',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: BloodGroup.map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select blood group.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                        selectedValue = value.toString();
                        user.blood = selectedValue;
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                        user.blood = selectedValue;
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 60,
                        padding: EdgeInsets.only(left: 20, right: 10),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      // width: 300,
                      height: 55,
                      padding: EdgeInsets.only(left: 20, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          // color: Color.fromARGB(255, 72, 71, 71),
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        child: Text(
                          locationName,
                        ),
                        onPressed: () async {
                          print("location");
                          var loc = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Maps()),
                          );
                          if (loc != null) {
                            setState(() {
                              locationName = "${loc.latitude},${loc.longitude}";
                            });
                            user.latitude = loc.latitude;
                            user.longitude = loc.longitude;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        )),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        color: Colors.black,
                        onPressed: () {
                          _signup();
                        },
                        icon: Icon(Icons.arrow_forward),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  // buildSignupForm() {
  //   final List<String> BloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-'];
  //   return Container(
  //     child: Builder(
  //       builder: (context) {

  //       }
  //     ),
  //   );
  // }

  showErrorDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content:
                  Text('Enter the fields', style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                TextButton(
                  child: Text('ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              title: Text('Error'));
        });
  }
}
