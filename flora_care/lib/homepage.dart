
import 'package:flutter/material.dart';
import 'Camera.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flora Care App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to FloraCare!',
                  style: Theme.of(context).textTheme.headline5,
                ),
            // Add your "Flora Care" feature widget here
                FloraCareFeatureWidget(),
            // You can add more widgets for other features here
          ],
        ),
      ),
    Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Camera()),
            );
              },
              tooltip: 'Capture',
              child: Icon(Icons.camera_alt),
            ),
            SizedBox(height: 16.0), // Add some space between button and arrow
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    ),
    ],
   ),
    );
  }
}

// Define a simple "Flora Care" feature widget
class FloraCareFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Your Personal Botanical Companion ",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20), // Add some space between text and image
          Image.asset(
            'assets/logo.png', // Provide the correct asset path
            width: 150, // Adjust the width of the logo
            height: 150, // Adjust the height of the logo
          ),
          // Add more content specific to your "Flora Care" feature here
          // Example of adding an image

          // You can continue adding more widgets as needed
        ],
      ),
    );
  }
}