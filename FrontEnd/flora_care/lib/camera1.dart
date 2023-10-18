import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
//import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:convert';
import 'package:flutter/cupertino.dart';
//import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
//import 'loading.dart';
import 'diseasedetailspage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'HiveBoxes.dart';

class Camera1 extends StatefulWidget {
  final List<CameraDescription> cameras;

  Camera1(this.cameras);

  @override
  Camera1State createState() {
    return new Camera1State();
  }
}

class Camera1State extends State<Camera1> {
  bool isLoading = false;
  late CameraController controller;
  XFile? _capturedImage; // Store the captured image here
  bool isCapturing = false;
  File? capturedImageFile;
  

  String selectedImagePath = '';
  bool isFlashOn = false;

  @override
  void initState() {
  super.initState();
  requestCameraPermissions();
  _initializeCamera();
}

 Future<void> requestCameraPermissions() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }

Future<void> _initializeCamera() async {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Set the flash mode (e.g., FlashMode.auto, FlashMode.always, FlashMode.off)
controller.setFlashMode(FlashMode.off);

    await controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onCapturePressed() async {
    if (!controller.value.isInitialized) {
      return;
    }

    try {
      final XFile file = await controller.takePicture();
      setState(() {
        _capturedImage = file;
        // Set the captured image file
        capturedImageFile = File(file.path);
      });
      // Print the captured image path to the console
    print('Captured Image Path: ${_capturedImage?.path}');
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  Future<void> _onGalleryPressed() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = pickedFile;
        capturedImageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }

    
    return SafeArea(child: new Stack(
      children: [
        FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 0.9, // Adjust this value to control the camera screen's size
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,

            child: _capturedImage != null
            ? Image.file(capturedImageFile!) // Display the captured image
            : CameraPreview(controller), // Display the camera previe
          ),
        ),
      Align(
  alignment: Alignment.bottomCenter,
  child: Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: GestureDetector(
      onTap: _onCapturePressed, // Specify the function to run when tapped
      child: Container(
        width: 64.0, // Adjust the width as needed
        height: 64.0, // Adjust the height as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
         color:Color.fromARGB(126, 11, 100, 1), // Adjust the color as needed
        ),
        child: Center(
          child: Icon(
            Icons.camera_alt,
            size: 32.0, // Adjust the size as needed
            color: Colors.white, // Adjust the color as needed
          ),
        ),
      ),
    ),
  ),
),

        Positioned(
          bottom: 16.0,
          right: 16.0,
           child: isLoading
                ? CircularProgressIndicator() // Display a loading indicator
                : IconButton(
                    onPressed: () async {
                      if (capturedImageFile == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Please Select an Image',style: GoogleFonts.openSans(fontSize: 20)),
                              content: Container(
                                width: 300,
                                height: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('You must select an image before sending.', style: GoogleFonts.openSans(fontSize: 16)),
                                    SizedBox(height: 16),
                                    TextButton(
                                      child: Text('OK', style: GoogleFonts.openSans(fontSize: 18)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        print('No image selected.');
                        return;
                      }
              await sendImage();
                /* Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loading()),
                  );*/
                  await navigateToDiseaseDetails();
            },
            icon: Icon(
              Icons.send, // You can change this to the desired send icon
              size: 32.0, // Adjust the size as needed
              color: Colors.white, // Adjust the color as needed
            ),
          ),
        ),
        Positioned(
          bottom: 16.0,
          left: 16.0,
          child: IconButton(
            onPressed: _onGalleryPressed,
            icon: Icon(
              Icons.photo_library, // Icon for sending the photograph
              size: 32.0, // Adjust the size as needed
              color: Colors.white, // Adjust the color as needed
            ),
          ),
        ),
      ],
    ),
    );
  }

  Future<void> sendImage() async {
    if (capturedImageFile == null) {
      print('No image selected.');
      return;
    }

    // Display a loading indicator while sending the image
    setState(() {
      isLoading = true;
    });

    // Define the server URL where you want to send the image
    const serverUrl = 'http://10.30.2.252:5000/predict'; // Replace with your actual server URL

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
    request.files.add(await http.MultipartFile.fromPath('image', capturedImageFile!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Handle a successful response from the server
        print('Image sent successfully.');
        
      } else {
        // Handle an error response
        print('Failed to send image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      // Remove the loading indicator when the operation is complete
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> navigateToDiseaseDetails() async {
  if (capturedImageFile == null) {
    print('No image selected.');
    return;
  }

  // Define the URL of your Flask API
  const flaskApiUrl = 'http://10.30.2.252:5000/get-predicted-label';
  // Create an HTTP client


  try {
    final responseFromFlask = await http.get(Uri.parse(flaskApiUrl));

    if (responseFromFlask.statusCode == 200) {
      // Parse the JSON response from your Flask API
      final Map<String, dynamic> data = json.decode(responseFromFlask.body);
      String predicted_Label = data['predictedLabel']; // Obtained from Flask API

      // Define the server URL of your Spring Boot API
      final springBootApiUrl = 'http://10.30.2.252:8080/api/v1/auth/findDiseaseByName?name=$predicted_Label';

      // Append the predictedLabel to the Spring Boot API URL
      //final fullUrl = '$springBootApiUrl$predictedLabel';

      // Continue with the GET request
      final response = await http.get(Uri.parse(springBootApiUrl));

      if (response.statusCode == 200) {
        capturedImageFile = null;
        // Parse the JSON response from the Spring Boot API
        final Map<String, dynamic> data = json.decode(response.body);
        String diseaseName = data['diseaseName'];
        String solution = data['solution'];
        String image = data['image'];
        HiveBoxes.history.add([diseaseName,solution,image]);
        // Navigate to the DiseaseDetailsPage and pass the disease details including predictedLabel
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseDetailsPage(
              diseaseName: diseaseName,
              solution: solution,
              imageUrl: image,
            ),
          ),
        ).then((value) {
      // Reset _capturedImage to null when returning from DiseaseDetailsPage
      setState(() {
        _capturedImage = null;
      });
    });
      } else {
        // Handle an error response from the Spring Boot API
        print('Failed to fetch disease details from Spring Boot API. Status code: ${response.statusCode}');
      }
    } else {
      // Handle an error response from the Flask API
      print('Failed to fetch predictedLabel from Flask API. Status code: ${responseFromFlask.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
}
