// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/domain/services/file_services.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/chat/chat_list_model.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/task/create_task_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/text_field_widget.dart';

class CreateRateWorker extends StatefulWidget {
  ChatList? list;
  String username;
  String chatId;

  CreateRateWorker({Key? key, required this.username, required this.list, required this.chatId})
      : super(key: key);

  @override
  State<CreateRateWorker> createState() => _CreateRateWorkerState();
}

class _CreateRateWorkerState extends State<CreateRateWorker> {
  List<FileDescriptor> files = [];
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  List<TypeEmoji> typeCarBodyList = [
    TypeEmoji(image: "assets/icons/emoji_best.png", name: 'Отлично', rate: 5),
    TypeEmoji(image: "assets/icons/emoji_good.png", name: 'Хорошо', rate: 4),
    TypeEmoji(image: "assets/icons/emoji_angry.png", name: 'Плохо', rate: 3),
  ];
  var carBodyType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Оставьте отзыв',
          style: AppTextStyles.h18Regular.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.cancel,
            color: AppColors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder(
            future:
                RestServices().getProfileByUsername(userName: widget.username),
            builder: (_, AsyncSnapshot snapshots) {
              if (snapshots.hasData) {
                GetProfile profile = snapshots.data;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Оставьте отзыв о работе исполнителя "${profile.name}"',
                          style: AppTextStyles.h18Regular
                              .copyWith(color: AppColors.blackGreyText),
                        ),
                        HBox(24.h),
                        Text(
                          'На сколько вы удовлетворены выполненной работой?',
                          style: AppTextStyles.body14W500,
                        ),
                        HBox(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: typeCarBodyList.map((e) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  carBodyType = e;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8.w),
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: carBodyType == e
                                      ? AppColors.primary
                                      : AppColors.graySearch,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height: 123.h,
                                width: MediaQuery.of(context).size.width / 3.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      e.image,
                                      height: 47.h,
                                      width: 47.w,
                                    ),
                                    HBox(
                                      4.h,
                                    ),
                                    Text(
                                      e.name,
                                      style: AppTextStyles.body14W500.copyWith(
                                          color: carBodyType == e
                                              ? AppColors.white
                                              : AppColors.blackGreyText),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        HBox(12.h),
                        FieldBones(
                          placeholder:
                              'Оставьте комментарий по работе данного специалиста',
                          maxLines: 6,
                          maxLength: 1000,
                          isTextField: true,
                          controller: controller,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return ("Заголовок не должен быть пустым");
                            }
                            if (value.length < 15) {
                              return "Заголовок должен содержать минимум 15 символов";
                            }

                            return null;
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.w),
                          child: Text(
                            'Добавьте фотографии результата работ',
                            style: AppTextStyles.body14W500,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Row(
                                children: files.map((e) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 84.w,
                                        height: 84.h,
                                        margin: EdgeInsets.all(8.w),
                                        padding: EdgeInsets.all(22.w),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 8,
                                              offset: Offset(0,
                                                  3.w), // changes position of shadow
                                            ),
                                          ],
                                          image: DecorationImage(
                                              image: NetworkImage(e.url),
                                              fit: BoxFit.fill),
                                          color:
                                              AppColors.primary.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.primary),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            files.removeWhere((element) => element.url == e.url);
                                            setState(() {

                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                              files.length < 3
                                  ? GestureDetector(
                                      onTap: () => filePickerDialog(),
                                      child: Container(
                                        width: 84.w,
                                        height: 84.h,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8.w),
                                        padding: EdgeInsets.all(22.w),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 8,
                                              offset: Offset(0,
                                                  3.w), // changes position of shadow
                                            ),
                                          ],
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.primary),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        HBox(50.h),
                      ],
                    ),
                  ),
                );
              } else {
                return Text('fd');
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FutureBuilder(
          future: RestServices().getPublicationById(widget.list?.typeId ?? 0),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              PublicationModel models = snapshot.data;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        var api = await RestServices().createNewComment(
                          TaskComment(
                            rating: carBodyType.rate,
                            feedback: controller.text,
                            files: files,
                            executorUsername: models.user.username,
                            categoryId: models.categoryId,
                              chatRoomId: int.parse(widget.chatId)
                          ),
                        );
                        if (api == 200) {
                          Navigator.pop(context);
                          MotionToast.success(
                            description: const Text(
                              'Ваш отзыв был принят, спасибо за оценку',
                              style: TextStyle(fontSize: 12),
                            ),
                            position: MotionToastPosition.top,
                            layoutOrientation: ToastOrientation.ltr,
                            animationType: AnimationType.fromTop,
                            dismissable: true,
                          ).show(rootNavigatorKey.currentContext!);
                        }
                      } else {}

                    },
                    child: Container(
                      height: 40.h,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          color: AppColors.additionalGreenMediumButton),
                      child: Text(
                        'Оставить отзыв',
                        style: AppTextStyles.body14Secondary
                            .copyWith(color: AppColors.white, fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
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
                          .uploadImageComment(File(file.path));
                      files.add(upload);
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
                          .uploadImageComment(File(file.path));
                      if (upload != null) {
                        files.add(upload);
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

class TypeEmoji {
  final String name;
  final String image;
  final int rate;

  TypeEmoji({
    required this.name,
    required this.image,
    required this.rate,
  });
}
