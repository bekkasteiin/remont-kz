import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/utils/app_colors.dart';

extension AppTextStylesExtension on BuildContext {
  TextStyle get h1 => AppTextStyles.h1;

  TextStyle get h2 => AppTextStyles.h2;

  TextStyle get h2Bold => AppTextStyles.h2Bold;

  TextStyle get h3 => AppTextStyles.h3;

  TextStyle get h3Regular => AppTextStyles.h3Regular;

  TextStyle get h3Bold => AppTextStyles.h3Bold;

  TextStyle get bodyPrimary => AppTextStyles.bodyPrimary;

  TextStyle get bodyPrimarySemibold => AppTextStyles.bodyPrimarySemibold;

  TextStyle get bodySecondary => AppTextStyles.bodySecondary;

  TextStyle get subtitleSemibold => AppTextStyles.subtitleSemibold;

  TextStyle get button => AppTextStyles.button;

  TextStyle get captionPrimary => AppTextStyles.captionPrimary;

  TextStyle get captionAdditional => AppTextStyles.captionAdditional;

  TextStyle get captionBold => AppTextStyles.captionBold;

  TextStyle get error => AppTextStyles.error;

  TextStyle get errorSmall => AppTextStyles.errorSmall;

  InputDecoration defInputDecoration(String? hint) => AppTextStyles.fieldDec(hint);
}

class AppTextStyles {

  static fieldDec(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyPrimary.copyWith(color: AppColors.textGray),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grayBorder),
        borderRadius: BorderRadius.circular(16.sp),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(16.sp),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grayBorder),
        borderRadius: BorderRadius.circular(16.sp),
      ),
      errorStyle: const TextStyle(
        color: AppColors.textActiveMistake,
      ),
    );
  }

  /// почти қолданбаймыз
  static final h1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.3.w,
    // color: AppColors.textMain,
    //fontFamily: FontFamily.openSans,
  );

  /// редко қолданамыз
  static final h2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 27 / 20,
    color: AppColors.textMain,
    // letterSpacing: -0.5.w,
    //fontFamily: FontFamily.openSans,
  );

  /// үлкен тайтлдар
  static final h2Bold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    height: 27 / 20,
    color: AppColors.textMain,
    letterSpacing: -0.5.w,
    //fontFamily: FontFamily.openSans,
  );

  /// орташа тайтлдар
  static final h3 = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    height: 22 / 17,
    color: AppColors.textMain,
    letterSpacing: -0.3.w,
    //fontFamily: FontFamily.openSans,
  );


  static final h3Regular = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    height: 22 / 17,
    color: AppColors.textMain,
    letterSpacing: -0.3.w,
    //fontFamily: FontFamily.openSans,
  );

  static final h18Regular = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 24 / 18,
    color: AppColors.white,
    letterSpacing: 0.01.w,
    //fontFamily: FontFamily.openSans,
  );

  static final h3Bold = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    height: 22 / 17,
    color: AppColors.textMain,
    letterSpacing: 0,
    //fontFamily: FontFamily.openSans,
  );

  /// для кнопка
  static final button = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
    color: AppColors.textMain,
    //fontFamily: FontFamily.openSans,
  );

  /// үлкен тексттерге
  static final bodyPrimary = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textMain,
    //fontFamily: FontFamily.openSans,
  );

  static final bodyPrimarySemibold = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.textMain,
    //fontFamily: FontFamily.openSans,
  );

  /// орташа тексттерге
  static final bodySecondary = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    height: 1.23,
    color: AppColors.white,
    //fontFamily: FontFamily.openSans,
  );


  static final bodySecondaryTen = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1.23,
    color: AppColors.primaryGray,
    //fontFamily: FontFamily.openSans,
  );

  static final body14Secondary = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height:  16 / 13,
    color: AppColors.blackGreyText,
    //fontFamily: FontFamily.openSans,
  );

  static final body14W500 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height:  16 / 13,
    color: AppColors.blackGreyText,
    //fontFamily: FontFamily.openSans,
  );

  static final subtitleSemibold = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    height: 16 / 13,
    color: AppColors.textMain,
    //fontFamily: FontFamily.openSans,
  );


  /// мелткий текст
  static final captionPrimary = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textGray,
    //fontFamily: FontFamily.openSans,
  );

  static final captionAdditional = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    color: AppColors.white,
    //fontFamily: FontFamily.openSans,
  );

  static final captionBold = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    height: 20 / 12,
    color: AppColors.white,
    //fontFamily: FontFamily.openSans,
  );


  static final error = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    height: 20 / 15,
    color: AppColors.textActiveMistake,
    //fontFamily: FontFamily.openSans,
  );

  static final errorSmall = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    height: 16 / 13,
    color: AppColors.textActiveMistake,
    //fontFamily: FontFamily.openSans,
  );
}
