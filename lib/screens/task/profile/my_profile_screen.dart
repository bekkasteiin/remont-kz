// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/task/profile/edit_profile_client.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/shared_pr_widget.dart';
import 'package:remont_kz/utils/routes.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  late String formattedNumber;
  GetProfile profile = GetProfile();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loadProfile = await RestServices().getMyProfile();

        if (mounted) {
          profile = loadProfile;
          setState(() {
          });
        }
      } catch (e) {
        // Handle any errors that might occur during the network request.
        print("Error fetching publication: $e");
      }
    });
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
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

  @override
  Widget build(BuildContext context) {
    final tokenStore = getIt.get<TokenStoreService>();
    return tokenStore.accessToken != null
        ? Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Профиль',
                style: AppTextStyles.h18Regular,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const EditProfileClient(),),);
                    },
                    child: const Icon(
                      Icons.settings,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: FutureBuilder(
              future: RestServices().getMyProfile(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  GetProfile profile = snapshot.data;
                  return CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.h,),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 16.w),
                              child: profileContainer(profile),
                            ),
                            HBox(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                'Мои заявки',
                                style: AppTextStyles.body14Secondary
                                    .copyWith(color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            Expanded(child: myRequest()),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: ()async{
                                      var change = await RestServices().changeModeClient();
                                      if(change ==200){
                                        await Navigator.pushNamedAndRemoveUntil(
                                            context, AppRoutes.mainNavWorker, (route) => true);
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

                                        setState(() {

                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 34.h,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(4.w)),
                                      child: Center(
                                        child: Text(
                                          'Перейти в режим исполнителя',
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
                                              SharedPreferencesHelper.removeAll();
                                              final tokenStore = getIt.get<TokenStoreService>();
                                              tokenStore.clearAndLogoutToken();

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

                          ],
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
          )
        : Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: const Text(
                      'Войдите, чтобы создать задания, ответить на сообщения или найти того, кто вам нужен',
                      style: TextStyle(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.w),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.sign, (route) => false);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(12.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            color: AppColors.white),
                        child: Text(
                          'Войти или создать профиль',
                          style: AppTextStyles.body14Secondary.copyWith(
                              color: AppColors.primary, fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget profileContainer(GetProfile profile) {
    return Row(
      children: [

        profile.photoUrl!= null ?
        Container(
          height: 116.h,
          width: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(profile.photoUrl),
                  fit: BoxFit.fill
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary),
        ) : Container(
          height: 116.h,
          width: 100.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: const Icon(Icons.account_circle_outlined, color: AppColors.white, size: 60,),),
        ),
        const SizedBox(
          width: 16,
        ),
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
                      child: Text(profile.name ?? ''),),
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
                children:  [
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
                  Expanded(child: Align(
                    alignment: Alignment.centerRight,
                      child: Text(formatPhone(profile.username ?? '')),),),
                ],
              ),
            ),
             SizedBox(
              height: 25.h,
            ),
          ],
        )
      ],
    );
  }

  Widget myRequest(){
    return FutureBuilder(
      future: RestServices().getMyTasks(userName: profile.username ?? ''),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<TaskModel> model = snapshot.data;
          List<TaskModel> activatedTasks = model.where((task) => task.status == 'ACTIVATED').toList();
          List<TaskModel> completedTasks = model.where((task) => task.status == 'COMPLETED').toList();
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.w),
                      color: AppColors.primary,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Активные'),
                      Tab(text: 'Неактивные'),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemCount: activatedTasks.length,
                      itemBuilder: (context, index) {
                        TaskModel items = activatedTasks[index];
                        return buildTaskCard(items);
                      },
                    ),
                    ListView.builder(
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        TaskModel items = completedTasks[index];
                        return buildTaskCard(items);
                      },
                    ),
                  ],
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
    );
  }



  Widget buildTaskCard(TaskModel items){
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailTaskScreen(
                    id: items.id,
                    myTask: true,
                  ),),);
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: items.favourite
                    ? AppColors.primaryYellowColor
                    : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(
                        0, 3.w
                    ),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      items.files.isNotEmpty ?
                      Container(
                        height: 146.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          image: DecorationImage(
                            image:
                            NetworkImage(items.files.first.url),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ) : Container(
                        height: 146.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          color: AppColors.graySearch
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.no_photography_outlined),
                            Text('Нет фото')
                          ],
                        ),
                      ),items.files.isNotEmpty ?

                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            color: AppColors.black.withOpacity(0.5),
                          ),
                          child: Text("1/${items.files.length.toString()}",
                            style: AppTextStyles.captionPrimary.copyWith(color: AppColors.white),),
                        ),
                      ) : SizedBox()
                    ],
                  ),
                  HBox(12.h),
                  Text(
                    items.title,
                    style: AppTextStyles.body14Secondary
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  HBox(6.h),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Категория',
                        style: AppTextStyles.body14Secondary
                            .copyWith(
                            color: AppColors.primaryGray),
                      ),
                      Text(items.category,
                          style: AppTextStyles.body14Secondary),
                    ],
                  ),
                  HBox(6.h),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Стоимость работ',
                        style: AppTextStyles.body14Secondary
                            .copyWith(
                            color: AppColors.primaryGray),
                      ),
                      items.isContractual ?
                      Text("договорная",
                          style: AppTextStyles.body14Secondary)
                      :
                      Text("${items.price.toInt().toString()} ₸",
                          style: AppTextStyles.body14Secondary),
                    ],
                  ),
                  HBox(12.h),
                  Row(
                    children: [
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
                                'Рекламировать',
                                style: TextStyle(color: AppColors.white),
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
                                color: AppColors.white,
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(4.h)),
                            child: const Center(
                              child: Text(
                                'Поднять за 300 ₸',
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
          ),
          HBox(12.h)
        ],
      ),
    );
  }
}


