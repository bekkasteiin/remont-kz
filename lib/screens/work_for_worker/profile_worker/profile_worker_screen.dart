// ignore_for_file: use_build_context_synchronously

import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/di.dart';
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
  GetProfile profile = GetProfile();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loadChat = await RestServices().getMyProfile();

        if (mounted) {
          setState(() {
            profile = loadChat;
          });
        }
      } catch (e) {
        // Handle any errors that might occur during the network request.
        print("Error fetching publication: $e");
      }
    });
    future = RestServices().getMyProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
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
                ).then((value) => setState((){}));
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
            future: future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                GetProfile profile = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HBox(24.h),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.w),
                        child: profileContainer(profile),
                      ),
                      HBox(12.h),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.w),
                        child: aboutMe(profile, context),
                      ),
                      HBox(12.h),
                      myPublication(context),
                    ],
                  ),
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
                        fit: BoxFit.fitWidth),
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
                  child: Icon(Icons.account_circle_outlined),
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
                  SizedBox(
                    width: 4.w,
                  ),
                  const Text('Имя'),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(profile.name ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text('Адрес'),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(profile.address ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.phone_callback_outlined,
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text('Номер'),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(formatPhone(profile.username ?? '')),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
          ],
        ),
      ],
    );
  }

  String formatPhone(String input) {
    if (input.length >= 10) {
      final countryCode = '+${input.substring(0,1)}';
      final areaCode = input.substring(1, 4);
      final firstPart = input.substring(4, 7);
      final secondPart = input.substring(7, 9);
      final thirdPart = input.substring(9);
        formattedNumber = '$countryCode ($areaCode) $firstPart-$secondPart-$thirdPart';

      return formattedNumber;
    } else {
      setState(() {
        formattedNumber = '';
      });
      return formattedNumber;
    }
  }


  Widget aboutMe(GetProfile profile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('О себе', style: AppTextStyles.h18Regular.copyWith(color: AppColors.black),),
        HBox(12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          width: MediaQuery.of(context).size.width,
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
          ),
          child:profile.aboutMe!=null?
          Row(
            children: [
              Text(
                profile.aboutMe ?? '',
              ),
              Expanded(
                child: GestureDetector(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 8.w),
                      child: Image.asset('assets/icons/edit.png',
                      height: 16.h, width: 16.w,),
                    ),),
                  onTap: (){
                    showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w)),
                        ),
                        context: context, builder: (_){
                      return FractionallySizedBox(
                        heightFactor: 0.8,
                        child: Column(
                          children: [
                            HBox(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                              child: Column(
                                children: [
                                  FieldBones(
                                    placeholder: "О себе",
                                    textValue: profile.aboutMe ?? '',
                                    maxLines: 10,
                                    maxLength: 300,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(300),
                                    ],
                                    focusNode: _focusNode,
                                    editable: true,
                                    isTextField: true,
                                    onChanged: (val){
                                      profile.aboutMe = val;
                                      aboutMeText = val;
                                    },
                                  ),
                                  HBox(12.h),
                                  GestureDetector(
                                    onTap: ()async{
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      setState(() {
                                        editText = !editText;
                                      });
                                      profile.aboutMe = aboutMeText;

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
                                        await Navigator.pushNamedAndRemoveUntil(
                                            context, AppRoutes.mainNavWorker, (route) => false);
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
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(8.w),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4.w),
                                          color: AppColors.primary),
                                      child: Text(
                                        'Сохранить',
                                        style: AppTextStyles.body14Secondary
                                            .copyWith(color: AppColors.white, fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                    setState(() {
                      future = RestServices().getMyProfile();
                    });
                  },
                ),
              ),
            ],
          )
          :  GestureDetector(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
                child: Image.asset('assets/icons/edit.png',
                  height: 16.h, width: 16.w,),
              ),),
            onTap: (){
              showModalBottomSheet(
                  isDismissible: false,
                  isScrollControlled: true,
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w)),
                  ),
                  context: context, builder: (_){
                return FractionallySizedBox(
                  heightFactor: 0.8,
                  child: Column(
                    children: [
                      HBox(12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                        child: Column(
                          children: [

                            FieldBones(
                              placeholder: "О себе",
                              textValue: profile.aboutMe ?? '',
                              maxLines: 10,
                              maxLength: 300,

                              inputFormatters: [
                                LengthLimitingTextInputFormatter(300),
                              ],
                              focusNode: _focusNode,
                              editable: true,
                              isTextField: true,
                              onChanged: (val){
                                profile.aboutMe = val;
                                aboutMeText = val;
                              },
                            ),
                            HBox(12.h),
                            GestureDetector(
                              onTap: ()async{
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  editText = !editText;
                                });
                                profile.aboutMe = aboutMeText;

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
                                  await Navigator.pushNamedAndRemoveUntil(
                                      context, AppRoutes.mainNavWorker, (route) => false);
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
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(8.w),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: AppColors.primary),
                                child: Text(
                                  'Сохранить',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(color: AppColors.white, fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
              setState(() {
                future = RestServices().getMyProfile();
              });
              setState(() {

              });
            },
          ),
        ),
      ],
    );
  }

  Widget myPublication(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'Мои объявления',
            style:
                AppTextStyles.body14Secondary.copyWith(color: AppColors.black),
          ),
        ),
        HBox(6.w,),
        myPublications(),
        HBox(6.h),
        clickOrderAndExit(context)
      ],
    );
  }

  Widget myPublications() {
    return profile!= null ?
     FutureBuilder(
      future: RestServices().getMyPublication(userName:  profile.username ?? ''),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<PublicationModel> model = snapshot.data;
          return Column(
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: model.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    PublicationModel items = model[index];
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
                          color: items.favourite
                              ? AppColors.primaryYellowColor
                              : AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset:
                                  Offset(0, 3.h), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  items.user.fullName ?? '',
                                  style: AppTextStyles.h18Regular.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            HBox(5.h),
                            items.isContractual ?
                            Text(
                              'договорная',
                              style: AppTextStyles.body14Secondary,
                            )
                            :
                            Text(
                              'Цена: ${items.price.toInt()} ₸',
                              style: AppTextStyles.body14Secondary,
                            ),
                            HBox(8.h),
                            Row(
                              children: [

                                Stack(
                                  children: [
                                    items.files.isNotEmpty?
                                    Container(
                                      height: 85.h,
                                      width: 156.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              items.files.first.url),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ) :
                                    Container(
                                      height: 85.h,
                                      width: 156.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(4.w),
                                        color: AppColors.graySearch
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.no_photography_outlined),
                                          Text('Нет фото')
                                        ],
                                      ),
                                    ),
                                    items.files.isNotEmpty?
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.h, horizontal: 16.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.w),
                                          color:
                                              AppColors.black.withOpacity(0.5),
                                        ),
                                        child: Text(
                                         "1/${items.files.length.toString()}",
                                          style: AppTextStyles.captionPrimary
                                              .copyWith(color: AppColors.white),
                                        ),
                                      ),
                                    ) : SizedBox(),
                                  ],
                                ),
                                WBox(6.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        items.category,
                                        style: AppTextStyles.body14Secondary
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    HBox(12.h),
                                    SizedBox(
                                      width: 162.w,
                                      child: Text(
                                        items.description,
                                        style: AppTextStyles.body14Secondary
                                            .copyWith(fontSize: 10),
                                      ),
                                    ),
                                    HBox(4.h),
                                    Text(
                                      items.city,
                                      style: AppTextStyles.body14Secondary
                                          .copyWith(
                                              fontSize: 10,
                                              color: AppColors.grayDark),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            HBox(12.h),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>EditOrderScreen(
                                      model: items,
                                    )));
                                  },
                                  child: SizedBox(
                                    height: 28.h,
                                    width: MediaQuery.of(context).size.width/2.7,
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
                                  onTap: (){},
                                  child: SizedBox(
                                    height: 28.h,
                                    width: MediaQuery.of(context).size.width/2.7,
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
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                      builder: (BuildContext con){
                                      return CupertinoActionSheet(

                                        actions: [
                                          CupertinoButton(child: Text('Редактировать'), onPressed: (){
                                            Navigator.pop(con);
                                            Navigator.push(con, MaterialPageRoute(builder: (_)=>EditOrderScreen(
                                              model: items,
                                            ),),);
                                          }),
                                          CupertinoButton(child: Text('Диактивировать'), onPressed: ()async{
                                            Navigator.pop(con);
                                            var deleteStatus = await RestServices().deactivatePublication(items.id);
                                            if(deleteStatus == 200){
                                              setState(() {

                                              });
                                            }
                                          }),
                                          CupertinoButton(child: Text('Удалить'), onPressed: ()async{

                                            Navigator.pop(con);
                                           var deleteStatus = await RestServices().deletePublication(items.id);
                                           if(deleteStatus == 200){
                                             setState(() {

                                             });
                                           }


                                          }),

                                        ],
                                        cancelButton: CupertinoButton(child: Text('Отмена'), onPressed: (){
                                          Navigator.pop(con);
                                        }),
                                      );
                                      }

                                    );
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
                  }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: GestureDetector(
                  onTap: model.length >= 2 ? null : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateOrderScreen()));
                  },
                  child: SizedBox(
                    height: 34.h,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                          color: model.length >= 2
                              ? AppColors.primary.withOpacity(0.5)
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(4.h)),
                      child: Center(
                        child: Text(
                          'Добавить новое объявление(${model.length} из 2)',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
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
    )
    : SizedBox();
  }

  Widget clickOrderAndExit(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: ()async{
                var change = await RestServices().changeModeClient();
                if(change ==200){
                  await Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.mainNav, (route) => true);
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
                    borderRadius: BorderRadius.circular(4.w),),
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
              onTap: (){
                showCupertinoDialog(context: context, builder: (context){
                  return CupertinoAlertDialog(
                    title:Text('Вы хотите выйти из аккаунта?',
                    style: AppTextStyles.bodySecondary.copyWith(color: AppColors.primary),),
                    actions: [
                      CupertinoButton(child: Text('Выйти',
                      style: AppTextStyles.bodySecondary.copyWith(color: AppColors.red),), onPressed: (){
                        final tokenStore = getIt.get<TokenStoreService>();
                        tokenStore.clearAndLogoutToken();
                        SharedPreferencesHelper.removeAll();
                        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.help, (route) => false);
                      }),
                      CupertinoButton(child: Text('Отмена',
                      style: AppTextStyles.bodySecondary.copyWith(color: AppColors.primary),), onPressed: (){
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
