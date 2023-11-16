import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class TaskCardView extends StatelessWidget {
  TaskModel items;
  bool notShowDescription;
  bool isChat;
  TaskCardView({Key? key, required this.items, this.notShowDescription = false, this.isChat = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(
                0, 1.h), // changes position of shadow
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
                    fit: BoxFit.fitWidth,
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
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    color: AppColors.black.withOpacity(0.5),
                  ),
                  child: Text("1/${items.files.length.toString()}",
                    style: AppTextStyles.captionPrimary.copyWith(color: AppColors.white),),
                ),
              ) : const SizedBox(),
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
              Text("до ${items.price.toInt().toString()} ₸",
                  style: AppTextStyles.body14Secondary),
            ],
          ),
          !notShowDescription?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          ) : const SizedBox(),
          isChat ?
          FutureBuilder(
              future: RestServices().getCountMessageByID(
                  type: "TASK", id: [items.id]),
              builder: (BuildContext context,
                  AsyncSnapshot snapshotCount) {
                if (snapshotCount.hasData) {
                  return snapshotCount.data[0]
                  ['countOfNewMessages'] !=
                      0
                      ? Column(
                        children: [
                          HBox(6.h),
                          Row(
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
