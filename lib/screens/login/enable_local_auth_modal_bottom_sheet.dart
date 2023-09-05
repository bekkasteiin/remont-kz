import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/global_widgets/shared_pr_widget.dart';
import 'package:remont_kz/utils/routes.dart';

class EnableLocalAuthModalBottomSheet extends StatelessWidget {
  final void Function() action;
  final dynamic email;
  final dynamic password;
  bool faceId;

  EnableLocalAuthModalBottomSheet(
      {Key? key,
      required this.action,
      this.email,
      this.password,
      required this.faceId})
      : super(key: key);

  static const Color primaryColor = Color(0xFF13B5A2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          faceId == true
              ? Image.asset(
                  'assets/images/face-id.png',
                  width: 100,
                  height: 100,
                )
              : const Icon(
                  Icons.fingerprint_outlined,
                  size: 100,
                  color: primaryColor,
                ),
          const SizedBox(
            height: 10,
          ),
          Text(
            faceId == true
                ? 'Вы хотите включить вход по FaceID?'
                : 'Вы хотите включить вход по отпечатку пальца?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
              'При следующем входе в систему вам не будет предложено ввести учетные данные для входа.',
              textAlign: TextAlign.center),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width/1.3,
            child: CupertinoButton(
              color: primaryColor,
              child: Text(
                "Да",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () async{
                try {
                  action();
                  // Navigator.pop(context);
                  var api =
                      await RestServices().auth(login: email, password: password);

                  if (api == 200) {
                    GetProfile serviceProfile = await RestServices().getMyProfile();
                    SharedPreferencesHelper.setSeen(true);
                    if (serviceProfile.isClient == false) {
                      Navigator.pop(context);
                      await Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.mainNavWorker, (route) => false);
                    } else {
                      Navigator.pop(context);
                      await Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.mainNav, (route) => false);
                    }

                  } else {}
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width/1.3,
            child: CupertinoButton(
              color: Colors.grey[200],
              child: Text(
                "Спасибо, не надо!",
                style: TextStyle(fontSize: 18,  color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              onPressed: ()async {
                try {
                  var api =
                      await RestServices().auth(login: email, password: password);

                  if (api == 200) {
                    GetProfile serviceProfile = await RestServices().getMyProfile();
                    SharedPreferencesHelper.setSeen(true);
                    if (serviceProfile.isClient == false) {
                      Navigator.pop(context);
                      await Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.mainNavWorker, (route) => false);
                    } else {
                      Navigator.pop(context);
                      await Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.mainNav, (route) => false);
                    }

                  } else {}
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}
