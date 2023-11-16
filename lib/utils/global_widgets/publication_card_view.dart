import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class PublicationCardView extends StatelessWidget {
  PublicationModel items;
  dynamic onTap;
  bool showStar;
  bool notShowDetail;
  bool isChat;

  PublicationCardView({Key? key, required this.items, required this.onTap, required this.showStar, this.notShowDetail = false, this.isChat = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0,
                1.h), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          !notShowDetail?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items.user.fullName,
                    style: AppTextStyles.h18Regular
                        .copyWith(
                        color: AppColors.primary,
                        fontWeight:
                        FontWeight.w400),
                  ),
                  showStar?
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(
                        items.favourite
                            ? Icons.star
                            : Icons.star_border,
                        color: items.favourite
                            ? AppColors.primaryYellow
                            : null),
                  ) : const SizedBox(),
                ],
              ),
              HBox(5.h),
              items.isContractual
                  ?
              Text(
                'Цена: договорная',
                style:
                AppTextStyles.body14Secondary.copyWith(fontWeight: FontWeight.w500),
              )
                  : Text(
                'Цена: от ${items.price.toInt()} ₸',
                style:
                AppTextStyles.body14Secondary.copyWith(fontWeight: FontWeight.w500),
              ),
              HBox(12.h),
            ],
          ) : const SizedBox(),

          SizedBox(
            height: 85.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    items.files.isNotEmpty
                        ? Container(
                      height: 85.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                        BorderRadius
                            .circular(4.w),
                        image: DecorationImage(
                          image: NetworkImage(
                              items.files.first
                                  .url),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )
                        :
                    Container(
                      height: 85.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: AppColors
                            .graySearch,
                        borderRadius:
                        BorderRadius
                            .circular(4.w),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
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
                        padding: EdgeInsets
                            .symmetric(
                            vertical: 4.h,
                            horizontal:
                            6.w),
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(
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
                        :
                    SizedBox()
                  ],
                ),
                WBox(12.w),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: Text(
                       items.category,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.w600),
                      ),
                    ),
                    HBox(6.h),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        items.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles
                            .body14Secondary
                            .copyWith(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          items.city,
                          style: AppTextStyles
                              .body14Secondary
                              .copyWith(
                              fontSize: 10,
                              color:
                              AppColors.grayDark),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          !notShowDetail?
          Column(
            children: [
              HBox(12.h),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Работ ${items.countCompletedWorks.toString()} | Отзывов ${items.countReview.toString()}',
                    style: AppTextStyles.body14Secondary
                        .copyWith(fontSize: 10),
                  ),
                  Row(
                    children: [
                      Text(
                        items.view.toString(),
                        style: AppTextStyles
                            .body14Secondary
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
          ) : const SizedBox(),
          isChat ?
          FutureBuilder(
              future: RestServices().getCountMessageByID(
                  type: "PUBLICATION", id: [items.id]),
              builder: (BuildContext context,
                  AsyncSnapshot snapshotCount) {
                if (snapshotCount.hasData) {
                  return snapshotCount.data[0]
                  ['countOfNewMessages'] !=
                      0
                      ? Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text(
                        'Новых сообщений',
                        style: AppTextStyles
                            .body14W500
                            .copyWith(
                            color:
                            AppColors.red),
                      ),
                      Text(
                        snapshotCount.data[0][
                        'countOfNewMessages']
                            .toString(),
                        style: AppTextStyles
                            .body14W500
                            .copyWith(
                            color:
                            AppColors.red),
                      ),
                    ],
                  )
                      : const SizedBox();
                } else {
                  return const SizedBox();
                }
              })
              : const SizedBox()
        ],
      ),
    );
  }
}
