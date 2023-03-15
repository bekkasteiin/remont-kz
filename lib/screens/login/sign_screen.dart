import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/routes.dart';

class SignScreen extends StatelessWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            scrollDirection: Axis.vertical,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: AppColors.white,
                      indicatorWeight: 4,
                      tabs: [
                        Tab(
                            child: Text(
                          'Войти',
                          style: AppTextStyles.bodySecondary,
                        )),
                        Tab(
                            child: Text('Зарегистрироваться',
                                style: AppTextStyles.bodySecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            body: const TabBarView(
              children: [SignInScreen(), SignUpScreen()],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HBox(12.h),
          Text(
            'Телефон',
            style: AppTextStyles.bodySecondary,
          ),
          HBox(12.h),
          const TextField(
            autocorrect: true,
            decoration: InputDecoration(
              hintText: '+7 (747)-009-18-12',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          HBox(12.h),
          Text(
            'Пароль',
            style: AppTextStyles.bodySecondary,
          ),
          HBox(12.h),
          const TextField(
            autocorrect: true,
            decoration: InputDecoration(
              hintText: '',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          HBox(12.h),
          Text(
            'Забыли пароль?',
            style: AppTextStyles.bodySecondary,
          ),
          HBox(12.h),
          GestureDetector(
            onTap: () async => await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNav, (route) => true),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  color: AppColors.white),
              child: Text(
                'Войти',
                style: AppTextStyles.h18Regular
                    .copyWith(color: AppColors.blackGreyText, fontSize: 14.sp),
              ),
            ),
          ),
          HBox(12.h),
          Text(
            'При входе вы соглашаетесь с нашими Условиями использования',
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _confirm = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HBox(12.h),
          Text(
            'Телефон',
            style: AppTextStyles.bodySecondary,
          ),
          HBox(12.h),
          const TextField(
            autocorrect: true,
            decoration: InputDecoration(
              hintText: '+7 (747)-009-18-12',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          HBox(12.h),
          Text(
            'Пароль',
            style: AppTextStyles.bodySecondary,
          ),
          HBox(12.h),
          const TextField(
            autocorrect: true,
            decoration: InputDecoration(
              hintText: '',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          HBox(12.h),
          Text(
            'Пароль должен содержать минимум 6 символов. Чтобы пароль получился супернадежным, добавьте заглавные и строчные буквы, цифры и специальные символы.',
            style: AppTextStyles.bodySecondary,
          ),
          HBox(12.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _confirm = !_confirm;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  side: MaterialStateBorderSide.resolveWith(
                    (states) =>
                        const BorderSide(width: 2.0, color: AppColors.white),
                  ),
                  checkColor: AppColors.primary,
                  activeColor: AppColors.white,
                  onChanged: (value) {
                    setState(() {
                      _confirm = !_confirm;
                    });
                  },
                  value: _confirm,
                ),
                Flexible(
                  child: Text(
                      "Я соглашаюсь с Условиями использования сервиса, а также с передачей и обработкой моих данных в REMONT.KZ.",
                      style: AppTextStyles.bodySecondary),
                ),
              ],
            ),
          ),
          HBox(16.h),
          GestureDetector(
            onTap: () async => await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNav, (route) => true),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  color: AppColors.white),
              child: Text(
                'Зарегистрироваться',
                style: AppTextStyles.h18Regular
                    .copyWith(color: AppColors.blackGreyText, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
