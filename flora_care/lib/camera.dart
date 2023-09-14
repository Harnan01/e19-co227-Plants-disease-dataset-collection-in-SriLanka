import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  String selectedImagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImagePath == ''
                ? Image.asset('assets/image_placeholder.png', height: 200, width: 200, fit: BoxFit.fill,)
                : Image.file(File(selectedImagePath), height: 200, width: 200, fit: BoxFit.fill,),
            Text(
              'Select Image',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row( // Use a Row to place buttons side by side
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white)),
                ),
                onPressed: () async {
                  selectImage();
                  setState(() {});
                },
                child: const Text('Select'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white)),
                ),
                onPressed: () async {
                  // Handle the "Send" button action here
                },
                child: const Text('Send'),
              ),
            ],
          ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

 Future<void> selectImage() async {
  final double dialogHeight = MediaQuery.of(context).size.height * 0.25;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          height: dialogHeight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  'Select Image From !',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        selectedImagePath = await selectImageFromGallery();
                        print('Image_Path:-');
                        print(selectedImagePath);
                        if (selectedImagePath != '') {
                          Navigator.pop(context);
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("No Image Selected !"),
                          ));
                        }
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/gallery.png',
                                height: 60,
                                width: 60,
                              ),
                              Text('Gallery'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        selectedImagePath = await selectImageFromCamera();
                        print('Image_Path:-');
                        print(selectedImagePath);

                        if (selectedImagePath != '') {
                          Navigator.pop(context);
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("No Image Captured !"),
                          ));
                        }
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/camera.png',
                                height: 60,
                                width: 60,
                              ),
                              Text('Camera'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  //
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }
}