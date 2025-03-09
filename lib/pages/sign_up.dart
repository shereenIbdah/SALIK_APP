import 'package:grad_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:grad_app/model/registered_user.dart';
import 'package:grad_app/generated/l10n.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  String? _selectedCity;
  bool _isFrequentDriver = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _passwordError;
  bool _isCityListVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = RegisteredUser(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        city: _selectedCity ?? "",
        isFrequentDriver: _isFrequentDriver,
        weight: 0,
        // _isFrequentDriver ? 0.5 : 10 + Random().nextDouble() * (30 - 10),
        // if admin
      );

      AuthService().signUp(
        fullName: user.fullName,
        email: user.email,
        password: user.password,
        city: user.city,
        isFrequentDriver: user.isFrequentDriver,
        weight: user.weight,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppConstants.primaryColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.03),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: screenSize.height * 0.1,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.1,
                      vertical: screenSize.height * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        S.of(context).createAccount,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Full Name Field
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: S.of(context).fullName,
                          labelStyle: const TextStyle(
                            color: AppConstants.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          prefixIcon: const Icon(Icons.person,
                              color: AppConstants.primaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).fullNameValidation;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: S.of(context).emailPhone,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).emailValidation;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).passwordValidation;
                          }
                          if (value.length < 8) {
                            return S.of(context).passwordValidation;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: S.of(context).confirmPassword,
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
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppConstants.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          errorText: _passwordError,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).confirmPasswordValidation;
                          }
                          if (value != _passwordController.text) {
                            return S.of(context).passwordMismatchValidation;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // City Selection
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCityListVisible = !_isCityListVisible;
                          });
                        },
                        child: Container(
                          height: screenSize.height * 0.075,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppConstants.textColor),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_city,
                                  color: AppConstants.primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedCity ?? S.of(context).selectCity,
                                  style: const TextStyle(
                                    color: AppConstants.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isCityListVisible)
                        Container(
                          height: screenSize.height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            itemCount: AppConstants.cities.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  AppConstants.cities[index],
                                  style: const TextStyle(
                                      color: AppConstants.textColor),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedCity = AppConstants.cities[index];
                                    _isCityListVisible = false;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Frequent Driver Checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _isFrequentDriver,
                            onChanged: (value) {
                              setState(() {
                                _isFrequentDriver = value!;
                                if (_isFrequentDriver) {
                                  _showDriverRouteDialog(); // استدعاء نافذة إدخال الهاتف وخط السير
                                }
                              });
                            },
                          ),
                          Text(
                            S.of(context).frequentDriverQuestion,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 68, 65, 65)),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: screenSize.height * 0.065,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.green,
                                Color.fromARGB(255, 135, 160, 107),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              S.of(context).signUp,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
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
      ),
    );
  }

  void _showDriverRouteDialog() {
    String phoneNumber = "";
    String selectedRoute = "رام الله - القدس"; // افتراضي

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "معلومات السائق المتكرر",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // إدخال رقم الهاتف
              TextField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "رقم الهاتف",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              const SizedBox(height: 10),

              // اختيار خط السير
              DropdownButtonFormField<String>(
                value: selectedRoute,
                decoration: const InputDecoration(
                  labelText: "اختر خط السير",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "رام الله - القدس",
                  "نابلس - رام الله",
                  "الخليل - بيت لحم",
                  "طولكرم - نابلس",
                  "جنين - نابلس",
                  "سلفيت - رام الله",
                  "سلفيت - نابلس",
                  "رام الله - أريحا",
                  "طولكرم - رام الله",
                ].map((String route) {
                  return DropdownMenuItem(
                    value: route,
                    child: Text(route),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedRoute = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة بدون حفظ
              },
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                if (phoneNumber.isEmpty) {
                  // عرض خطأ إذا لم يتم إدخال رقم الهاتف
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("يرجى إدخال رقم الهاتف")),
                  );
                  return;
                }

                // حفظ البيانات (يمكن إرسالها إلى قاعدة بيانات)
                print("رقم الهاتف: $phoneNumber, خط السير: $selectedRoute");

                Navigator.pop(context); // إغلاق النافذة بعد التأكيد
              },
              child: const Text("تأكيد"),
            ),
          ],
        );
      },
    );
  }
}
