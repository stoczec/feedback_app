import 'package:feedback_app/src/components/button.dart';
import 'package:feedback_app/src/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign in user in
  void signIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      // display error message
      displayMessage(e.code);
    }
  }

  // display a dialog message
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen =
        MediaQuery.of(context).size.width > 600; // Определение больших экранов

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Уменьшение горизонтальных отступов
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Увеличение размера значка для больших экранов
                Icon(Icons.lock_person_outlined,
                    size: isLargeScreen ? 200 : 100),
                const SizedBox(height: 50),
                Text("Welcome back, you've been missed!",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: isLargeScreen
                          ? 24
                          : 16, // Увеличение размера шрифта для больших экранов
                    )),
                const SizedBox(height: 25),
                // Адаптация ширины поля ввода
                SizedBox(
                  width: isLargeScreen ? 400 : 300,
                  child: MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),

                // Адаптация ширины поля ввода
                SizedBox(
                  width: isLargeScreen ? 400 : 300,
                  child: MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10),

                // Адаптация ширины кнопки
                SizedBox(
                  width: isLargeScreen ? 400 : 300,
                  child: MyButton(onTap: signIn, text: 'Sign in'),
                ),

                const SizedBox(height: 25),
                // go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: isLargeScreen
                              ? 16
                              : 14, // Увеличение размера шрифта для больших экранов
                        )),
                    const SizedBox(width: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Register now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              // fontSize: isLargeScreen ? 16 : 14, // Увеличение размера шрифта для больших экранов
                            )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
