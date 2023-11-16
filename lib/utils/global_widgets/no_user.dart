import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/routes.dart';

class NoAuthPageView extends StatelessWidget {
  const NoAuthPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.w,
              child: const Text(
                'Войдите, чтобы создать задания, ответить на сообщения или найти того, кто вам нужен',
                style: TextStyle(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.w),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.sign, (route) => false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(12.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      color: AppColors.white),
                  child: Text(
                    'Войти или создать профиль',
                    style: AppTextStyles.body14Secondary.copyWith(
                        color: AppColors.primary, fontSize: 14.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
