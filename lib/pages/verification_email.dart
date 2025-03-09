import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_app/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_app/generated/l10n.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  bool canResend = false;
  Timer? timer;
  int countdown = 60;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    _startResendTimer();
  }

  void _checkEmailVerification() {
    User? user = FirebaseAuth.instance.currentUser;
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await user?.reload(); // Reload the user to check if the email is verified
      user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == true) {
        if (mounted) {
          setState(() {
            isEmailVerified = true;
            canResend = false;
          });
        }
        timer.cancel(); // Stop the timer
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).emailVerified)),
        );
      }
    });
  }

  void _startResendTimer() {
    setState(() {
      canResend = false;
      countdown = 60; // Reset countdown
    });

    Timer.periodic(const Duration(seconds: 1), (Timer countdownTimer) {
      if (mounted) {
        if (countdown > 0) {
          setState(() {
            countdown--;
          });
        } else {
          setState(() {
            canResend = true;
          });
          countdownTimer.cancel(); // Stop the countdown timer
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: height * 0.15),
            const Icon(Icons.email, size: 150, color: Colors.black),
            const SizedBox(height: 20),
            Center(
              child: Text(
                isEmailVerified
                    ? S.of(context).emailVerified
                    : S.of(context).checkEmail,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            if (!isEmailVerified)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).didNotReceiveEmail,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    S.of(context).resendCountdown(countdown),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: canResend
                        ? () {
                            AuthService().resendVerificationEmail(context);
                            _startResendTimer();
                          }
                        : null,
                    child: Text(
                      S.of(context).resend,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 17, 85, 45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
