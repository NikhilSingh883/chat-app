import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whatsApp/helper/helper_functions.dart';
import 'package:whatsApp/models/error_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:whatsApp/screens/sign_in_screen.dart';
import 'package:whatsApp/screens/sign_up_screen.dart';
import 'package:whatsApp/screens/user_detail.dart';
import 'package:http/http.dart' as http;

class AuthForm extends StatefulWidget {
  final bool isSignUp;

  AuthForm(this.isSignUp);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';
  var _confirmPassword = '';
  var _userImageFile;

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _email = TextEditingController();

  Future<void> _trySubmit(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (isValid)
      _formKey.currentState.save();
    else
      return;

    _userEmail = _userEmail.trim();
    _userPassword = _userPassword.trim();

    if (widget.isSignUp) {
      var value = new ErrorMsg('');
      await signIn(_userEmail, _userPassword, value);
    } else {
      var value = new ErrorMsg('');
      await signUp(_userEmail, _userPassword, value);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      if (user != null) {
        Navigator.of(context).pushReplacementNamed(UserDetails.routeName);
        HelperFunctions.saveUserEmailSharedPreference(user.email);
        HelperFunctions.saveUserIdSharedPreference(user.uid);
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> facebookSignIn() async {
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.credential(token);
      _auth.signInWithCredential(credential);
      final profile = jsonDecode(graphResponse.body);
      print(graphResponse.body);
      HelperFunctions.saveUserEmailSharedPreference(profile['email']);
      HelperFunctions.saveUserIdSharedPreference(result.accessToken.userId);
      Navigator.of(context).pushReplacementNamed(UserDetails.routeName);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signIn(String email, String password, ErrorMsg msg) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (!user.emailVerified) {
        signOut();
        msg.error =
            'Please verify your email address by clicking on the link sent on your registered email id.😅';
      } else {
        Navigator.of(context).pushReplacementNamed(UserDetails.routeName);
        HelperFunctions.saveUserEmailSharedPreference(user.email);
        HelperFunctions.saveUserIdSharedPreference(user.uid);
      }
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      if (msg != null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg.error)));
      }
    }
  }

  Future<void> resetPassword(String email, ErrorMsg msg) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      msg.error = 'Check your email for resetting your password';
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      if (msg != null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg.error)));
      }
    }
  }

  Future<void> signUp(String email, String password, ErrorMsg msg) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      user.sendEmailVerification();
      msg.error =
          'Please verify your email address by clicking on the link sent on your registered email id and then try to sign in. 😅';
      signOut();
      Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
      // user.displayName = name;
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      if (msg != null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg.error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: BoxDecoration(
          color: Color(0xff171719),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        margin: const EdgeInsets.only(top: 20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Your Email Address',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ),
                TextFormField(
                  controller: _email,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  key: ValueKey('email'),
                  style: TextStyle(color: Colors.white70),
                  validator: (value) {
                    if (value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.com')) return 'Enter a Valid Email!';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'email@domain.com',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.redAccent[400],
                    ),
                  ),
                  onSaved: (newValue) {
                    _userEmail = newValue;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  key: ValueKey('password'),
                  controller: _pass,
                  style: TextStyle(color: Colors.white54),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7)
                      return 'Password should be atleast 7';
                    if (!value.contains('@') &&
                        !value.contains('.') &&
                        !value.contains('-'))
                      return 'Add some special character';
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'JognWick.dog',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.redAccent[400],
                    ),
                  ),
                  onSaved: (newValue) {
                    _userPassword = newValue;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (!widget.isSignUp)
                  TextFormField(
                    controller: _confirmPass,
                    autocorrect: false,
                    key: ValueKey('confirmPassword'),
                    validator: (value) {
                      if (value != _pass.text) return 'Password doesnt match';
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.redAccent[400],
                      ),
                    ),
                    onSaved: (newValue) {
                      _confirmPassword = newValue;
                    },
                  ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () => _trySubmit(context),
                  child: Material(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    elevation: 3,
                    child: Container(
                      width: 400,
                      height: 65,
                      alignment: Alignment.center,
                      child: Text(
                        widget.isSignUp ? 'Sign In' : 'Sign Up',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent[400],
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.isSignUp)
                  InkWell(
                    onTap: () {
                      resetPassword(_email.text, new ErrorMsg(''));
                      print('loda');
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                if (widget.isSignUp)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.white54),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpScreen.routeName);
                        },
                        child: Container(
                          child: Text(
                            'Create one',
                            style: TextStyle(color: Colors.redAccent[400]),
                          ),
                        ),
                      )
                    ],
                  ),
                if (widget.isSignUp)
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    GestureDetector(
                      onTap: () async {
                        await facebookSignIn();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('assets/images/facebook-logo.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await signInWithGoogle();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('assets/images/google-logo.png'),
                        ),
                      ),
                    ),
                  ]),
                if (widget.isSignUp)
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Other options to sign in',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
