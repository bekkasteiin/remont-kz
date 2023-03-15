import 'package:flutter/material.dart';
import 'package:remont_kz/screens/login/phone_screen.dart';
import 'package:remont_kz/screens/login/sign_screen.dart';
import 'package:remont_kz/screens/main_nav.dart';
import 'package:remont_kz/splash_screen.dart';


class AppRoutes {
  static const String root = "/";
  static const String first = "/first";
  static const String mainNav = '/main';
  static const String welcome = "/welcome";
  static const String phone = "/phone";
  static const String sign = "/sign";
  static const String password = "/password";

}

var appRoutes = <String, WidgetBuilder>{
  AppRoutes.root: (context) => const SplashAppView(),
  AppRoutes.mainNav: (context) => const MainNavbar(),
  AppRoutes.first: (context) => const PhoneScreen(),
  AppRoutes.sign: (context) => const SignScreen(),
};
