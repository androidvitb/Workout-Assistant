import 'package:flutter/material.dart';
import 'package:workout_assistant/dart_files/firebase_db.dart';

// this login screen is shown when user clicks on the icon on the top right corner of the app
//
// and after all the process the screen returns a string value which is either "User" or <username> if all the conditions
// are fulfilled for valid login of the username entered in the login screen and many factors matters read the below to know more
//

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isNewUser = false;
  String sendingUsername = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username or Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isNewUser,
                    onChanged: (bool? value) {
                      setState(() {
                        isNewUser = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    "I'm a new user",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (isNewUser) {
                      if (await verifyUser(usernameController.text,
                              passwordController.text) ==
                          false) {
                        sendingUsername = usernameController.text;
                        makeNewUser(
                            usernameController.text, passwordController.text);
                      }
                    } else {
                      if (await verifyUser(
                          usernameController.text, passwordController.text)) {
                        sendingUsername = usernameController.text;
                        // print("Yes user got logged in");
                      }
                    }

                    // String sendingPassword = passwordController.text;
                    if (sendingUsername != "") {
                      Navigator.pop(context, sendingUsername);
                    } else {
                      Navigator.pop(context, "User");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
