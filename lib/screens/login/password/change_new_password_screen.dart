// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/routes.dart';

class ChangeNewPasswordScreen extends StatefulWidget {
  String phoneNumber;
  int code;
  ChangeNewPasswordScreen({Key? key, required this.phoneNumber, required this.code}) : super(key: key);

  @override
  State<ChangeNewPasswordScreen> createState() => _ChangeNewPasswordScreenState();
}

class _ChangeNewPasswordScreenState extends State<ChangeNewPasswordScreen> {
  String password = '';
  String confirmPassword = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Text(
                    'Изменить пароль',
                    style: AppTextStyles.h18Regular.copyWith(color: AppColors.blackGreyText, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              HBox(40.h),
              Text(
                'Введите новый пароль',
                style: AppTextStyles.h18Regular.copyWith(color: AppColors.blackGreyText, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              HBox(12.h),
              Container(
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  border: Border.all(color: AppColors.black)
                ),
                child: TextFormField(
                  validator: (value) {
                    confirmPassword = value ?? '';
                    if (value!.isEmpty) {
                      return "Please Enter New Password";
                    } else {
                      return null;
                    }
                  },
                  autocorrect: true,
                  onChanged: (String val) {
                    setState(() {
                      password = val;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    hintText: '',

                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                ),
              ),
              HBox(12.h),
              Text(
                'Подтвердите пароль',
                style: AppTextStyles.h18Regular.copyWith(color: AppColors.blackGreyText, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              HBox(12.h),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    border: Border.all(color: AppColors.black)
                ),
                alignment: Alignment.center,
                height: 40,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Re-Enter New Password";
                    } else if (value != confirmPassword) {
                      return "Пароли должны совпадать";
                    } else {
                      return null;
                    }
                  },
                  autocorrect: true,
                  onChanged: (String val) {
                    setState(() {
                      confirmPassword = val;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    hintText: '',

                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: ()async{
                  if (_formKey.currentState!.validate()) {
                    var item = await RestServices().sendNewResetPassword(userName: widget.phoneNumber, code: widget.code, firstNewPassword: password, secondNewPassword: confirmPassword);
                    if(item == 200){
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                       MotionToast.success(
                        description: const Text(
                          'Вы успешно изменили пароль',
                          style: TextStyle(fontSize: 12),
                        ),
                        position: MotionToastPosition.top,
                        layoutOrientation: ToastOrientation.ltr,
                        animationType: AnimationType.fromTop,
                        dismissable: true,
                      ).show(context);
                    }else{
                      MotionToast.error(
                        description: const Text(
                          'Произошли ошибки,пожалуйста повторите позже',
                          style: TextStyle(fontSize: 12),
                        ),
                        position: MotionToastPosition.top,
                        layoutOrientation: ToastOrientation.ltr,
                        animationType: AnimationType.fromTop,
                        dismissable: true,
                      ).show(context);
                    }
                  }

                },
                child: Container(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(4.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      color: AppColors.primary),
                  child: Text(
                    'Далее',
                    style: AppTextStyles.h18Regular
                        .copyWith(color: AppColors.white, fontSize: 14.sp),
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
