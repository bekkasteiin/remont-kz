import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/my_order/my_publication.dart';
import 'package:remont_kz/screens/task/category/category_screen.dart';
import 'package:remont_kz/screens/work_for_worker/favorite/favorite_screen.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class MainWorkerScreen extends StatefulWidget {
  const MainWorkerScreen({Key? key}) : super(key: key);

  @override
  State<MainWorkerScreen> createState() => _MainWorkerScreenState();
}

class _MainWorkerScreenState extends State<MainWorkerScreen> {
  var lang = 'рус';

  final List<String> nameList = <String>["Қаз", "Рус", "Eng"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/g10.png',
              width: 24.w,
              height: 22.h,
            ),
            Image.asset(
              'assets/images/repair.png',
              width: 88.w,
              height: 16.h,
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Row(
              children: [
                Text(
                  lang,
                  style: AppTextStyles.body14Secondary
                      .copyWith(color: AppColors.white),
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: AppColors.white,
                )
              ],
            ),
            color: Colors.blue,
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'Қаз',
                child: Text(
                  "Қаз",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Рус',
                child: Text(
                  "Рус",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Eng',
                child: Text(
                  "Eng",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            onSelected: (item) {
              setState(() {
                lang = item;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> CategoriesScreen(showLeading: true,),),);
                    },
                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/categories.png',
                                width: 20.w,
                                height: 16.h,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 24.w,),
                              Text(
                                'Услуги ремонта и строительства',
                                style: AppTextStyles.body14Secondary,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18.h,
                            color: AppColors.blackGreyText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                  Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/advice.png',
                              width: 20.w,
                              height: 16.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(width: 24.w,),
                            Text(
                              'Полезные советы',
                              style: AppTextStyles.body14Secondary,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18.h,
                          color: AppColors.blackGreyText,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const FavoriteWorkerScreen(),),);
                    },
                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/favorite.png',
                                width: 20.w,
                                height: 16.h,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 24.w,),
                              Text(
                                'Избранное',
                                textAlign: TextAlign.start,
                                style: AppTextStyles.body14Secondary,
                              ),
                            ],
                          ),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18.h,
                            color: AppColors.blackGreyText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const GetAllMyPublication(),),);
                    },
                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/my_order.png',
                                width: 20.w,
                                height: 16.h,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 24.w,),
                              Text(
                                'Мои объявления',
                                textAlign: TextAlign.start,
                                style: AppTextStyles.body14Secondary,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18.h,
                            color: AppColors.blackGreyText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12.w, top: 12.h, bottom: 6.h),
              child: Text(
                'Актуальные предложения',
                style: AppTextStyles.h18Regular.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w400),
              ),
            ),
            FutureBuilder(
              future: RestServices().getAllTask(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
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
                                        ),),).then((value) => setState((){}));
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
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
