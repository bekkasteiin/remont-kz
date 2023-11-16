import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/category/category_screen.dart';
import 'package:remont_kz/screens/chat/chat_widget/load_shimmer.dart';
import 'package:remont_kz/screens/my_order/my_task.dart';
import 'package:remont_kz/screens/task/favorite/favorite_screen.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/screens/usefull_tips/usefull_tips_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/publication_card_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var lang = 'рус';
  bool isLoading = true;
  late List<PublicationModel> publicationModel;

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
            publicationModel = loadPublication;
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
        title: SizedBox(
          height: 22.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/g10.png',
                width: 24.w,
                height: 22.h,
              ),
              WBox(12.w),
              Text('REMONT.KZ', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.white
              ),)

            ],
          ),
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
                    blurRadius: 4,
                    offset: Offset(0, 1.w),
                  ),
                ],
              ),
              child: Column(
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
                    child: Container(
                      color: AppColors.transparent,
                      height: 40.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
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
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18.h,
                                color: AppColors.blackGreyText,
                              ),
                            ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const UseFullTipsScreen()));
                    },
                    child: Container(
                      height: 40.h,
                      color: AppColors.transparent,
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
                      color: AppColors.transparent,
                      height: 40.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                      child: Row(
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
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18.h,
                                color: AppColors.blackGreyText,
                              ),
                            ),
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
                      color: AppColors.transparent,
                      height: 40.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18.h,
                                color: AppColors.blackGreyText,
                              ),
                            ),
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
              padding: EdgeInsets.only(left: 12.w, top: 12.h, bottom: 12.h),
              child: Text(
                'Актуальные предложения',
                style: AppTextStyles.h18Regular.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w400),
              ),
            ),
            isLoading
                ? const LoadShimmerPublication()
                : FutureBuilder(
                    future: tokenStore.accessToken != null
                        ? RestServices().getPublicationAccessToken()
                        : RestServices().getPublication(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final model = snapshot.data;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: model.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              PublicationModel items = model[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => DetailWorkerScreen(
                                                    id: items.id,
                                                  ),),).then(
                                          (value) => setState(() {}));
                                    },
                                    child: PublicationCardView(items: items,
                                      showStar: true,
                                    onTap: tokenStore.accessToken !=
                                        null
                                        ? () async {
                                      if (items.favourite) {
                                        await RestServices()
                                            .deleteFavouritePublication(
                                            items.id
                                                .toString());
                                        setState(() {});
                                      } else {
                                        await RestServices()
                                            .addFavourite(items.id
                                            .toString());
                                      }
                                      setState(() {});
                                    }
                                        : null,),
                                  ),
                                  HBox(12.h),
                                ],
                              );
                            });
                      } else {
                        return SizedBox();
                      }
                    }),
          ],
        ),
      ),
    );
  }
}
