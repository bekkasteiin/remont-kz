// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/publication/publication_review.dart';
import 'package:remont_kz/screens/work_for_worker/chat/create_rate.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/date.dart';

class ShowAllRateScreen extends StatefulWidget {
  String userName;
  ShowAllRateScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<ShowAllRateScreen> createState() => _ShowAllRateScreenState();
}

class _ShowAllRateScreenState extends State<ShowAllRateScreen> {
  var select;
  var withFile;
  bool showWithImage = false;
  var tapFilter;
  var tapFilterRate;
  List<PublicationReview> filteredList = [];
  List<PublicationReview> filteredListRate = [];
  var carBodyType;

  List<TypeEmoji> typeEmojiList = [
    TypeEmoji(image: "assets/icons/emoji_best.png", name: 'Отлично', rate: 5),
    TypeEmoji(image: "assets/icons/emoji_good.png", name: 'Хорошо', rate: 4),
    TypeEmoji(image: "assets/icons/emoji_angry.png", name: 'Плохо', rate: 3),
  ];


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
          'Отзывы исполнителя',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: FutureBuilder(
        future: RestServices().getAllReviewByPublication(widget.userName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, List<PublicationReview>> feedbackByCategory = {};
            List<PublicationReview> model = snapshot.data;
            for (var feedback in model) {
              if (!feedbackByCategory.containsKey(feedback.category)) {
                feedbackByCategory[feedback.category!] = [];
              }
              feedbackByCategory[feedback.category]!.add(feedback);
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              select = 'Все ${model.length}';
                              filteredListRate = [];
                              filteredList = [];
                              tapFilter = null;
                              withFile = null;
                              carBodyType = null;
                              tapFilterRate = null;
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.primary),
                                  color: select == 'Все ${model.length}'
                                      ? AppColors.primary
                                      : AppColors.white),
                              child: Text('Все (${model.length})',
                                  style: AppTextStyles.body14W500.copyWith(color: select == 'Все ${model.length}'
                                      ? AppColors.white
                                      : AppColors.blackGreyText)),
                            ),
                          ),
                        ),
                        ...feedbackByCategory.keys.map((category) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                filteredListRate = [];
                                filteredList = [];
                                tapFilter = null;
                                withFile = null;
                                tapFilterRate = null;
                                carBodyType = null;
                                select = category;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border:
                                        Border.all(color: AppColors.primary),
                                    color: select == category
                                        ? AppColors.primary
                                        : AppColors.white),
                                child: Text(category,
                                style: AppTextStyles.body14W500.copyWith(color: select == category
                                ? AppColors.white
                                    : AppColors.blackGreyText),),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  select == null
                      ? ShowAllRate(
                          model: model,
                      showWithImage: showWithImage
                        )
                      : select == 'Все ${model.length}'
                          ? Column(
                            children: [

                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        withFile = 'Без фото';
                                        filteredList =model.where((element) => element.files.isEmpty).toList();
                                        showWithImage = false;
                                        tapFilter = true;
                                        carBodyType = null;
                                        tapFilterRate = null;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/2.4,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: AppColors.primary),
                                            color: withFile == 'Без фото'
                                                ? AppColors.primary
                                                : AppColors.white),
                                        child: Text('Без фото',
                                          style: AppTextStyles.body14W500.copyWith(color: withFile == 'Без фото'
                                              ? AppColors.white
                                              : AppColors.blackGreyText),),
                                      ),
                                    ),
                                    WBox(8.w),
                                    GestureDetector(
                                      onTap: () {
                                        withFile = 'C фото';
                                        filteredList =model.where((element) => element.files.isNotEmpty).toList();
                                        showWithImage = true;
                                        tapFilter = true;
                                        carBodyType = null;
                                        tapFilterRate = null;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/2.4,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: AppColors.primary),
                                            color: withFile == 'C фото'
                                                ? AppColors.primary
                                                : AppColors.white),
                                        child: Text('C фото',
                                          style: AppTextStyles.body14W500.copyWith(color: withFile == 'C фото'
                                              ? AppColors.white
                                              : AppColors.blackGreyText), ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.h),
                                child:   Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: typeEmojiList.map((e) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tapFilterRate = true;
                                          filteredListRate = filteredList.where((element) => element.rating == e.rate).toList();
                                          carBodyType = e;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8.w),
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: carBodyType == e
                                              ? AppColors.primary
                                              : AppColors.graySearch,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        height: 123.h,
                                        width: MediaQuery.of(context).size.width / 3.5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              e.image,
                                              height: 47.h,
                                              width: 47.w,
                                            ),
                                            HBox(
                                              4.h,
                                            ),
                                            Text(
                                              e.name,
                                              style: AppTextStyles.body14W500.copyWith(
                                                  color: carBodyType == e
                                                      ? AppColors.white
                                                      : AppColors.blackGreyText),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              HBox(12.h),
                              ShowAllRate(
                                  model: tapFilter != null ?
                                  tapFilterRate ==null ?
                                  filteredList : filteredListRate : model,
                                  showWithImage: showWithImage
                                ),
                            ],
                          )
                          : Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        withFile = 'Без фото';
                                        filteredList =feedbackByCategory[select]!.where((element) => element.files.isEmpty).toList();
                                        showWithImage = false;
                                        tapFilter = true;
                                        carBodyType = null;
                                        tapFilterRate = null;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/2.4,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: AppColors.primary),
                                            color: withFile == 'Без фото'
                                                ? AppColors.primary
                                                : AppColors.white),
                                        child: Text('Без фото',
                                          style: AppTextStyles.body14W500.copyWith(color: withFile == 'Без фото'
                                              ? AppColors.white
                                              : AppColors.blackGreyText),),
                                      ),
                                    ),
                                    WBox(8.w),
                                    GestureDetector(
                                      onTap: () {
                                        withFile = 'C фото';
                                        filteredList =feedbackByCategory[select]!.where((element) => element.files.isNotEmpty).toList();
                                        showWithImage = true;
                                        tapFilter = true;
                                        carBodyType = null;
                                        tapFilterRate = null;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/2.4,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: AppColors.primary),
                                            color: withFile == 'C фото'
                                                ? AppColors.primary
                                                : AppColors.white),
                                        child: Text('C фото',
                                          style: AppTextStyles.body14W500.copyWith(color: withFile == 'C фото'
                                              ? AppColors.white
                                              : AppColors.blackGreyText), ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                               Padding(
                                padding: EdgeInsets.all(12.h),
                                child:   Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: typeEmojiList.map((e) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tapFilterRate = true;
                                          filteredListRate = filteredList.where((element) => element.rating == e.rate).toList();
                                          carBodyType = e;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8.w),
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: carBodyType == e
                                              ? AppColors.primary
                                              : AppColors.graySearch,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        height: 123.h,
                                        width: MediaQuery.of(context).size.width / 3.5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              e.image,
                                              height: 47.h,
                                              width: 47.w,
                                            ),
                                            HBox(
                                              4.h,
                                            ),
                                            Text(
                                              e.name,
                                              style: AppTextStyles.body14W500.copyWith(
                                                  color: carBodyType == e
                                                      ? AppColors.white
                                                      : AppColors.blackGreyText),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              FeedbackListScreen(tapFilter!= null ?
                                  tapFilterRate!= null
                              ? filteredListRate :

                              filteredList : feedbackByCategory[select]!),
                            ],
                          )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ShowAllRate extends StatefulWidget {
  List<PublicationReview> model;
  bool showWithImage = false;

  ShowAllRate({Key? key, required this.model, required this.showWithImage}) : super(key: key);

  @override
  State<ShowAllRate> createState() => _ShowAllRateState();
}

