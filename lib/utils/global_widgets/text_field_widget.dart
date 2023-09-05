import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';

class FieldBones extends StatelessWidget {
  final String placeholder;
  final String? textValue;
  final bool? isTextField;
  final bool? isRequired;
  dynamic _selector;
  final bool needMaxLines;
  final bool iconAlignEnd;
  final bool isMinWidthTiles;
  final IconData? icon;
  final Color? iconColor;
  final Widget? suffixIcon;
  dynamic focusNode;
  dynamic textInputAction;
  final int? maxLinesSubTitle;
  dynamic _iconTap;
  final onChanged;
  final onSaved;
  final onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final onEditingComplete;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final double? height;
  final bool showCounterText;
  final validate;
  final bool dateField;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? leading;
  final TextEditingController? textController;
  final bool editable;

  FieldBones({
    dynamic selector,
    dynamic iconTap,
    required this.placeholder,
    this.isTextField = false,
    this.textValue,
    this.inputFormatters,
    this.icon,
    this.iconColor,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.needMaxLines = false,
    this.textController,
    this.isRequired = false,
    this.showCounterText = false,
    this.maxLinesSubTitle,
    this.keyboardType,
    this.validate,
    this.hintText,
    this.maxLines,
    this.leading,
    this.textInputAction,
    this.maxLength,
    this.dateField = false,
    this.height,
    this.iconAlignEnd = false,
    this.isMinWidthTiles = false,
    this.editable = true,
    this.suffixIcon,
  }) {
    _selector = editable ? selector : null;
    _iconTap = editable ? iconTap : null;
  }

  @override
  Widget build(BuildContext context) {
    Widget secondChild;
    final bool needToShowDialog = needMaxLines && !isTextField! && icon == null;
    if (needToShowDialog) {
      secondChild = buildIconButton(context, needToShowDialog);
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Container(
            padding: const EdgeInsets.only(bottom: 7.0),
            child: Text.rich(
                TextSpan(
                  text: placeholder ?? '',
                  style: AppTextStyles.body14Secondary.copyWith(color: AppColors.blackGreyText),
                )
            ),
          ),
          //field
          InkWell(
            onTap: _selector == null ? null : _selector as Function(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 10.0.w),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset:
                    Offset(0, 3.w), // changes position of shadow
                  ),
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.h),
                // color: isTextField ? appWhiteColor : appGrayColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Center(child: leading),
                    ),
                  Expanded(
                    // width:
                    // !isMinWidthTiles ? MediaQuery.of(context).size.width-110 : 130,
                    child: !isTextField! ? buildTile() : buildTextFormField(context),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile() {
    final Widget text2 = Row(
      children: [
        Flexible(
          child: Text(
            textValue ?? (hintText ?? (dateField
                ? '__ ___, _____'
                : '')),
            style: AppTextStyles.body14Secondary.copyWith(fontSize: 15.w, color: textValue == null ? AppColors.darkGray : AppColors.black),

          ),
        ),
      suffixIcon ?? SizedBox()
      ],
    );
    return SizedBox(
      height: height,
      child: text2,
    );
  }

  TextFormField buildTextFormField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.zero,
        fillColor: isTextField! ? CupertinoColors.systemBackground : Theme.of(context).scaffoldBackgroundColor,
        hintText: hintText ?? '',
        isDense: true,
        // counterText: !showCounterText ? "" : null,
        border: InputBorder.none,),
      keyboardType: keyboardType ?? TextInputType.multiline,
      onChanged: onChanged,
      enableSuggestions: false,
      autocorrect: false,
      onSaved: onSaved,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      maxLines: maxLines,
    textInputAction: TextInputAction.newline,
      validator: validate,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.always,
      initialValue: textValue,
      style: TextStyle(fontSize: 15.w),
      controller: textValue != null && controller == null && !isTextField! ? null : controller,
      enabled: editable,
      maxLength: maxLength,
      readOnly: false,
    );
  }

  InkWell buildIconButton(BuildContext context, bool needToShowDialog) {
    return InkWell(
      onTap: _iconTap == null ? null : _iconTap as Function(),
      child: Container(
        decoration: _iconTap == null
            ? BoxDecoration(
          color: !editable ? null : CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(10.w),
        )
            : null,
        child: Icon(
          needToShowDialog ? Icons.message : icon ?? Icons.arrow_forward_ios,
          color: iconColor,
          size: 20.w,
        ),
      ),
    );
  }
}