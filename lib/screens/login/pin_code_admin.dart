// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/screens/login/password/change_new_password_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';

import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/global_widgets/shared_pr_widget.dart';
import 'package:remont_kz/utils/routes.dart';


class PinCodePage extends StatefulWidget {
  final String number;
  final String password;
  bool changePassword;
  bool? isWorkers;
  PinCodePage(this.number, this.password, this.isWorkers, this.changePassword);

  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> with TickerProviderStateMixin{
  dynamic _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 45));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color:  AppColors.white,
    borderRadius: BorderRadius.circular(5.w),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(
              'Введите код из СМС',
              style: AppTextStyles.h18Regular.copyWith(color: AppColors.blackGreyText, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),

            InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
              },
              child: Text(
                'На номер  ${widget.number} отправлен SMS - код',

              ),
            ),
            SizedBox(
              height: 48.w,
            ),
            Align(
                alignment: Alignment.center,
                child: Pinput(
                  length: 4,
                  // autovalidateMode: AutovalidateMode.always,
                  // fieldsAlignment: MainAxisAlignment.spaceAround,
                  // textStyle: TextStyle(fontSize: 24.0.w, color:  AppColors.blackGreyText),
                  // eachFieldWidth: 64.w,
                  // eachFieldHeight: 72.w,
                  keyboardType: TextInputType.phone,
                  // submittedFieldDecoration: pinPutDecoration,
                  // selectedFieldDecoration: pinPutDecoration.copyWith(
                  //   color: AppColors.white,
                  //   border: Border.all(width: 1, color: AppColors.primary),
                  // ),
                  onChanged: (String val) async {
                    if(!widget.changePassword){
                      if(val.trim().length == 4) {
                        var pin = int.parse(val);
                        // InputHelper.hideKeyboard(context);
                        var api = await RestServices().checkSmsCode(code: pin, userName: widget.number);

                        if(api == 200){
                          await RestServices().auth(login: widget.number, password: widget.password);
                          if(widget.isWorkers==true){
                            await  Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.mainNavWorker, (route) => true);
                          }else{
                            await  Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.mainNav, (route) => true);
                          }
                          SharedPreferencesHelper.setSeen(true);

                        }
                      }
                    }else{
                      if(val.trim().length == 4) {
                        var pin = int.parse(val);
                        // InputHelper.hideKeyboard(context);
                        var api = await RestServices().checkSmsCode(code: pin, userName: widget.number);

                        if(api == 200){
                          await Navigator.push(context,
                          MaterialPageRoute(builder: (_)=>ChangeNewPasswordScreen(phoneNumber: widget.number, code: pin,)));

                        }
                      }
                    }

                  },
                  // followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.scale,
                )),
            SizedBox(
              height: 48.w,
            ),
            InkWell(
              onTap: (){
                // _controller = AnimationController(vsync: this, duration: const Duration(seconds: 45));
              },
              child: Countdown(
                animation: StepTween(
                  begin: 45, // THIS IS A USER ENTERED NUMBER
                  end: 0,
                ).animate(_controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  final Animation<int> animation;
  Countdown({required this.animation, Key? key}) : super(listenable: animation);
  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText = clockTimer.inSeconds.remainder(120).toString().padLeft(2, '0');

    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
      },
      child: Text(
        "Запросить код можно через $timerText секунд",
        style:AppTextStyles.body14Secondary,
      ),
    );
  }
}
