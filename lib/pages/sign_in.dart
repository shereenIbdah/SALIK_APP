import 'package:flutter/material.dart';
import 'package:grad_app/constants/constants.dart';
import 'package:grad_app/pages/sign_up.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/generated/l10n.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Sign In Method
  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    AuthService().signIn(email: email, password: password, context: context);
  }

  @override
  Widget build(BuildContext context) {
    double heightOfDevice = MediaQuery.of(context).size.height;
    double widthOfDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(heightOfDevice * 0.08),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back, color: AppConstants.primaryColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo Section
              Container(
                padding: EdgeInsets.symmetric(vertical: heightOfDevice * 0.05),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: heightOfDevice * 0.12,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthOfDevice * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Login Title
                    Text(
                      S.of(context).loginTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: heightOfDevice * 0.05),
                    // Email/Phone Number
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: S.of(context).emailPhoneLabel,
                        labelStyle: const TextStyle(
                          color: AppConstants.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        prefixIcon: const Icon(Icons.email,
                            color: AppConstants.primaryColor),
                      ),
                      style: const TextStyle(fontSize: 18),
                      minLines: 1,
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    SizedBox(height: heightOfDevice * 0.03),
                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: S.of(context).passwordLabel,
                        labelStyle: const TextStyle(
                          color: AppConstants.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        prefixIcon: const Icon(Icons.lock,
                            color: AppConstants.primaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppConstants.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(fontSize: 18),
                      minLines: 1,
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    SizedBox(height: heightOfDevice * 0.05),
                    // Sign In Button
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: widthOfDevice * 0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 135, 160, 107),
                              Colors.green,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: SizedBox(
                          height: heightOfDevice * 0.08,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              S.of(context).signInButton,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: heightOfDevice * 0.1),
                    // Sign Up Link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to Sign Up page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(text: S.of(context).noAccountText),
                              TextSpan(
                                text: S.of(context).signUpLink,
                                style: const TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
