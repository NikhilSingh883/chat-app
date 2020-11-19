import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsApp/helper/assetToFile.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickedFn;
  UserImagePicker(this.imagePickedFn);
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  Future<void> _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    // _pickedImage = await getImageFileFromAssets('images/default-image.jpg');

    setState(() {
      _pickedImage = image;
    });

    widget.imagePickedFn(_pickedImage);
  }

  Future<void> _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    // _pickedImage = await getImageFileFromAssets('images/default-image.jpg');

    setState(() {
      _pickedImage = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30),
            height: 150,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                  child: Column(children: [
                    Container(
                      child: new Icon(
                        Icons.photo_camera,
                        size: 30,
                        color: Colors.green[300],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey[900],
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                InkWell(
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                  child: Column(children: [
                    Container(
                      child: new Icon(
                        Icons.photo_library,
                        size: 30,
                        color: Colors.red[500],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey[900],
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: InkWell(
            onTap: () => _showPicker(context),
            child: CircleAvatar(
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage)
                  : AssetImage('assets/images/default-image.jpg'),
              radius: 130,
              backgroundColor: Colors.red[300],
            ),
          ),
        ),
        Positioned(
          top: sizeX * 0.38,
          left: sizeY * 0.28,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              onTap: () => _showPicker(context),
              // borderRadius: BorderRadius.circular(15),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