class _ShowAllRateState extends State<ShowAllRate> {
  @override
  Widget build(BuildContext context) {
    return widget.model.isNotEmpty ? Column(
      children: widget.model.map((e) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 3.w), // changes position of shadow
              ),
            ],
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  e.rating == 5
                      ? Row(
                        children: [
                          Text(
                              'Отлично',
                              style: AppTextStyles.body14Secondary
                                  .copyWith(color: AppColors.primary),
                            ),
                          Image.asset('assets/icons/emoji_best.png', width: 27.w, height: 27.h,)
                        ],
                      )
                      : e.rating == 4
                          ? Row(
                            children: [
                              Text(
                                  'Хорошо',
                                  style: AppTextStyles.body14Secondary.copyWith(
                                      color: AppColors.additionalGreenMedium),
                                ),
                              Image.asset('assets/icons/emoji_good.png', width: 27.w, height: 27.h,)
                            ],
                          )
                          : Row(
                            children: [
                              Text(
                                  'Плохо',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(color: AppColors.red),
                                ),
                              Image.asset('assets/icons/emoji_angry.png', width: 27.w, height: 27.h,)
                            ],
                          ),
                  Text(formatDate(e.createdDate ?? DateTime.now()) ?? ''),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                e.category ?? '',
                style: AppTextStyles.bodySecondary.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                e.feedback ?? '',
                style: AppTextStyles.bodySecondary
                    .copyWith(color: AppColors.blackGreyText),
              ),
              SizedBox(
                height: 8.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: e.files.map((file) {
                    return Container(
                      width: 94.w,
                      height: 84.h,
                      margin: EdgeInsets.only(
                          right: 16.w, top: 8.h, bottom: 4.h),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(
                                0, 3.h), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                            image: NetworkImage(file.url),
                            fit: BoxFit.fill),
                        color: AppColors.primary.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  e.authorFullName ?? '',
                  style: AppTextStyles.bodySecondary
                      .copyWith(color: AppColors.blackGreyText),
                ),
              ),
            ],
          ),
        );
      }).toList() ,
    ) : const Center(
      child: Text('Нет данных'),
    );
  }
}

