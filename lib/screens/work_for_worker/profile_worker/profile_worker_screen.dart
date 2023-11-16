// ignore_for_file: use_build_context_synchronously

import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/model/publication/publication_review.dart';
import 'package:remont_kz/screens/task/main_screen/show_all_rate_screen.dart';
import 'package:remont_kz/utils/date.dart';
import 'package:remont_kz/utils/global_widgets/full_screen_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/create/create_screen.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/screens/work_for_worker/profile_worker/edit_worker_profile.dart';
import 'package:remont_kz/screens/work_for_worker/profile_worker/publication_edit_page.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/shared_pr_widget.dart';
import 'package:remont_kz/utils/global_widgets/text_field_widget.dart';
import 'package:remont_kz/utils/routes.dart';

class ProfileWorkerScreen extends StatefulWidget {
  const ProfileWorkerScreen({Key? key}) : super(key: key);

  @override
  State<ProfileWorkerScreen> createState() => _ProfileWorkerScreenState();
}

class _ProfileWorkerScreenState extends State<ProfileWorkerScreen> {
  bool editText = false;
  String? aboutMeText;
  bool openText = false;
  late Future future;
  late String formattedNumber;
  final FocusNode _focusNode = FocusNode();
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Мой профиль',
            style: AppTextStyles.h18Regular.copyWith(color: AppColors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditWorkerProfile(),
                  ),
                ).then((value) => setState(() {}));
              },
              icon: const Icon(
                Icons.settings,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: RestServices().getMyProfile(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                GetProfile profile = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HBox(24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: profileContainer(profile),
                    ),
                    HBox(12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: aboutMe(profile, context),
                    ),
                    HBox(12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        'Мои объявления',
                        style: AppTextStyles.body14Secondary
                            .copyWith(color: AppColors.blackGreyText),
                      ),
                    ),
                    HBox(6.h),
                   myPublication(profile),
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
    );
  }

  Widget profileContainer(GetProfile profile) {
    return Row(
      children: [
        profile.photoUrl != null
            ? Container(
                height: 116.h,
                width: 100.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(profile.photoUrl),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary),
              )
            : Container(
                height: 116.h,
                width: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Icon(Icons.account_circle_outlined, color: AppColors.white, size: 40.h,),
                ),
              ),
        WBox(9.w),
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.account_circle_outlined,
                    color: AppColors.primary,
                  ),
                  WBox(7.w,),
                  Text('Имя', style:AppTextStyles.body14W500 ,),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(profile.name ?? '',
                      style:AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),),
                    ),
                  ),
                ],
              ),
            ),
            HBox(12.h),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                  ),
                  WBox(7.w,),
                  Text('Адрес', style:AppTextStyles.body14W500),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(profile.address ?? '',
                      style:  AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),),
                    ),
                  ),
                ],
              ),
            ),
            HBox(12.h),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.phone_callback_outlined,
                    color: AppColors.primary,
                  ),
                  WBox(7.w,),
                  Text('Номер',style:AppTextStyles.body14W500),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(formatPhone(profile.username ?? '',),
                        style:  AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),),
                    ),
                  ),
                ],
              ),
            ),
            HBox(20.h),
          ],
        ),
      ],
    );
  }

  String formatPhone(String input) {
    if (input.length >= 10) {
      final countryCode = '+${input.substring(0, 1)}';
      final areaCode = input.substring(1, 4);
      final firstPart = input.substring(4, 7);
      final secondPart = input.substring(7, 9);
      final thirdPart = input.substring(9);
      formattedNumber =
          '$countryCode ($areaCode) $firstPart-$secondPart-$thirdPart';

      return formattedNumber;
    } else {
      setState(() {
        formattedNumber = '';
      });
      return formattedNumber;
    }
  }

  void openKeyboard() {
    _focusNode.requestFocus();
  }

  Widget aboutMe(GetProfile profile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'О себе',
          style: AppTextStyles.h18Regular.copyWith(color: AppColors.black),
        ),
        HBox(12.h),
        Container(
            padding: EdgeInsets.all(12.h),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 1.w), // changes position of shadow
                ),
              ],
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.h),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.4,
                  child: Text(
                    profile.aboutMe ?? '',
                    style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Image.asset(
                          'assets/icons/edit.png',
                          height: 16.h,
                          width: 16.w,
                        ),
                      ),
                    ),
                    onTap: () {
                      openKeyboard();
                      showModalBottomSheet(
                          enableDrag: false,
                          isScrollControlled: true,
                          isDismissible: false,
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.w),
                                topRight: Radius.circular(16.w)),
                          ),
                          context: context,
                          builder: (_) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return FractionallySizedBox(
                                heightFactor: 0.95,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16.h, horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                1.w), // changes position of shadow
                                          ),
                                        ],
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8.h),
                                          bottomRight: Radius.circular(8.h),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Отменить',
                                              style: AppTextStyles
                                                  .body14Secondary
                                                  .copyWith(
                                                      color: AppColors.primary,
                                                      fontSize: 14.sp),
                                            ),
                                          ),
                                          Text(
                                            'О себе',
                                            style: AppTextStyles.body14Secondary
                                                .copyWith(
                                                    color:
                                                        AppColors.blackGreyText,
                                                    fontSize: 14.sp),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              setState(() {
                                                editText = !editText;
                                              });
                                              if(aboutMeText!=null){
                                                profile.aboutMe = aboutMeText.toString().replaceAll(RegExp(r'\s+'), ' ');
                                              }else{
                                                profile.aboutMe.toString().replaceAll(RegExp(r'\s+'), ' ');
                                              }


                                              var response =
                                                  await RestServices().editProfile(profile);
                                              if (response == 200) {
                                                Navigator.pop(context);
                                                MotionToast.success(
                                                  description: const Text(
                                                    'Ваш профиль успешно изменен',
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
                                                setState((){});
                                              } else {
                                                Navigator.pop(context);
                                                MotionToast.error(
                                                  description: const Text(
                                                    'Возникли ошибки, попробуйте позже:)',
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
                                            },
                                            child: Text(
                                              'Сохранить',
                                              style: AppTextStyles
                                                  .body14Secondary
                                                  .copyWith(
                                                      color: AppColors.primary,
                                                      fontSize: 14.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: FieldBones(
                                        placeholder: "",
                                        textValue: profile.aboutMe ?? '',
                                        maxLines: 10,
                                        maxLength: 300,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(300),
                                        ],
                                        focusNode: _focusNode,
                                        editable: true,
                                        isTextField: true,
                                        onChanged: (val) {
                                          profile.aboutMe = val;
                                          aboutMeText = val;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          }).then((value) =>  setState((){}));
                    },
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget myPublication(GetProfile profile) {
    return FutureBuilder(
      future: RestServices().getMyActivatePublication(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<PublicationModel> model = snapshot.data;
          return Column(
            children: [
            ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.length,
                      itemBuilder: (context, index) {
                        PublicationModel items = model[index];
                        return buildPublicationCard(items);
                      },
                    ),

              HBox(6.h),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w),
                child: GestureDetector(
                  onTap: model.length >= 2
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CreateOrderScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 34.h,
                    width:
                    MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                          color: model.length >= 2
                              ? AppColors.primary
                              .withOpacity(0.5)
                              : AppColors.primary,
                          borderRadius:
                          BorderRadius.circular(4.h)),
                      child: Center(
                        child: Text(
                          'Добавить новое объявление(${model.length} из 2)',
                          style: TextStyle(
                              color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              HBox(12.h),
              getReview(profile),
              clickOrderAndExit(context),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }


  Widget getReview(GetProfile profile){
    return FutureBuilder(
        future: RestServices().getAllReviewByPublication(userName:
        profile.username ?? '', categoryId: 0, rating: 0),
        builder: (BuildContext context, AsyncSnapshot snapshotReview){
          if (snapshotReview.hasData){
            PublicationReview reviewModel = snapshotReview.data;
            if (reviewModel.comments.isNotEmpty) {
              return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Отзывы (${reviewModel.commentsSize })',
                    style: AppTextStyles.body14Secondary,
                  ),
                  HBox(12.h),
                  Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 1.w), // changes position of shadow
                        ),
                      ],
                      color: AppColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            reviewModel.comments.first.rating ==3
                                ? Row(
                              children: [
                                Text('Отлично', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primary),),
                                Image.asset('assets/icons/emoji_best.png', width: 23.w, height: 23.h,)
                              ],
                            )
                                : reviewModel.comments.first.rating == 2
                                ?  Row(
                              children: [
                                Text('Хорошо', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.additionalGreenMedium),),
                                Image.asset('assets/icons/emoji_good.png', width: 23.w, height: 23.h,)
                              ],
                            )
                                : Row(
                              children: [
                                Text('Плохо', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.red),),
                                Image.asset('assets/icons/emoji_angry.png', width: 23.w, height: 23.h,)
                              ],
                            ),

                            Text(formatDate(reviewModel.comments.first.createdDate), style: AppTextStyles.bodySecondaryTen,),
                          ],
                        ),
                        HBox(12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColors.grayCategory
                          ),
                          child: Text(reviewModel.comments.first.category),
                        ),
                        HBox(12.h),
                        Text(reviewModel.comments.first.feedback,
                          style:  AppTextStyles.bodySecondary.copyWith(color: AppColors.blackGreyText),),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: reviewModel.comments.first.files.map((file){
                              return  GestureDetector(
                                onTap: (){ Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FullScreenImage(
                                        files: reviewModel.comments.first.files
                                    ),
                                  ),
                                );

                                },
                                child: Container(
                                  width: 94.w,
                                  height: 84.h,
                                  margin: EdgeInsets.only(right: 15.w, top: 12.h, bottom: 12.h),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0, 1.h), // changes position of shadow
                                      ),
                                    ],
                                    image: DecorationImage(
                                        image: NetworkImage(file.url), fit: BoxFit.fill),
                                    color: AppColors.primary.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(reviewModel.comments.first.authorFullName,
                            style:  AppTextStyles.bodySecondaryTen,),
                        ),
                      ],
                    ),
                  ),
                  reviewModel.comments.isNotEmpty
                      ? GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (_)=> ShowAllRateScreen(userName: profile.username ?? ''),),);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.w),
                              border: Border.all(color: AppColors.primary)
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Смотреть все отзывы (${reviewModel.comments.length})',
                            style: AppTextStyles.body14W500.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ) : const SizedBox(),
                  HBox(12.h),
                ],
              ),
            );
            } else {
              return const SizedBox();
            }
          }else{
            return const CircularProgressIndicator();
          }
        });
  }

  Widget buildPublicationCard(PublicationModel items) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailWorkerScreen(
              id: items.id,
              myPublication: true,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.h),
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color:
              items.favourite ? AppColors.primaryYellowColor : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 1.h), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 85.h,
              child: Row(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      items.files.isNotEmpty
                          ? Container(
                        height: 85.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(4.w),
                          image: DecorationImage(
                            image: NetworkImage(
                                items.files.first
                                    .url),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                          : Container(
                        height: 85.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: AppColors
                              .graySearch,
                          borderRadius:
                          BorderRadius
                              .circular(4.w),
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: const [
                            Icon(Icons
                                .no_photography_outlined),
                            Text('Нет фото')
                          ],
                        ),
                      ),
                      items.files.isNotEmpty
                          ? Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: EdgeInsets
                              .symmetric(
                              vertical: 4.h,
                              horizontal:
                              16.w),
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                4.w),
                            color: AppColors.black
                                .withOpacity(0.5),
                          ),
                          child: Text(
                            "1/${items.files.length.toString()}",
                            style: AppTextStyles
                                .captionPrimary
                                .copyWith(
                                color: AppColors
                                    .white),
                          ),
                        ),
                      )
                          : SizedBox()
                    ],
                  ),
                  WBox(12.w),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          items.category,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.w600),
                        ),
                      ),
                      HBox(8.h),
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          items.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles
                              .body14Secondary
                              .copyWith(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            items.city,
                            style: AppTextStyles
                                .body14Secondary
                                .copyWith(
                                fontSize: 10,
                                color:
                                AppColors.grayDark),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            HBox(12.h),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditOrderScreen(
                                  model: items,
                                )));
                  },
                  child: SizedBox(
                    height: 28.h,
                    width: MediaQuery.of(context).size.width / 2.7,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(4.h)),
                      child: const Center(
                        child: Text(
                          'Редактировать',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
                WBox(12.w),
                GestureDetector(
                  onTap: () =>
                      Share.share(items.description, subject: items.category),
                  child: SizedBox(
                    height: 28.h,
                    width: MediaQuery.of(context).size.width / 2.7,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(4.h)),
                      child: const Center(
                        child: Text(
                          'Поделиться',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                WBox(12.w),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext con) {
                          return CupertinoActionSheet(
                            actions: [
                              CupertinoButton(
                                  child: Text('Редактировать'),
                                  onPressed: () {
                                    Navigator.pop(con);
                                    Navigator.push(
                                      con,
                                      MaterialPageRoute(
                                        builder: (_) => EditOrderScreen(
                                          model: items,
                                        ),
                                      ),
                                    );
                                  }),
                              CupertinoButton(
                                  child: Text('Удалить'),
                                  onPressed: () async {
                                    Navigator.pop(con);
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return AlertDialog(
                                            content: Text(
                                              'Вы действительно хотите удалить данную публикацию?',
                                              style: AppTextStyles.body14W500
                                                  .copyWith(
                                                      color: AppColors.primary),
                                            ),
                                            actions: [
                                              GestureDetector(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  var deleteStatus =
                                                      await RestServices()
                                                          .deletePublication(
                                                              items.id);
                                                  if (deleteStatus == 200) {
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  height: 30.h,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            27.w),
                                                    border: Border.all(
                                                        color: AppColors.red,
                                                        width: 1),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Да, удалить',
                                                    style: AppTextStyles
                                                        .body14W500
                                                        .copyWith(
                                                            color:
                                                                AppColors.red),
                                                  ),
                                                ),
                                              ),
                                              HBox(8.w),
                                              GestureDetector(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 30.h,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            27.w),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .additionalGreenMediumButton,
                                                        width: 1),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Нет, отменить',
                                                    style: AppTextStyles
                                                        .body14W500
                                                        .copyWith(
                                                            color: AppColors
                                                                .additionalGreenMediumButton),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    ).then((value) => setState(() {}));
                                    setState(() {});
                                  }),
                            ],
                            cancelButton: CupertinoButton(
                                child: Text('Отмена'),
                                onPressed: () {
                                  Navigator.pop(con);
                                }),
                          );
                        });
                  },
                  child: SizedBox(
                    height: 28.h,
                    width: 36.w,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(4.h)),
                      child: const Center(
                        child: Text(
                          '...',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget clickOrderAndExit(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 16.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                var change = await RestServices().changeModeClient();
                if (change == 200) {
                  await Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.mainNav, (route) => false);
                  MotionToast.success(
                    description: const Text(
                      'Вы успешно сменили режим',
                      style: TextStyle(fontSize: 12),
                    ),
                    position: MotionToastPosition.top,
                    layoutOrientation: ToastOrientation.ltr,
                    animationType: AnimationType.fromTop,
                    dismissable: true,
                  ).show(context);
                  setState(() {});
                }
              },
              child: Container(
                height: 34.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Center(
                  child: Text(
                    'Перейти в режим заказчика',
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ),
            ),
            HBox(6.h),
            GestureDetector(
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          'Вы хотите выйти из аккаунта?',
                          style: AppTextStyles.bodySecondary
                              .copyWith(color: AppColors.primary),
                        ),
                        actions: [
                          CupertinoButton(
                              child: Text(
                                'Выйти',
                                style: AppTextStyles.bodySecondary
                                    .copyWith(color: AppColors.red),
                              ),
                              onPressed: () {
                                final tokenStore =
                                    getIt.get<TokenStoreService>();
                                tokenStore.clearAndLogoutToken();
                                SharedPreferencesHelper.removeAll();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, AppRoutes.help, (route) => false);
                              }),
                          CupertinoButton(
                              child: Text(
                                'Отмена',
                                style: AppTextStyles.bodySecondary
                                    .copyWith(color: AppColors.primary),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      );
                    });
              },
              child: Container(
                height: 34.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(width: 1.w, color: AppColors.red)),
                child: Center(
                  child: Text(
                    'Выход',
                    style: AppTextStyles.bodySecondary
                        .copyWith(color: AppColors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
