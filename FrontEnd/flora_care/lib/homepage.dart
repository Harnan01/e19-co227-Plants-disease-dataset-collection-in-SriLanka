import 'package:camera/camera.dart';
import 'package:flora_care/camera1.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
//import 'history.dart';
import 'HiveBoxes.dart';
import 'package:hive/hive.dart';
import 'login.dart';
import 'diseasedetailspage.dart';
//import 'HiveBoxes.dart';

//import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flora Care App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 84, 3)),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    History(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedPage),
      ),
      bottomNavigationBar: GNav(
        color: Colors.grey,
        activeColor: Colors.lightGreenAccent,
        gap: 8,
        selectedIndex: _selectedPage,
        onTabChange: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(icon: Icons.history, text: 'History'),
        ],
      ),
    );
  }
}

void _handleLogout(BuildContext context, String token) async {
  try {
    // Send a request to your Spring Boot API to expire the token
    final response = await http.post(
      Uri.parse("http://192.168.8.156:8080/api/v1/auth/logout"), // Replace with your API endpoint
      headers: {
        'Authorization': 'Bearer $token', // Include the token in the request headers
      },
    );

    if (response.statusCode == 200) {
      // Token expired successfully, remove it from storage and navigate to the login page
      await removeTokenFromStorage();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    } else {
      // Handle errors, e.g., token not expired
      // You can show an error message to the user or take appropriate action.
    }
  } catch (error) {
    // Handle network errors or other exceptions
    // You can show an error message to the user or take appropriate action.
  }
}


// Function to remove the token from storage (using Hive)
Future<void> removeTokenFromStorage() async {
  try {
    final box = await Hive.openBox<String>(HiveBoxes.tokenBox);
    await box.delete('token');
  } catch (e) {
    // Handle any potential errors, e.g., when Hive is not initialized or the box doesn't exist
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<CameraDescription> cameras;
  @override
  void initState() {
    super.initState();
    // Load the available cameras
    availableCameras().then((cameras) {
      setState(() {
        this.cameras = cameras;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightGreenAccent[200],
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              color: Colors.lightGreenAccent[200],
              height: 212,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/logo-rm.png",
                          height: 100,
                          alignment: Alignment.centerLeft,
                        ),
                        Text(
                          "Flora care",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'GoogleSans',
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            onPressed: () async{final token = await getTokenFromStorage(); // Implement this function

    if (token != null) {
      // Call the logout function with context and token
      _handleLogout(context, token);
    } else {
      // Handle the case where the token is not available
      // You can show an error message or take appropriate action.
    }

                            },
                          ),
                        )
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Expanded(
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Hi " + "" + " !",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(30)),
                color: Color.fromARGB(255, 238, 255, 208),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Text(
                      "Welcome to flora care",
                      style: TextStyle(color: Colors.green, fontSize: 25),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(25.7, 30, 30, 25),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blueGrey[100],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              color: Colors.green[100],
                              height: 50,
                              margin: EdgeInsets.fromLTRB(20, 50, 0, 10),
                              child: Text(
                                "Step 1",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white54,
                                alignment: Alignment.center,
                                child: Text(
                                  "Take the picture",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                height: 50,
                                margin: EdgeInsets.fromLTRB(0, 50, 20, 10),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              color: Colors.green[100],
                              height: 50,
                              margin: EdgeInsets.fromLTRB(20, 40, 0, 20),
                              child: Text(
                                "Step 2",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                alignment: Alignment.center,
                                child: Text(
                                  "Find the Solution",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                height: 50,
                                margin: EdgeInsets.fromLTRB(0, 40, 20, 20),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              color: Colors.green[100],
                              height: 50,
                              margin: EdgeInsets.fromLTRB(20, 30, 0, 50),
                              child: Text(
                                "Step 3",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Text(
                                  "Treat the Plant",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                height: 50,
                                margin: EdgeInsets.fromLTRB(0, 30, 20, 50),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextButton(
                      child: Text(
                        "Diagnose",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                        ),
                        backgroundColor: Color.fromARGB(255, 22, 175, 40),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Camera1(cameras)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<String?> getTokenFromStorage() async {
  try {
    final box = await Hive.openBox<String>(HiveBoxes.tokenBox);
    final token = box.get('token');
    return token;
  } catch (e) {
    // Handle any potential errors, e.g., when Hive is not initialized or the box doesn't exist
    return null;
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Image.asset(
              'assets/logo-rm.png',
              fit: BoxFit.fitHeight,
              height: 40,
            ),
            Text("Flora care")
          ]),
          backgroundColor: Colors.lightGreenAccent,
        ),
        body: ListView.builder(
          itemCount: HiveBoxes.history.items.length,
          itemBuilder: (context, index) {
            final item = HiveBoxes.history.items[index];
            final diseaseName = item[0],solution = item[1],image=item[2]; // Access disease name from the list

            return GestureDetector(
              onTap: () {
                // Handle item click here, e.g., navigate to a new widget
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DiseaseDetailsPage(
                      diseaseName: diseaseName,
                      solution: solution,
                      imageUrl: image,
                      // Pass other data as needed
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(diseaseName),
                // You can display other data (solution, image) as needed
              ),
            );
          },
        ));
  }
}