class FeedbackListScreen extends StatelessWidget {
  final List<PublicationReview> feedbackItems;

  FeedbackListScreen(this.feedbackItems);

  @override
  Widget build(BuildContext context) {
    return feedbackItems.isNotEmpty ? ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: feedbackItems.length,
      itemBuilder: (context, index) {
        PublicationReview feedback = feedbackItems[index];
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 3.w), // changes position of shadow
              ),
            ],
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  feedback.rating == 5
                      ? Row(
                        children: [
                          Text(
                              'Отлично',
                              style: AppTextStyles.body14Secondary
                                  .copyWith(color: AppColors.primary),
                            ),
                          Image.asset('assets/icons/emoji_best.png', width: 27.w, height: 27.h,)
                        ],
                      )
                      : feedback.rating == 4
                          ? Row(
                            children: [
                              Text(
                                  'Хорошо',
                                  style: AppTextStyles.body14Secondary.copyWith(
                                      color: AppColors.additionalGreenMedium),
                                ),
                              Image.asset('assets/icons/emoji_good.png', width: 27.w, height: 27.h,)
                            ],
                          )
                          : Row(
                            children: [
                              Text(
                                  'Плохо',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(color: AppColors.red),
                                ),
                              Image.asset('assets/icons/emoji_angry.png', width: 27.w, height: 27.h,)
                            ],
                          ),
                  Text(
                      formatDate(feedback.createdDate ?? DateTime.now()) ?? ''),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                feedback.category ?? '',
                style: AppTextStyles.bodySecondary.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                feedback.feedback ?? '',
                style: AppTextStyles.bodySecondary
                    .copyWith(color: AppColors.blackGreyText),
              ),
              SizedBox(
                height: 8.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: feedback.files.map((file) {
                    return Container(
                      width: 94.w,
                      height: 84.h,
                      margin:
                          EdgeInsets.only(right: 16.w, top: 8.h, bottom: 4.h),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset:
                                Offset(0, 3.h), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                            image: NetworkImage(file.url), fit: BoxFit.fill),
                        color: AppColors.primary.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  feedback.authorFullName ?? '',
                  style: AppTextStyles.bodySecondary
                      .copyWith(color: AppColors.blackGreyText),
                ),
              ),
            ],
          ),
        );
      },
    ) : const Center(
      child: Text('Нет данных'),
    );
  }
}
