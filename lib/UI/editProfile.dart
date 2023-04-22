import 'package:bloodpoint/UI/Widget/customtextfield.dart';
import 'package:bloodpoint/UI/basescreen.dart';
import 'package:bloodpoint/resources/firebase_auth_provider.dart';
import 'package:bloodpoint/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:bloodpoint/UI/map.dart';
import 'package:bloodpoint/model/user_model.dart';

class EditProfile extends StatefulWidget {
  EditProfile({required this.userModel});
  final UserModel userModel;
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<EditProfile> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _user = TextEditingController();
  var _phone = TextEditingController();
  late String selectedValue;
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  String text = "Edit profile";
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
  static const blood = <String>['A+', 'A-', 'B+', 'B-', 'O+', 'O-'];
  final List<DropdownMenuItem<String>> _bloodgroups = blood
      .map(
        (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: TextStyle(
                    color: Colors.red,
                  )),
            ),
      )
      .toList();
      


  void _update() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
    } else
      return;

    try {
      setState(() {
        isLoading = true;
      });

      await FirestoreProvider().updateUser(user);

      setState(() {
        index = true;
        isLoading = false;
      });
      Navigator.of(context).pop(context);
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      ;
      showSnackbar(err.toString());
    }
  }
showSnackbar(message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.purple,
    content: Text(message ?? "Something went wrong, try again later."),
  ));
}


  @override
  void initState() {
    super.initState();
    if (widget.userModel != null) {
      _user.text = widget.userModel.name;
      _phone.text = widget.userModel.contact;
      selectedValue = widget.userModel.blood;
      locationName =
          "${widget.userModel.latitude},${widget.userModel.longitude}";
      setUser();
      user = widget.userModel;
    }
  }

  setUser() async {
    var userr = await FirebaseAuthProvider().getCurrentUser();
    user.id = userr!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff44130f),
      key: _scaffoldkey,
      body: BaseScreen(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(context),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                buildSignupForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSignupForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            textCapitalization: TextCapitalization.words,
            controller: _user,
            onSaved: (value) {
              user.name = value;
            },
            label: "Fullname",
            hint: "Ex: Nitesh Rauniyar",
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            }, suffixIcon: Container(),
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextField(
            controller: _phone,
            onSaved: (value) {
              user.contact = value;
            },
            onValidate: (value) {
              if (value.length != 10)
                return 'Phone Number must be of 10 digits';
              else if (value.isEmpty) return 'This field can\'t be empty';
            },
            label: 'Contact',
            hint: 'Ex:9999999999',   suffixIcon: Container(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: DropdownButtonFormField(
              value: selectedValue,
              hint: Text(
                'Blood Group',
                style: TextStyle(color: Colors.white),
              ),
              items: _bloodgroups,
              onChanged: ((String? newvalue) {
                setState(() {
                  selectedValue = newvalue!;
                  print(selectedValue);
                  user.blood = selectedValue;
                });
              }),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            height: 55,
            child: TextButton(
              child: Text(locationName,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () async {
                var loc = await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Maps()));
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 90,
                child: ClipPolygon(
                  sides: 6,
                  rotate: 120,
                  borderRadius: 9.0,
                  child: Container(
                    color: Colors.red,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.yellow)))
                        : IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: _update,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
