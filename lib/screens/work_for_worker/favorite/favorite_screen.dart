import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/routes.dart';

class FavoriteWorkerScreen extends StatefulWidget {
  const FavoriteWorkerScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteWorkerScreen> createState() => _FavoriteWorkerScreenState();
}

class _FavoriteWorkerScreenState extends State<FavoriteWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    final tokenStore = getIt.get<TokenStoreService>();
    return tokenStore.accessToken == null
        ? Material(
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
              leading: GestureDetector(
                onTap: ()=> Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: AppColors.white,),
              ),
              centerTitle: true,
              title: Text(
                'Избранное',
                style: AppTextStyles.h18Regular,
              ),
            ),
            body: SingleChildScrollView(
              child: FutureBuilder(
                future: RestServices().getFavoriteTask(),
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<TaskModel> model = snapshot.data;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: model.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          TaskModel items = model[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailTaskScreen(
                                    id: items.id,
                                  ),),);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.w),
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
                                    offset: Offset(
                                        0, 3.h), // changes position of shadow
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
                                      ),
                                      items.files.isNotEmpty ?
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
                                      ) : SizedBox(),
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
                                  HBox(6.h),
                                  Text(
                                    'Описание',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  HBox(6.h),
                                  Text(
                                    items.description,
                                    style: AppTextStyles.body14Secondary,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }else{
                    return const Center(
                      child: Text('Нет данных'),
                    );
                  }

                },
              ),
            ),
          );
  }
}
