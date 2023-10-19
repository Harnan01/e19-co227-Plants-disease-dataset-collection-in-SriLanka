import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiseaseDetailsPage extends StatelessWidget {
  final String diseaseName;
  final String solution;
  final String imageUrl;

  DiseaseDetailsPage({required this.diseaseName, required this.solution, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 255, 208),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 238, 255, 208),
        title: Text('Disease Details',style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.openSans().fontFamily,
                color: Colors.black87,
              ),),
              //iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView( // Wrap your content in SingleChildScrollView for scrolling
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200, // You can adjust the height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl), // Load the image from a URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Disease Name: ${diseaseName}',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.openSans().fontFamily,
                color: Colors.black87,
              ),
            ),
          ),

          Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the left
    children: [
      Text(
        'Solution:',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.openSans().fontFamily,
          color: Colors.black87,
        ),
      ),
    ],
  ),
),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${solution}',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: GoogleFonts.openSans().fontFamily,
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
      ),
    ),
    );
  }
}
