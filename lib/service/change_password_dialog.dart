import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_app/generated/l10n.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      _showDialog('كلمة المرور الجديدة لا تتطابق');
      return;
    }

    try {
      // Reauthenticate the user before changing the password
      User? user = _auth.currentUser;
      if (user == null) {
        _showDialog('تسجيل الدخول غير صالح');
        return;
      }

      // Reauthenticate with the current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Change the password
      await user.updatePassword(newPassword);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showDialog('كلمة المرور الحالية غير صحيحة');
      } else {
        _showDialog('حدث خطأ. حاول مرة أخرى لاحقاً');
      }
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.startsWith('تم') ? 'نجاح' : 'خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).changePassword),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: S.of(context).currentPassword),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: S.of(context).newPassword),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: S.of(context).confirmPasswordText),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 21, 68, 23),
                foregroundColor: Colors.white, // Change the text color
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Adjust padding if needed
              ),
              onPressed: _changePassword,
              child: Text(S.of(context).changePassword),
            ),
          ],
        ),
      ),
    );
  }
}
