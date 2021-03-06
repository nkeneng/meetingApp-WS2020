import 'dart:ui';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:team3/Common/InfoDialog.dart';
import 'package:team3/Common/data.dart';
import 'package:team3/Common/upperTransition.dart';
import 'package:team3/Widgets/BackgroundGradient.dart';
import 'package:team3/Widgets/BackgroundImage.dart';
import 'package:team3/Widgets/Header.dart';
import 'package:team3/main.dart';
import 'package:team3/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // form username field value
  String username = '';

  // form password field value
  String password = '';

  @override

  /// state init
  void initState() {
    password = '';
    username = '';
    super.initState();
  }

  /// method to log the user in
  login() async {
    User formData = new User(userName: username, password: password);
    print(BaseUrl + 'login');
    User user = await formData
        .postData(BaseUrl + 'login', body: formData.toMap())
        .catchError(onError);
    // if the response could be transform in user and contains a real userId
    if (user != null && user.userId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // store the user token in preferences to keep him logged in even if apps closes
      prefs.setString('authToken', user.authToken);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp(
                  user: user,
                )),
      );
    }
  }

  /// method to be trigger on exception by login
  onError(e) {
    (Platform.isIOS)
        ? handleIosError(context: context, message: e.source)
        : handleAndroidError(context: context, message: e.source);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          backgroundImage(image: 'htw-bg1.jpg'),
          SingleChildScrollView(
            child: Container(
              height:
                  (Platform.isIOS) ? MediaQuery.of(context).size.height : null,
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    Center(
                        child: Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 47, right: 50),
                            child: TextFormField(
                              onChanged: (val) {
                                setState(() => username = val);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: 'Username/Email',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19.0,
                                  ),
                                  focusColor: Colors.white),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 47, right: 50),
                            child: TextFormField(
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19.0,
                                  ),
                                  focusColor: Colors.white),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 47, right: 50),
                              child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 55,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      login();
                                    }
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(createRoute('reset'));
                            },
                            child: Container(
                              child: Text(
                                'Forgot password ?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute('register'));
                              },
                              child: Container(
                                child: Text(
                                  'Already have an anccount ? Sign Up',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              decoration: backgroundGradient(),
            ),
          ),
        ],
      ),
    );
  }
}
