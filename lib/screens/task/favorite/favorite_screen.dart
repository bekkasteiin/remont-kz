import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/routes.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
                future: RestServices().getFavoritePublication(),
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<PublicationModel> model = snapshot.data;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: model.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          PublicationModel items = model[index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailWorkerScreen(id: items.id,)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.h),
                              margin: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: BoxDecoration(
                                color:AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 8,
                                    offset: Offset(0, 3.h), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        items.user.fullName,
                                        style: AppTextStyles.h18Regular.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      GestureDetector(
                                          onTap: ()async {
                                           await RestServices().deleteFavouritePublication(items.id.toString());

                                            setState(() {

                                              items.favourite = !items.favourite;
                                            });
                                          },
                                          child: Icon(
                                              items.favourite == true
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: items.favourite
                                                  ? AppColors.primaryYellow
                                                  : null))
                                    ],
                                  ),
                                  HBox(5.h),
                                  items.isContractual ?
                                  Text(
                                    'Цена: договорная',
                                    style: AppTextStyles.body14Secondary,
                                  ):
                                  Text(
                                    'Цена: ${items.price.toInt()} ₸',
                                    style: AppTextStyles.body14Secondary,
                                  ),
                                  HBox(12.h),
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          items.files.isNotEmpty?
                                          Container(
                                            height: 85.h,
                                            width: 156.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.w),
                                              image: DecorationImage(
                                                image: NetworkImage(items.files.first.url),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ) :
                                          Container(
                                            height: 85.h,
                                            width: 156.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.graySearch,
                                              borderRadius: BorderRadius.circular(4.w),
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
                                      WBox(6.w),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            items.category,
                                            maxLines: 2,
                                            style: AppTextStyles.captionPrimary
                                                .copyWith(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          HBox(16.h),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Работ 0 | Отзывов 0',
                                        style: AppTextStyles.body14Secondary
                                            .copyWith(fontSize: 10),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '0',
                                            style: AppTextStyles.body14Secondary
                                                .copyWith(fontSize: 10),
                                          ),
                                          WBox(4.w),
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 16.h,
                                            color: AppColors.grayDark,
                                          ),
                                        ],
                                      ),
                                    ],
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
