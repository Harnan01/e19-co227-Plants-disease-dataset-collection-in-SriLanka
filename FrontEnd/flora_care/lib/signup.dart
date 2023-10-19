import 'dart:convert';
import 'package:flora_care/homepage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
//import 'homepage.dart';
import 'login.dart';
import '../constants.dart';
import 'simple_ui_controller.dart';
import 'HiveBoxes.dart';
import 'package:hive/hive.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());
  String token = "";

  void signUp(String username, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse("http://192.168.8.156:8080/api/v1/auth/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "userName": username,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("Account successfully created");

      // Save the token in SharedPreferences here
       final jsonResponse = json.decode(response.body);
       token = jsonResponse['token'];
       await saveTokenToHive(token);
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()), // Replace with your home page widget
      );
    } else {
      print("Failed to create account. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return Material(
      type: MaterialType.transparency, // Make the material transparent
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(1.0), // Set background color to transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27.0), // Adjust the radius as needed
        ),
        title: Text('Failed to create account', style: GoogleFonts.openSans(fontSize: 20)),
        content: Container(
          width: 300,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('The Email is already taken', style: GoogleFonts.openSans(fontSize: 16)),
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
      ),
    );
  },
);

    }
  } catch (e) {
    print("Error during HTTP request: $e");

    showDialog(
  context: context,
  builder: (BuildContext context) {
    return Material(
      type: MaterialType.transparency, // Make the material transparent
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(1.0), // Set background color to transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27.0), // Adjust the radius as needed
        ),
        title: Text('Failed to create account', style: GoogleFonts.openSans(fontSize: 20)),
        content: Container(
          width: 300,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Error during signup', style: GoogleFonts.openSans(fontSize: 16)),
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
      ),
    );
  },
);
    
  }
}

Future<void> saveTokenToHive(String token) async {
  final box = await Hive.openBox<String>(HiveBoxes.tokenBox);
  await box.put('token', token);
}



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child:Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size, simpleUIController, theme);
              } else {
                return _buildSmallScreen(size, simpleUIController, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Image.asset(
            'assets/coin.jpg', // Replace with your image asset path
            height: size.height * 0.25,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      child: SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
          ? Container()
          : Image.asset(
              'assets/siup-im.jpg', // Replace with your image asset path
              height: size.height * 0.25,
              width: size.width,
              fit: BoxFit.fill,
            ),
      SizedBox(
        height: size.height * 0.03,
      ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Sign Up',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Create Account',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// username
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),

                  controller: nameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } else if (value.length < 4) {
                      return 'at least enter 4 characters';
                    } else if (value.length > 30) {
                      return 'maximum character is 30';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    hintText: 'gmail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter gmail';
                    } else if (!value.endsWith('@gmail.com')) {
                      return 'please enter valid gmail';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value.length < 7) {
                        return 'at least enter 6 characters';
                      } else if (value.length > 30) {
                        return 'maximum character is 30';
                      }
                      return null;
                    },
                  ),
                ),
               
                Text(
                  'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                signUpButton(theme),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (ctx) => LogIn()));
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();

                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                            text: " Login",
                            style: kLoginOrSignUpTextStyle(size)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    ),
    ),
    );
  }

  // SignUp Button
 Widget signUpButton(ThemeData theme) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          signUp(nameController.text, emailController.text, passwordController.text);
        }
      },
      splashColor: Color.fromARGB(100, 255, 255, 255), // Adjust the alpha (150) for more or less effect
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 22, 175, 40),
        ),
        child: Center(
          child: Text(
            'Sign up',
            style: TextStyle(
              fontSize: 20, // Adjust the font size as needed
              color: Colors.white, // Change the font color to white
              fontFamily: 'GoogleSans', // Replace 'GoogleSans' with your desired Google Font family
            ),
          ),
        ),
      ),
    ),
  );
}


}
