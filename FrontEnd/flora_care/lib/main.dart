import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'nointernet.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'homepage.dart';
import 'HiveBoxes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    ),
  );
}


// Define the _handleLogout function here in main.dart




class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      _checkInternetAndNavigate();
    });
  }

  Future<void> _checkInternetAndNavigate() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    // No internet connection, navigate to the no internet page
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => NoInternet(),
    ));
  } else {
    // Check if a token exists in Hive
    final token = await getTokenFromHive(); // Implement this function

    if (token != null && token.isNotEmpty) {
      // Token exists, navigate to the home page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MyApp(), // Replace with your home page widget
      ));
    } else {
      // No token, navigate to the login page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LogIn(),
      ));
    }
  }
}

// Function to check for the token in Hive
Future<String?> getTokenFromHive() async {
  try {
    final box = await Hive.openBox<String>(HiveBoxes.tokenBox);
    final token = box.get('token');
    return token;
  } catch (e) {
    // Handle any potential errors, e.g., when Hive is not initialized or the box doesn't exist
    return null;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ld-bg.jpg'), // Replace with your image asset path
            fit: BoxFit.cover, // Adjust the fit mode as needed
          ),
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FloraCare",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontSize: 24, // Set the desired font size
                  color: Colors.white, // Set the desired text color
                ),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white,),
          ],
      ),
      ),
      ),
    );
  }
}
