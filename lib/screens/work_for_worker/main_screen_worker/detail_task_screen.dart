// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/task/main_screen/profile_worker_info.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/full_screen_image.dart';
import 'package:share_plus/share_plus.dart';

class DetailTaskScreen extends StatefulWidget {
  int id;
  bool myTask = false;
  DetailTaskScreen({Key? key, required this.id, this.myTask = false})
      : super(key: key);

  @override
  State<DetailTaskScreen> createState() => _DetailTaskScreenState();
}

class _DetailTaskScreenState extends State<DetailTaskScreen> {
  int itemIndexPage = 0;
  late TaskModel model;
  List<PublicationModel> loadPublicationChat = [];
  GetProfile profile = GetProfile();

  @override
  void initState() {
    stompClient.activate();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        profile = await RestServices().getMyProfile();
        if (profile != null) {
          final loadChat = await RestServices()
              .getMyPublication(userName: profile.username ?? '');
          if (mounted) {
            setState(() {
              loadPublicationChat = loadChat;
            });
          }
          setState(() {});
        }
      } catch (e) {
        print("Error fetching publication: $e");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder(
        future: RestServices().getTaskById(widget.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            model = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (model.files.isNotEmpty)
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImage(
                                        files: model.files,
                                      ),
                                    ),
                                  );
                                },
                                child: CarouselSlider.builder(
                                  itemCount: model.files.length,
                                  itemBuilder: (BuildContext context,
                                      int itemIndex, int pageViewIndex) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 360.h,
                                      child: Image.network(
                                        model.files[itemIndex].url,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                      height: 360.h,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          itemIndexPage = index;
                                        });
                                      },
                                      enlargeCenterPage: true,
                                      enlargeStrategy:
                                          CenterPageEnlargeStrategy.height,
                                      autoPlay: false,
                                      enableInfiniteScroll: false,
                                      initialPage: 0,
                                      scrollDirection: Axis.horizontal,
                                      viewportFraction: 1),
                                ),
                              ),
                              Positioned(
                                top: 45.h,
                                left: 15.w,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    height: 35.h,
                                    width: 35.w,
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: AppColors.grayDark,
                                          blurRadius: 2.0,
                                          offset: Offset(0.0, 0.75),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.h, horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: AppColors.black.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    "${itemIndexPage + 1}/${model.files.length.toString()}",
                                    style: AppTextStyles.captionPrimary
                                        .copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Stack(
                            children: [
                              Container(
                                height: 360.h,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors.graySearch,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.no_photography_outlined),
                                    Text('Нет фото')
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 45.h,
                                left: 15.w,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    height: 35.h,
                                    width: 35.w,
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: AppColors.grayDark,
                                          blurRadius: 2.0,
                                          offset: Offset(0.0, 0.75),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 250.w,
                                    child: Text(
                                      model.title,
                                      style: AppTextStyles.h18Regular.copyWith(
                                          color: AppColors.blackGreyText),
                                    ),
                                  ),
                                  widget.myTask
                                      ? const SizedBox()
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Share.share(
                                                  model.description,
                                                  subject: model.category),
                                              child: const Icon(
                                                Icons.ios_share_rounded,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 24.w,
                                            ),
                                            GestureDetector(
                                              onTap:
                                                  tokenStore.accessToken != null
                                                      ? () async {
                                                          if (model.favourite) {
                                                            await RestServices()
                                                                .deleteFavouriteTask(
                                                                    model.id
                                                                        .toString());
                                                          } else {
                                                            await RestServices()
                                                                .addFavouriteTask(
                                                                    model.id
                                                                        .toString());
                                                          }
                                                          setState(() {});
                                                        }
                                                      : null,
                                              child: Icon(
                                                model.favourite
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: model.favourite
                                                    ? AppColors.primaryYellow
                                                    : AppColors.primary,
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Категория',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(color: AppColors.primaryGray),
                                  ),
                                  Text(model.category,
                                      style: AppTextStyles.body14W500),
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Регион',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(color: AppColors.primaryGray),
                                  ),
                                  Text(model.city,
                                      style: AppTextStyles.body14W500),
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Стоимость работ',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(color: AppColors.primaryGray),
                                  ),
                                  model.isContractual
                                      ? Text('договорная',
                                          style: AppTextStyles.body14Secondary)
                                      : Text(
                                          'до ' +
                                              model.price.toInt().toString() +
                                              ' ₸',
                                          style: AppTextStyles.body14W500),
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Время работ',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(color: AppColors.primaryGray),
                                  ),
                                  Text(model.workTime,
                                      style: AppTextStyles.body14W500),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.2.h,
                          color: AppColors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Описание',
                                style: AppTextStyles.h18Regular.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                model.description,
                                style: AppTextStyles.body14Secondary,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              widget.myTask
                                  ? SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Заказчик',
                                          style: AppTextStyles.h18Regular
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      AppColors.blackGreyText),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        FutureBuilder(
                                            future: RestServices()
                                                .getProfileByUsername(
                                                    userName:
                                                        model.user.username),
                                            builder:
                                                (_, AsyncSnapshot snapshots) {
                                              if (snapshots.hasData) {
                                                GetProfile profile =
                                                    snapshots.data;
                                                return GestureDetector(
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePersonInfo(
                                                        username:
                                                            profile.username ??
                                                                '',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      profile.photoUrl == null
                                                          ? CircleAvatar(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primary,
                                                              radius: 39.w,
                                                              child: Icon(
                                                                Icons.person,
                                                                color: AppColors
                                                                    .white,
                                                                size: 30.w,
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primary,
                                                              radius: 39.w,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      profile
                                                                          .photoUrl),
                                                            ),
                                                      SizedBox(
                                                        width: 12.w,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            model.user.fullName,
                                                            style: AppTextStyles
                                                                .h18Regular
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        16.h,
                                                                    color: AppColors
                                                                        .blackGreyText),
                                                          ),
                                                          HBox(6.h),
                                                          Text(
                                                            'На REMONT.KZ c ${formatMonthNamedDate(profile.createdDate!)}',
                                                            style: AppTextStyles
                                                                .body14Secondary
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .primaryGray),
                                                          ),
                                                          HBox(6.h),
                                                          FutureBuilder(
                                                              future: RestServices()
                                                                  .getProfileSession(
                                                                      userName:
                                                                          profile.username ??
                                                                              ''),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot
                                                                      snapshotDate) {
                                                                if (snapshotDate
                                                                    .hasData) {
                                                                  return Text(
                                                                    'Онлайн в ${snapshotDate.data}',
                                                                    style: AppTextStyles
                                                                        .body14Secondary
                                                                        .copyWith(
                                                                            color:
                                                                                AppColors.primaryGray),
                                                                  );
                                                                } else {
                                                                  return SizedBox();
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            }),
                                      ],
                                    ),
                              HBox(50.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.myTask)
                  const SizedBox()
                else
                  FutureBuilder(
                      future: RestServices().isHaveResponse(
                          clientUsername: model.user.username,
                          executorUsername: profile.username ?? '',
                          type: 'TASK',
                          typeId: model.id),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (model.user.username == profile.username) {
                            return SizedBox();
                          } else {
                            if (loadPublicationChat.length < 1) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 24.h, left: 16.w, right: 16.w),
                                child: GestureDetector(
                                  onTap: () {
                                    MotionToast.info(
                                      description: const Text(
                                        'Вы не можете откликнутся к этой задаче, так как у вас нету публикации',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      position: MotionToastPosition.top,
                                      layoutOrientation: ToastOrientation.ltr,
                                      animationType: AnimationType.fromTop,
                                      dismissable: true,
                                    ).show(context);
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(12.w),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        color: AppColors.textGray),
                                    child: Text(
                                      'Откликнуться',
                                      style: AppTextStyles.body14Secondary
                                          .copyWith(
                                              color: AppColors.white,
                                              fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 12.h, left: 16.w, right: 16.w),
                                child: GestureDetector(
                                  onTap: model.openRequest
                                      ? !snapshot.data
                                          ? () async {
                                              var send = await RestServices()
                                                  .isHaveWithSame(
                                                      categoryId:
                                                          model.categoryId);
                                              if (send) {
                                                var body = '''{
                                      "executorUsername": "${profile.username}",
                                      "clientUsername": "${model.user.username}",
                                      "senderUsername": "${profile.username}",
                                      "recipientUsername": "${model.user.username}",
                                      "typeId": ${model.id},
                                      "type": "TASK",
                                      "content": "TASK_REQUEST_FROM_EXECUTOR",
                                      "categoryId": ${model.categoryId},
                                      "isSystemContent": ${true}
                                  }''';
                                                stompClient.send(
                                                    destination: '/app/chat',
                                                    body: body);
                                                MotionToast toast =
                                                    MotionToast.success(
                                                  description: const Text(
                                                    'Вы успешно откликнулись, пожалуйста ожидайте ответа от заказчика',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  position:
                                                      MotionToastPosition.top,
                                                  layoutOrientation:
                                                      ToastOrientation.ltr,
                                                  animationType:
                                                      AnimationType.fromTop,
                                                  dismissable: true,
                                                );
                                                toast.show(context);
                                                Future.delayed(const Duration(
                                                        seconds: 2))
                                                    .then((value) {
                                                  toast.dismiss();
                                                });
                                              } else {
                                                MotionToast.info(
                                                  description: const Text(
                                                    'Вы не можете откликнуться, потому что у вас нет объявления в данной категории',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  position:
                                                      MotionToastPosition.top,
                                                  layoutOrientation:
                                                      ToastOrientation.ltr,
                                                  animationType:
                                                      AnimationType.fromTop,
                                                  dismissable: true,
                                                ).show(context);
                                              }
                                            }
                                          : () {
                                              MotionToast.info(
                                                description: const Text(
                                                  'Вы уже откликнулись к этой задаче',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                position:
                                                    MotionToastPosition.top,
                                                layoutOrientation:
                                                    ToastOrientation.ltr,
                                                animationType:
                                                    AnimationType.fromTop,
                                                dismissable: true,
                                              ).show(context);
                                            }
                                      : (){
                                    MotionToast.info(
                                      description: const Text(
                                        'Заказчик не может принять отклики',
                                        style:
                                        TextStyle(fontSize: 12),
                                      ),
                                      position:
                                      MotionToastPosition.top,
                                      layoutOrientation:
                                      ToastOrientation.ltr,
                                      animationType:
                                      AnimationType.fromTop,
                                      dismissable: true,
                                    ).show(context);
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(12.w),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        color: snapshot.data
                                            ? AppColors.textGray
                                            : AppColors.primary),
                                    child: Text(
                                      'Откликнуться',
                                      style: AppTextStyles.body14Secondary
                                          .copyWith(
                                              color: AppColors.white,
                                              fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
