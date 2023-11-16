import 'package:flutter/material.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';

class UseFullTipsScreen extends StatelessWidget {
  const UseFullTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: ()=>Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: AppColors.white,),
          ),
          centerTitle: true,
          title: Text(
            'Полезные советы',
            style: AppTextStyles.h18Regular,
          ),
        ),
        body: const Center(
          child: Text(
            'Данная страница находится в разработке. Ожидайте!',
            textAlign: TextAlign.center,
          ),
        ));
  }
}
