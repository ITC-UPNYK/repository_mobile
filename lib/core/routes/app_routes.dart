import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:repo/views/screens/index.dart';

abstract class AppRoutesRepo {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotpass';
  static const String discussMateri = '/discuss';

  static List<GetPage<Widget>> pages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: signup,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: discussMateri, 
      page: () => const DiscussMateri(),
    ),
  ];
}
