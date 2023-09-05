import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/routes.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({Key? key}) : super(key: key);

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  GetProfile profile = GetProfile();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final tokenStore = await RestServices().getMyProfile();

        if (mounted) {
          setState(() {
            profile = tokenStore;
          });
        }
      } catch (e) {
        // Handle any errors that might occur during the network request.
        print("Error fetching publication: $e");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tokenStore = getIt.get<TokenStoreService>();
    return tokenStore.accessToken == null
        ? Center(
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
          )
        : Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Мои заявки',
                style: AppTextStyles.h18Regular,
              ),
            ),
            body: FutureBuilder(
              future: RestServices().getMyTasks(userName: profile.username ?? ''),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<TaskModel> model = snapshot.data;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: model.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        TaskModel items = model[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailTaskScreen(
                                  id: items.id,
                                  myTask: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            margin: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: items.favourite
                                  ? AppColors.primaryYellowColor
                                  : AppColors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: Offset(0, 3.w),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 146.h,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.w),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(items.files.first.url),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                HBox(12.h),
                                Text(
                                  items.title ?? '',
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
                                    Text("${items.price.toString()} ₸",
                                        style: AppTextStyles.body14Secondary),
                                  ],
                                ),
                                HBox(6.h),
                                Text(
                                  'Описание',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                HBox(6.h),
                                Text(
                                  items.description ?? '',
                                  style: AppTextStyles.body14Secondary,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
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
