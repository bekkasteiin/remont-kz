// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';

import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/file_services.dart';
import 'package:remont_kz/utils/global_widgets/text_field_widget.dart';

class EditWorkerProfile extends StatefulWidget {
  const EditWorkerProfile({Key? key}) : super(key: key);

  @override
  State<EditWorkerProfile> createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
  String? userProfileUrl;
  String? name;
  String? lastName;
  String? address;
  String? newPhotoUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Настройка профиля',
            style: AppTextStyles.h18Regular.copyWith(color: AppColors.white),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FutureBuilder(
              future: RestServices().getMyProfile(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  GetProfile profile = snapshot.data;
                  String currentPhotoUrl = newPhotoUrl ?? userProfileUrl ?? profile.photoUrl ?? '';
                  return Column(
                    children: [
                      HBox(35.h),
                      profile.photoUrl == null
                          ? currentPhotoUrl != ''
                              ? Center(
                                  child: CircleAvatar(
                                      radius: 75.w,
                                      backgroundImage:
                                          NetworkImage(currentPhotoUrl ?? '')),
                                )
                              : Center(
                                  child: CircleAvatar(
                                    radius: 75.w,
                                  ),
                                )
                          : Center(
                              child: CircleAvatar(
                                  radius: 75.w,
                                  backgroundImage:
                                      NetworkImage(currentPhotoUrl)),
                            ),
                      HBox(8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              newPhotoUrl = null;
                              profile.photoUrl = null;
                              userProfileUrl = null;
                              setState(() {

                              });
                              print(currentPhotoUrl);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(12.h)),
                              child: Text(
                                'Удалить',
                                style: AppTextStyles.captionPrimary
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                          WBox(8.w),
                          GestureDetector(
                            onTap: () => filePickerDialog(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12.h)),
                              child: Text(
                                'Изменить',
                                style: AppTextStyles.captionPrimary
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      HBox(24.h),
                      FieldBones(
                        placeholder: "Ваше имя",
                        editable: true,
                        isTextField: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        textValue: profile.name ?? '',
                        onChanged: (val) {
                          profile.name = val;
                          name = val;
                        },
                      ),
                      FieldBones(
                        placeholder: "Ваше фамилия",
                        editable: true,
                        isTextField: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        textValue: profile.lastname ?? '',
                        onChanged: (val) {
                          profile.lastname = val;
                          lastName = val;
                        },
                      ),
                      FieldBones(
                        placeholder: "Ваш номер телефона",
                        editable: true,
                        isTextField: true,
                        textValue: profile.username ?? '',
                      ),
                      FieldBones(
                        placeholder: "Ваш адрес",
                        editable: true,
                        isTextField: true,
                        textValue: profile.address ?? '',
                        onChanged: (val) {
                          profile.address = val;
                          address = val;
                        },
                      ),
                      HBox(24.h),
                      GestureDetector(
                        onTap: () async {
                          print(profile.photoUrl);
                          if (userProfileUrl != null) {
                            profile.photoUrl = userProfileUrl;
                          }
                          if (address != null) {
                            profile.address = address;
                          }
                          if (name != null) {
                            profile.name = name;
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                          var response =
                              await RestServices().editProfile(profile);
                          if (response == 200) {
                            Navigator.pop(context);
                            MotionToast.success(
                              description: const Text(
                                'Ваш профиль успешно изменен',
                                style: TextStyle(fontSize: 12),
                              ),
                              position: MotionToastPosition.top,
                              layoutOrientation: ToastOrientation.ltr,
                              animationType: AnimationType.fromTop,
                              dismissable: true,
                            ).show(context);
                          } else {
                            Navigator.pop(context);
                            MotionToast.error(
                              description: const Text(
                                'Возникли ошибки, попробуйте позже:)',
                                style: TextStyle(fontSize: 12),
                              ),
                              position: MotionToastPosition.top,
                              layoutOrientation: ToastOrientation.ltr,
                              animationType: AnimationType.fromTop,
                              dismissable: true,
                            ).show(context);
                          }
                        },
                        child: Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8.w)),
                          child: Center(
                            child: Text(
                              'Применить',
                              style: AppTextStyles.bodySecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  filePickerDialog() {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final file = await FileService.getImageCamera(context);
                    if (file != null) {
                      FileDescriptor upload = await RestServices()
                          .uploadImageProfile(File(file.path));
                      print(upload.toJson());
                      newPhotoUrl = upload.url;
                      userProfileUrl = upload.url;
                      // files.add(upload);
                      setState(() {});
                    }
                  },
                  child: const Text('Камера')),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final file = await FileService.getImage(context);
                    if (file != null) {
                      FileDescriptor upload = await RestServices()
                          .uploadImageProfile(File(file.path));
                      if (upload != null) {
                        print(upload.toJson());
                        newPhotoUrl = upload.url;
                        userProfileUrl = upload.url;
                        // files.add(upload);
                        setState(() {});
                      }
                    }
                  },
                  child: const Text('Галерея')),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                'Отмена',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}
