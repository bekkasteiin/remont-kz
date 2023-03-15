import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/main_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var lang = 'рус';

  final List<String> nameList = <String>["Қаз", "Рус", "Eng"];

  List<MainList> listOrder = [];

  void _populateDishes() {
    var list = <MainList>[
      MainList(
        fullName: 'Юрий Сергеевич',
        isFav: true,
        name: 'Электрик',
        image: 'assets/images/work1.png',
        price: 'от 10 000 тг',
        description: 'Выполняю электромонтажные работы быстро/качественно',
        street: 'sing',
        city: 'г. Алматы',
      ),
      MainList(
        fullName: 'Дильшат Махмадара',
        isFav: false,
        name: 'Электрик',
        image: 'assets/images/work2.png',
        price: 'договорная',
        description: 'Выполняю электромонтажные работы быстро/качественно',
        street: 'sing',
        city: 'г. Алматы',
      ),
      MainList(
        fullName: 'Юрий Сергеевич',
        isFav: true,
        name: 'Электрик',
        image: 'assets/images/work1.png',
        price: 'от 10 000 тг',
        description: 'Выполняю электромонтажные работы быстро/качественно',
        street: 'sing',
        city: 'г. Алматы',
      ),
    ];
    setState(() {
      listOrder = list;
    });
  }

  @override
  void initState() {
    _populateDishes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE2E2E2),
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
              color: AppColors.white,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Image.asset(
                      'assets/images/categories.png',
                      width: 20,
                      height: 16,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(
                      'Категории',
                      style: AppTextStyles.body14Secondary,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.h,
                      color: AppColors.blackGreyText,
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Image.asset(
                      'assets/images/advice.png',
                      width: 20,
                      height: 16,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(
                      'Полезные советы',
                      style: AppTextStyles.body14Secondary,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.h,
                      color: AppColors.blackGreyText,
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Image.asset(
                      'assets/images/favorite.png',
                      width: 20,
                      height: 16,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(
                      'Избранное',
                      style: AppTextStyles.body14Secondary,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.h,
                      color: AppColors.blackGreyText,
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Image.asset(
                      'assets/images/my_order.png',
                      width: 20,
                      height: 16,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(
                      'Мои заявки',
                      style: AppTextStyles.body14Secondary,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.h,
                      color: AppColors.blackGreyText,
                    ),
                  ),
                  Container(
                    height: 1.h,
                    color: AppColors.darkGray,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Text(
                'Актуальные предложения',
                style: AppTextStyles.h18Regular.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w400),
              ),
            ),
            createTaskList.isEmpty ?
            const SizedBox()
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: createTaskList.length,
             itemBuilder: (context, index){
               return Container(
                 padding: EdgeInsets.all(16.h),
                 margin: EdgeInsets.symmetric(vertical: 8.h),
                 decoration: BoxDecoration(
                   color: createTaskList[index].isFav ?
                   AppColors.primaryYellowColor
                       : AppColors.white,
                   boxShadow: const [
                     BoxShadow(
                       color: AppColors.white,
                       spreadRadius: 1,
                       blurRadius: 2,
                       offset: Offset(0, 3),
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
                           createTaskList[index].fullName,
                           style: AppTextStyles.h18Regular.copyWith(
                               color: AppColors.primary,
                               fontWeight: FontWeight.w400),
                         ),
                         IconButton(
                             onPressed: () {},
                             icon: Icon(
                                 createTaskList[index].isFav
                                     ? Icons.star
                                     : Icons.star_border,
                                 color: createTaskList[index].isFav
                                     ? AppColors.primaryYellow
                                     : null))
                       ],
                     ),
                     Text(
                       'Цена: ${createTaskList[index].price}',
                       style: AppTextStyles.body14Secondary,
                     ),
                     HBox(8.h),
                     Row(
                       children: [
                         Container(
                           height: 85.h,
                           width: 156.w,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(8.w),
                             image: DecorationImage(
                               image: FileImage(
                                 createTaskList[index].image,
                               ),
                               fit: BoxFit.fill,
                             ),
                           ),
                         ),
                         WBox(8.w),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               createTaskList[index].name,
                               style: AppTextStyles.body14Secondary
                                   .copyWith(fontWeight: FontWeight.w500),
                             ),
                             HBox(16.h),
                             Container(
                               width: 162.w,
                               child: Text(
                                 createTaskList[index].description,
                                 style: AppTextStyles.body14Secondary
                                     .copyWith(fontSize: 10),
                               ),
                             ),
                             HBox(4.h),
                             Text(
                               createTaskList[index].city,
                               style: AppTextStyles.body14Secondary.copyWith(
                                   fontSize: 10, color: AppColors.grayDark),
                             ),
                           ],
                         )
                       ],
                     ),
                     HBox(12.h),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                           'Работ 47 | Отзывов 35',
                           style: AppTextStyles.body14Secondary
                               .copyWith(fontSize: 10),
                         ),
                         Row(
                           children: [
                             Text(
                               '76',
                               style: AppTextStyles.body14Secondary
                                   .copyWith(fontSize: 10),
                             ),
                             WBox(4.w),
                             Icon(
                               Icons.remove_red_eye_outlined,
                               size: 16.h,
                               color: AppColors.grayDark,
                             )
                           ],
                         )
                       ],
                     )
                   ],
                 ),
               );
             }
            ),

            ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: listOrder.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  MainList items = listOrder[index];
                  return Container(
                    padding: EdgeInsets.all(16.h),
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: items.isFav ?
                      AppColors.primaryYellowColor
                          : AppColors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.white,
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(0, 1),
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
                              items.fullName,
                              style: AppTextStyles.h18Regular.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                    items.isFav
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: items.isFav
                                        ? AppColors.primaryYellow
                                        : null))
                          ],
                        ),
                        Text(
                          'Цена: ${items.price}',
                          style: AppTextStyles.body14Secondary,
                        ),
                        HBox(8.h),
                        Row(
                          children: [
                            Container(
                              height: 85.h,
                              width: 156.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.w),
                                image: DecorationImage(
                                  image: AssetImage(
                                    items.image,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            WBox(8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items.name,
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                HBox(16.h),
                                Container(
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
                                  style: AppTextStyles.body14Secondary.copyWith(
                                      fontSize: 10, color: AppColors.grayDark),
                                ),
                              ],
                            )
                          ],
                        ),
                        HBox(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Работ 47 | Отзывов 35',
                              style: AppTextStyles.body14Secondary
                                  .copyWith(fontSize: 10),
                            ),
                            Row(
                              children: [
                                Text(
                                  '76',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(fontSize: 10),
                                ),
                                WBox(4.w),
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 16.h,
                                  color: AppColors.grayDark,
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
