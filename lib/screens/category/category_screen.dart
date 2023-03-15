import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:remont_kz/utils/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              child: Lottie.asset('assets/json/developer.json'),
            ),
            Text(
              'Бұл бөлім жасалып жатыр:)',
              style: TextStyle(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
