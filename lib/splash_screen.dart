import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/shared_pr_widget.dart';
import 'package:remont_kz/utils/routes.dart';

class SplashAppView extends StatefulWidget {
  const SplashAppView({Key? key}) : super(key: key);

  @override
  State<SplashAppView> createState() => _SplashAppViewState();
}

class _SplashAppViewState extends State<SplashAppView> {
  bool error = false;
  bool hideSplash = false;

  final _storage = const FlutterSecureStorage();
  var localAuth = LocalAuthentication();
  final String KEY_USERNAME = "KEY_USERNAME";
  final String KEY_PASSWORD = "KEY_PASSWORD";
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  late String email;
  late String password;
  GetProfile profile = GetProfile();
  final String KEY_LOCAL_AUTH_ENABLED = "KEY_LOCAL_AUTH_ENABLED";
  late bool seen;

  Future startTimeout() async {
    return Timer(const Duration(seconds: 2), changeScreens);
  }

  Future changeScreens() async {
    await SharedPreferencesHelper.getSeen().then((value) async {

      seen = value ?? false;

      seen == false
          ? await Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.help, (route) => false)
          : await _readFromStorage(context).then((value) async{
        profile = await RestServices().getMyProfile();
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  profile.isClient! ? AppRoutes.mainNav : AppRoutes.mainNavWorker,
                  (route) => false);
            });
    });
  }

  Future<void> _readFromStorage(BuildContext context) async {
    String isLocalAuthEnabled =
        await _storage.read(key: "KEY_LOCAL_AUTH_ENABLED") ?? "false";
    if ("true" == isLocalAuthEnabled) {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Пожалуйста, авторизуйтесь, чтобы войти');
      if (didAuthenticate) {
        emailController.text = await _storage.read(key: KEY_USERNAME) ?? '';
        passwordController.text = await _storage.read(key: KEY_PASSWORD) ?? '';
        email = emailController.text;
        password = passwordController.text;
        var api = await RestServices().auth(login: email, password: password);
        if (api == 200) {
          GetProfile serviceProfile = await RestServices().getMyProfile();
          if (serviceProfile.isClient!) {
            await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNav, (route) => true);
          } else {
            await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNavWorker, (route) => true);
          }
        }
      } else {
        emailController.text = await _storage.read(key: KEY_USERNAME) ?? '';
        passwordController.text = await _storage.read(key: KEY_PASSWORD) ?? '';
        email = emailController.text;
        password = passwordController.text;
        var api = await RestServices().auth(login: email, password: password);
        if (api == 200) {
          GetProfile serviceProfile = await RestServices().getMyProfile();
          if (serviceProfile.isClient!) {
            await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNav, (route) => true);
          } else {
            await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNavWorker, (route) => true);
          }
        }
      }
    } else {
      print(await _storage.read(key: KEY_USERNAME));
      emailController.text = await _storage.read(key: KEY_USERNAME) ?? '';
      passwordController.text = await _storage.read(key: KEY_PASSWORD) ?? '';
      email = emailController.text;
      password = passwordController.text;
      var api = await RestServices().auth(login: email, password: password);
      if (api == 200) {
        GetProfile serviceProfile = GetProfile();
        serviceProfile = await RestServices().getMyProfile();
        if (serviceProfile.isClient!) {
          await Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.mainNav, (route) => true);
        } else {
          await Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.mainNavWorker, (route) => true);
        }
      }
    }
  }

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
              Image.asset(
                'assets/images/g10.png',
                width: 22.w,
                height: 24.h,
              ),
              WBox(8.w),
              Image.asset(
                'assets/images/repair.png',
                width: 96.w,
                height: 16.h,
              )
            ],
          ),
        ));
  }
}
