import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/screens/login/pin_code_admin.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';


class ChangePasswordScreen extends StatefulWidget {
  bool isWorkers;
  ChangePasswordScreen({Key? key, required this.isWorkers}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String mobilePhone = '';
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '+7(###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
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
              'Введите номер телефона',
              style: AppTextStyles.h18Regular.copyWith(color: AppColors.blackGreyText, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            HBox(12.h),
            SizedBox(
              height: 40,
              child: TextField(
                autocorrect: true,
                keyboardType: TextInputType.number,
                onChanged: (String val) {
                  setState(() {
                    mobilePhone = val;
                  });
                },
                inputFormatters: [maskFormatter],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: '+7 (777) 777-77-77',
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
            ),
            const Expanded(child: SizedBox()),
            GestureDetector(
              onTap: ()async{
                var send = await RestServices().sendSmsForResetPassword(userName: mobilePhone.replaceAll(RegExp(r'\D'), ''));
                if(send == 200){
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PinCodePage(
                              mobilePhone.replaceAll(RegExp(r'\D'), ''), '', widget.isWorkers, true),),);
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
    );
  }
}
