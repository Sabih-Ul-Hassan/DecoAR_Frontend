import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import "package:http/http.dart" as http;
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';

class ForgotPasswordEmailScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter your email to reset password'),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;

                // Email validation
                if (!EmailValidator.validate(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid email'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                try {
                  int response = await sendOTP(email);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordOTPScreen(
                          opt: response.toString(), email: email),
                    ),
                  );
                } catch (e) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send OPT'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  print(e);
                  return;
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordOTPScreen extends StatelessWidget {
  late String opt;
  late String email;
  ForgotPasswordOTPScreen({super.key, required this.opt, required this.email});
  final TextEditingController optController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the OTP sent to your email'),
            SizedBox(height: 20),
            TextField(
              controller: optController,
              onChanged: (text) {
                optController.text = text;
              },
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (optController.text == "opt")
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ForgotPasswordNewPasswordScreen(email: email),
                    ),
                  );
                else
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invalid Opt'),
                    duration: Duration(seconds: 1),
                  ));
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordNewPasswordScreen extends StatelessWidget {
  late String email;
  ForgotPasswordNewPasswordScreen({super.key, required this.email});
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter your new password'),
            SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              onChanged: (text) {
                newPasswordController.text = text;
              },
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool reset =
                    await resetPassword(email, newPasswordController.text);
                if (reset) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('password updated'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  if (Navigator.canPop(context)) Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/login");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('password updated'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> sendOTP(String email) async {
  final url1 = Uri.parse(url + "user/sendOTP");

  final Map<String, dynamic> body = {'email': email};

  try {
    final response = await http.post(url1, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final success = responseData['success'] as bool;
      if (success) {
        print('OTP sent successfully!');
        return responseData['opt'] as int; // Indicate success
      } else {
        final message = responseData['message'] as String;
        print('Failed to send OTP: $message');
        return 0; // Indicate failure
      }
    } else {
      // Handle error response
      print('Error sending OTP: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to send OTP');
    }
  } catch (error) {
    // Handle network or other errors
    print('Error sending OTP: $error');
    throw Exception('Failed to send OTP');
  }
}

Future<bool> resetPassword(String email, String password) async {
  final url = Uri.parse('user/newPassword/$password/$email');

  final Map<String, dynamic> body = {};
  try {
    final response = await http.post(url, body: jsonEncode(body));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as bool;
      return responseData;
    } else {
      print('Error resetting password: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to reset password');
    }
  } catch (error) {
    print('Error resetting password: $error');
    throw Exception('Failed to reset password');
  }
}
