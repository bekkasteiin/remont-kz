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
import 'package:remont_kz/utils/global_widgets/publication_card_view.dart';
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
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.white,
                ),
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
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<PublicationModel> model = snapshot.data;
                    return model.isNotEmpty
                        ? ListView.builder(
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
                                              builder: (_) =>
                                                  DetailWorkerScreen(
                                                    id: items.id,
                                                  ),),);
                                    },
                                    child: PublicationCardView(
                                      items: items,
                                      showStar: true,
                                      onTap: () async {
                                        await RestServices()
                                            .deleteFavouritePublication(
                                                items.id.toString());
                                        setState(() {
                                          items.favourite = !items.favourite;
                                        });
                                      },
                                    ),
                                  ),
                                  HBox(12.h),
                                ],
                              );
                            })
                        : Padding(
                            padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height / 2.5.h,
                            ),
                            child: Center(
                              child: Text(
                                'Нет избранных публикации',
                                style: AppTextStyles.body14Secondary,
                              ),
                            ),
                          );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          );
  }
}
