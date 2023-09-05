import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/routes.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tokenStore = getIt.get<TokenStoreService>();
    print(tokenStore.accessToken);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('С чем вам помочь?',
            style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.bold),),
            SizedBox(height: 16.h,),
            GestureDetector(
              onTap: ()=>Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.mainNav, (route) => false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ищу специалиста', style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600),),
                          Text('Хочу заказать услугу или\nнайти сотрудника', style: AppTextStyles.errorSmall.copyWith(color: AppColors.textMain),),
                        ],
                      ),
                    ),
                    Image.asset('assets/icons/search_people.jpg', width: 150, height: 150,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h,),
            GestureDetector(
              onTap: ()=>Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.firsts, (route) => true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ищу работу', style: AppTextStyles.bodyPrimary.copyWith(fontWeight: FontWeight.w600)),
                          Text('Я предоставляю услуги\nили ищу постоянную\nработу', style: AppTextStyles.errorSmall.copyWith(color: AppColors.textMain),),
                        ],
                      ),
                    ),
                    Image.asset('assets/icons/search_work.jpg', width: 150, height: 150)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
