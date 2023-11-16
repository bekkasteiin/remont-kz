import 'package:flutter/material.dart';
import 'package:remont_kz/screens/category/category_screen.dart';
import 'package:remont_kz/screens/connection/screens/connection_error_screen.dart';
import 'package:remont_kz/screens/help/help_screen.dart';
import 'package:remont_kz/screens/login/phone_screen.dart';
import 'package:remont_kz/screens/login/sign_screen.dart';
import 'package:remont_kz/screens/task/main_nav.dart';
import 'package:remont_kz/screens/work_for_worker/main_nav_for_worker.dart';
import 'package:remont_kz/splash_screen.dart';


class AppRoutes {
  static const String root = "/";
  static const String first = "/first";
  static const String firsts = "/firsts";
  static const String mainNav = '/main';
  static const String welcome = "/welcome";
  static const String phone = "/phone";
  static const String sign = "/sign";
  static const String signs = "/signs";
  static const String password = "/password";
  static const String help = "/help";
  static const String mainNavWorker = "/mainNavWorker";
  static const String category = "/category";
  static const String connectionError = "/connectionError";

}

var appRoutes = <String, WidgetBuilder>{
  AppRoutes.root: (context) => const SplashAppView(),
  AppRoutes.mainNav: (context) => const MainNavbar(),
  AppRoutes.first: (context) =>  PhoneScreen(),
  AppRoutes.firsts: (context) =>  PhoneScreen(isWorker: true,),
  AppRoutes.sign: (context) =>  SignScreen(),
  AppRoutes.signs: (context) =>  SignScreen(isWorker: true,),
  AppRoutes.help: (context) => const HelpScreen(),
  AppRoutes.mainNavWorker: (context) => const MainNavbarForWorker(),
  AppRoutes.category: (context) =>  CategoriesScreen(showLeading: false,),
  AppRoutes.connectionError: (context) =>  const ConnectionErrorScreen(),
};
