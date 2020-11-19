import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsApp/helper/assetToFile.dart';
import 'package:whatsApp/helper/constraints.dart';
import 'package:whatsApp/helper/helper_functions.dart';
import 'package:whatsApp/screens/chats_screen.dart';
import 'package:whatsApp/screens/loading_screen.dart';
import 'package:whatsApp/widgets/pickers/user_image_picker.dart';

class UserDetails extends StatefulWidget {
  static const String routeName = '/user-details';
  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserDetails> {
  void initState() {
    super.initState();

    getUserInfo();
  }

  var userData;
  bool isLoading = true;
  Future<void> getUserInfo() async {
    final res = FirebaseAuth.instance.currentUser;
    var data =
        await FirebaseFirestore.instance.collection('users').doc(res.uid).get();

    setState(() {
      userData = data.data();
      isLoading = false;
    });
    // print(data['name']);

    // print(userData + 'loda')
  }

  String _userName = '';
  String name = '';
  File _userImageFile;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _name = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Future<void> _pickedImage(File image) async {
    _userImageFile = image;
    if (image == null)
      _userImageFile = await getImageFileFromAssets('images/default-image.jpg');
  }

  Future<void> onSubmit(BuildContext context) async {
    // final isValid1 = _formKey1.currentState.validate();
    // final isValid2 = _formKey2.currentState.validate();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    // if (!isValid1 || !isValid2) return;

    if (_username != null) {
      setState(() {
        _userName = _username.text;
      });
    } else {
      setState(() {
        _userName = 'Ananemous';
      });
    }
    if (_name != null) {
      setState(() {
        name = _name.text;
      });
    } else {
      setState(() {
        name = 'Ananemous';
      });
    }

    try {
      final res = FirebaseAuth.instance.currentUser;
      print(Constraints.userId);
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(res.uid + '.jpg');

      await ref.putFile(_userImageFile).onComplete;

      final url = await ref.getDownloadURL();
      Constraints.image = _userImageFile;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Constraints.userId)
          .set({
        'username': _userName,
        'email': Constraints.myEmail,
        'name': name,
        'userId': Constraints.userId,
        'imageUrl': url,
      });
    } catch (e) {
      print(e);
    }
    HelperFunctions.saveUserNameSharedPreference(_userName);
    HelperFunctions.saveNameSharedPreference(name);
    HelperFunctions.saveUserLoggedInSharedPreference(true);
    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
    Navigator.of(context).pushNamedAndRemoveUntil(
        ChatsScreen.routeName, (Route<dynamic> route) => true);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            body: userData != null
                ? SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.only(bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color(0xff171719),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: Text(
                                    'Welcome Back ',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                ),
                                CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.25,
                                  backgroundImage:
                                      NetworkImage(userData['imageUrl']),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Text(
                                    userData['name'],
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 50),
                            child: Text(
                              'Its great to have you back with us lets connect',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.only(bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color(0xff171719),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Container(
                                    child: Text(
                                      'Profile',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  UserImagePicker(_pickedImage),
                                  SizedBox(height: 40),
                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    // margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'It Cant be emoty';
                                        return null;
                                      },
                                      key: _formKey1,
                                      cursorColor: Colors.amber[800],
                                      controller: _name,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'Name',
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),

                                    // margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'It Cant be emoty';
                                        return null;
                                      },
                                      key: _formKey2,
                                      controller: _username,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'Username',
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 50),
                              child: Text(
                                'This is your username .This name will be visible to your friends',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (userData == null) {
                  setState(() {
                    isLoading = true;
                  });
                  setState(() {
                    isLoading = false;
                  });
                  onSubmit(context);
                } else {
                  HelperFunctions.saveUserNameSharedPreference(
                      userData['username']);
                  HelperFunctions.saveNameSharedPreference(userData['name']);
                  HelperFunctions.saveUserLoggedInSharedPreference(true);
                  HelperFunctions.saveImageUrlSharedPreference(
                      userData['imageUrl']);
                  Navigator.of(context)
                      .popUntil((Route<dynamic> route) => route.isFirst);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      ChatsScreen.routeName, (Route<dynamic> route) => true);
                }
              },
              child: Icon(Icons.check),
            ),
          );
  }
}
