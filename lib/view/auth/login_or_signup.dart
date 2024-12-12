// import 'package:expense_tracker/view/auth/login/login.dart';
// import 'package:expense_tracker/view/auth/signup/signup_screen.dart';
// import 'package:flutter/material.dart';

// class LoginOrRegister extends StatefulWidget {
//   const LoginOrRegister({Key? key}) : super(key: key);

//   @override
//   State<LoginOrRegister> createState() => _LoginOrRegisterState();
// }

// class _LoginOrRegisterState extends State<LoginOrRegister> {
//   // initially  show the login screen
//   bool showLoginPage = true;
//   void togglePages() {
//     setState(() {
//       showLoginPage = !showLoginPage;
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showLoginPage) {
//       return LoginScreen(onTap: togglePages);
//     } else {
//       return SignupScreen(onTap: togglePages);
//     }
//   }
// }
