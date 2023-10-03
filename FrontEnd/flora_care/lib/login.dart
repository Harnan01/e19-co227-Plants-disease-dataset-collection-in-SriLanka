import 'package:flora_care/signup.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'homepage.dart';
import 'simple_ui_controller.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
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
  String? token;
  int? id;

  void logIn(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse("http://192.168.8.155:8080/api/v1/auth/authenticate"), // Replace with your login API endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("Login successful");
      showSnackBar("Login successful");

      final jsonResponse = json.decode(response.body);
      token = jsonResponse['token'];
      id = jsonResponse['id'];
      print(token);
      print(id);
      Navigator.push(
      context,
        MaterialPageRoute(builder: (context) => MyApp()), // Replace with your home page widget
      );

      // Save the token in SharedPreferences or wherever you prefer to store it.
      // Handle the successful login as needed.
    } else {
      print("Login failed. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      showSnackBar("Login failed. Please check your email and password.");
    }
  } catch (e) {
    print("Error during HTTP request: $e");
    showSnackBar("Error during login");
  }
}

void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController);
            } else {
              return _buildSmallScreen(size, simpleUIController);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
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
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: size.width > 600
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            size.width > 600
                ? Container()
                : Image.asset(
                    'assets/lgin-im.jpg', // Replace with your image asset path
                    height: size.height * 0.4,
                    width: size.width,
                    fit: BoxFit.fill,
                  ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Login',
                style: kLoginTitleStyle(size),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Welcome Back to FloraCare',
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
                    /// username or Gmail
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      controller: nameController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
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
                            return 'Please enter password';
                          } else if (value.length < 7) {
                            return 'at least enter 6 characters';
                          } else if (value.length > 30) {
                            return 'maximum character is 30';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.05,
                    ),

                    /// Login Button
                    loginButton(),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    GestureDetector(
                      onTap: () {
                        // Navigate to the "Forgot Password" screen here.
                        // You can use a MaterialPageRoute or any routing method you prefer.
                        // Make sure to create a new screen for password reset.
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Forgot your password?',
                          style: kLoginOrSignUpTextStyle(
                                size,
                              ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    /// Navigate To signup Screen
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (ctx) => SignUp()));
                        nameController.clear();
                        emailController.clear();
                        passwordController.clear();
                        _formKey.currentState?.reset();
                        simpleUIController.isObscure.value = true;
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: kHaveAnAccountStyle(size),
                          children: [
                            TextSpan(
                              text: " Sign up",
                              style: kLoginOrSignUpTextStyle(
                                size,
                              ),
                            ),
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

  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 22, 175, 40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
          logIn(nameController.text, passwordController.text);
        }
        },
        child: const Text(
          'Login',
        ),
      ),
    );
  }
}
