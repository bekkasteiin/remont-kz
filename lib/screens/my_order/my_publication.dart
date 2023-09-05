import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class GetAllMyPublication extends StatefulWidget {
  const GetAllMyPublication({Key? key}) : super(key: key);

  @override
  State<GetAllMyPublication> createState() => _GetAllMyPublicationState();
}

class _GetAllMyPublicationState extends State<GetAllMyPublication> {
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Мои объявления',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: profile.username != null
          ? FutureBuilder(
              future: RestServices()
                  .getMyPublication(userName: profile.username ?? ''),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<PublicationModel> model = snapshot.data;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: model.length,
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
                                  offset: Offset(
                                      0, 3.h), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items.user.fullName ?? '',
                                  style: AppTextStyles.h18Regular.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w400),
                                ),
                                HBox(5.h),
                                items.isContractual
                                    ? Text(
                                        'договорная',
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
                                                width: 156.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.w),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        items.files.first.url),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 85.h,
                                                width: 156.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.w),
                                                  color: AppColors.graySearch,
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
                                                        BorderRadius.circular(
                                                            4.w),
                                                    color: AppColors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  child: Text(
                                                    "1/${items.files.length.toString()}",
                                                    style: AppTextStyles
                                                        .captionPrimary
                                                        .copyWith(
                                                            color: AppColors
                                                                .white),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                    WBox(6.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 162.w,
                                          child: Text(
                                            items.category,
                                            style: AppTextStyles.body14Secondary
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                    ),
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
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : SizedBox(),
    );
  }
}
