import 'dart:async';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/routes.dart';

class SplashAppView extends StatefulWidget {
  const SplashAppView({Key? key}) : super(key: key);

  @override
  State<SplashAppView> createState() => _SplashAppViewState();
}

class _SplashAppViewState extends State<SplashAppView> {
  bool error = false;
  bool hideSplash = false;

  @override
  void initState() {
    getInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await startTimeout();
      }
    });
    super.initState();
  }

  Future startTimeout() async {
    return Timer(Duration(seconds: 2), changeScreen);
  }
  Future changeScreen() async {
   await  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.first, (route) => true);
  }


  Future getInit() async {

    if (!hideSplash) {
      /// прекращаем показывать splash
      FlutterNativeSplash.remove();
      setState(() {
        hideSplash = true;


      });

    }

  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset('assets/images/g10.png', width: 22.w, height: 24.h,),
                  WBox(8.w),
                  Image.asset('assets/images/repair.png', width: 96.w, height: 16.h,)
              ],
            ),
          )
    );
  }
}
