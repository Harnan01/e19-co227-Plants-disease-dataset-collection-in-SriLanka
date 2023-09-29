import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'nointernet.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Loading(),
  )
);

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
      // Internet connection available, navigate to the login page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LogIn(),
      ));
      
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
