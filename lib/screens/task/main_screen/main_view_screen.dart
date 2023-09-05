import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/my_order/my_task.dart';
import 'package:remont_kz/screens/task/category/category_screen.dart';
import 'package:remont_kz/screens/task/favorite/favorite_screen.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/screens/work_for_worker/chat/chat_widget/load_shimmer.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var lang = 'рус';
  bool isLoading = true;
  late List<PublicationModel> model;
  final List<String> nameList = <String>["Қаз", "Рус", "Eng"];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final tokenStore = getIt.get<TokenStoreService>();
        final loadPublication = tokenStore.accessToken != null
            ? await RestServices().getPublicationAccessToken()
            : await RestServices().getPublication();
        if (mounted) {
          setState(() {
            model = loadPublication;
            isLoading = false;
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
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 40.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoriesScreen(
                                    showLeading: true, isClient: true),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/categories.png',
                                width: 20.w,
                                height: 16.h,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(
                                width: 24.w,
                              ),
                              Text(
                                'Категории',
                                style: AppTextStyles.body14Secondary,
                              ),
                            ],
                          ),
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
                  Container(
                    height: 40.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
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
                            SizedBox(
                              width: 24.w,
                            ),
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoriteScreen(),
                      ),
                    ),
                    child: Container(
                      height: 40.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
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
                              SizedBox(
                                width: 24.w,
                              ),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GetAllMyTask(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
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
                              SizedBox(
                                width: 24.w,
                              ),
                              Text(
                                'Мои заявки',
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
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 12.h, bottom: 6.h),
              child: Text(
                'Актуальные предложения',
                style: AppTextStyles.h18Regular.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w400),
              ),
            ),
            isLoading?
            LoadShimmerPublication()
          :
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
                                  ))).then((value) => setState(() {}));
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.h),
                      margin: EdgeInsets.symmetric(vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
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
                                items.user.fullName,
                                style: AppTextStyles.h18Regular.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400),
                              ),
                              GestureDetector(
                                onTap: tokenStore.accessToken != null
                                    ? () async {
                                        if (items.favourite) {
                                          await RestServices()
                                              .deleteFavouritePublication(
                                                  items.id.toString());
                                        } else {
                                          await RestServices().addFavourite(
                                              items.id.toString());
                                        }

                                        setState(() {});
                                      }
                                    : null,
                                child: Icon(
                                    items.favourite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: items.favourite
                                        ? AppColors.primaryYellow
                                        : null),
                              ),
                            ],
                          ),
                          HBox(5.h),
                          items.isContractual
                              ? Text(
                                  'Цена: договорная',
                                  style: AppTextStyles.body14Secondary,
                                )
                              : Text(
                                  'Цена: ${items.price.toInt()} ₸',
                                  style: AppTextStyles.body14Secondary,
                                ),
                          HBox(12.h),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  items.files.isNotEmpty
                                      ? Container(
                                          height: 85.h,
                                          width: 140.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.w),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  items.files.first.url),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 85.h,
                                          width: 140.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.graySearch,
                                            borderRadius:
                                                BorderRadius.circular(4.w),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                                horizontal: 16.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.w),
                                              color: AppColors.black
                                                  .withOpacity(0.5),
                                            ),
                                            child: Text(
                                              "1/${items.files.length.toString()}",
                                              style: AppTextStyles
                                                  .captionPrimary
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                              WBox(10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items.category,
                                    maxLines: 2,
                                    style: AppTextStyles.captionPrimary
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  HBox(16.h),
                                  SizedBox(
                                    width: 160.w,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                }),
          ],
        ),
      ),
    );
  }
}
