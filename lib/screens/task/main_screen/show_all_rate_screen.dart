// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/publication/publication_review.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/date.dart';
import 'package:remont_kz/utils/global_widgets/full_screen_image.dart';

class ShowAllRateScreen extends StatefulWidget {
  String userName;
  ShowAllRateScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<ShowAllRateScreen> createState() => _ShowAllRateScreenState();
}

class _ShowAllRateScreenState extends State<ShowAllRateScreen> {
  var select;
  int selectedRating = 0;

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
      body:
      FutureBuilder(
        future: RestServices().getAllReviewByPublication(userName:
        widget.userName, categoryId: 0, rating: 0),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            PublicationReview model = snapshot.data;
            return ShowTopBar(model:model, userName: widget.userName);
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


class ShowTopBar extends StatefulWidget {
  String userName;
  PublicationReview model;
  ShowTopBar({Key? key, required this.model, required this.userName}) : super(key: key);

  @override
  State<ShowTopBar> createState() => _ShowTopBarState();
}

class _ShowTopBarState extends State<ShowTopBar> {
  CategoryElement select = CategoryElement();
  int selectedRating = 0;
  @override
  Widget build(BuildContext context) {
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
                      // Фильтр для показа всех отзывов
                      select = CategoryElement();
                      selectedRating = 0;
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.primary),
                          color: select.category==null
                              ? AppColors.primary
                              : AppColors.white),
                      child: Text('Все (${widget.model.commentsSize})',
                          style: AppTextStyles.body14W500.copyWith(
                              color: select.category == null
                                  ? AppColors.white
                                  : AppColors.blackGreyText)),
                    ),
                  ),
                ),
                ...widget.model.categories.map((category){
                  return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {

                              select = category;
                              selectedRating = 0;
                              setState(() {

                              });


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
                              child: Row(
                                children: [
                                  Text(category.category?.name ?? '',
                                    style: AppTextStyles.body14W500.copyWith(color: select == category
                                        ? AppColors.white
                                        : AppColors.blackGreyText),),
                                  Text("(${category.countComments})",
                                    style: AppTextStyles.body14W500.copyWith(color: select == category
                                        ? AppColors.white
                                        : AppColors.blackGreyText),),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }).toList()
              ],

            ),
          ),
          select.category== null
          ?
          Padding(
            padding: EdgeInsets.all(12.h),
            child:   Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.model.ratings.map((e) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = e.id;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: selectedRating == e.id
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
                          e.id == 1
                              ? 'assets/icons/emoji_angry.png'
                              : e.id == 2
                              ? 'assets/icons/emoji_good.png'
                              : 'assets/icons/emoji_best.png',
                          height: 47.h,
                          width: 47.w,
                        ),
                        HBox(
                          4.h,
                        ),
                        Text(
                          e.description,
                          style: AppTextStyles.body14W500.copyWith(
                              color:selectedRating == e.id
                                  ? AppColors.white
                                  : AppColors.blackGreyText),
                        ),
                        Text(
                          '(${e.count})',
                          style: AppTextStyles.body14W500.copyWith(
                              color:selectedRating == e.id
                                  ? AppColors.white
                                  : AppColors.blackGreyText),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
          : FutureBuilder(
              future: RestServices().getAllReviewByPublication(userName:
              widget.userName, categoryId: select.category?.id ?? 0, rating: 0),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  PublicationReview model = snapshot.data;
                  return Padding(
                    padding: EdgeInsets.all(12.h),
                    child:   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: model.ratings.map((e) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = e.id;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: selectedRating == e.id
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
                                  e.id == 1
                                      ? 'assets/icons/emoji_angry.png'
                                      : e.id == 2
                                      ? 'assets/icons/emoji_good.png'
                                      : 'assets/icons/emoji_best.png',
                                  height: 47.h,
                                  width: 47.w,
                                ),
                                HBox(
                                  4.h,
                                ),
                                Text(
                                  e.description,
                                  style: AppTextStyles.body14W500.copyWith(
                                      color:selectedRating == e.id
                                          ? AppColors.white
                                          : AppColors.blackGreyText),
                                ),
                                Text(
                                  '(${e.count})',
                                  style: AppTextStyles.body14W500.copyWith(
                                      color:selectedRating == e.id
                                          ? AppColors.white
                                          : AppColors.blackGreyText),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }else{
                  return  const AlertDialog(
                    content: CupertinoActivityIndicator(
                      color: AppColors.primary,
                      radius: 25,
                      animating: true,
                    ),
                  );

                }
              }),
          select.category==null
              ?
          selectedRating!=0
          ? FutureBuilder(
                  future: RestServices().getAllReviewByPublication(userName:
                  widget.userName, categoryId: 0, rating: selectedRating),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      PublicationReview model = snapshot.data;
                      return ShowAllRate(model: model.comments);
                    }else{
                      return  const AlertDialog(
                        content: CupertinoActivityIndicator(
                          color: AppColors.primary,
                          radius: 25,
                          animating: true,
                        ),
                      );
                    }
              })
         : ShowAllRate(model:
            widget.model.comments)
              : selectedRating!= 0
          ? FutureBuilder(
              future: RestServices().getAllReviewByPublication(userName:
              widget.userName, categoryId: select.category?.id ?? 0, rating: selectedRating),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  PublicationReview model = snapshot.data;
                  return ShowAllRate(model: model.comments);
                }else{
                  return  const AlertDialog(
                    content: CupertinoActivityIndicator(
                      color: AppColors.primary,
                      radius: 25,
                      animating: true,
                    ),
                  );
                }
              })
              : FutureBuilder(
              future: RestServices().getAllReviewByPublication(userName:
              widget.userName, categoryId: select.category?.id ?? 0, rating: 0),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  PublicationReview model = snapshot.data;
                  return ShowAllRate(model: model.comments);
                }else{
                 return  const AlertDialog(
                      content: CupertinoActivityIndicator(
                      color: AppColors.primary,
                      radius: 25,
                      animating: true,
                      ),
                  );
                }
              }),


        ],
      ),
    );
  }
}


class ShowAllRate extends StatefulWidget {
  List<Comment> model;

  ShowAllRate({Key? key, required this.model}) : super(key: key);

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
                blurRadius: 4,
                offset: Offset(0, 1.w), // changes position of shadow
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
                  e.rating == 3
                      ? Row(
                        children: [
                          Text(
                              'Отлично',
                              style: AppTextStyles.body14Secondary
                                  .copyWith(color: AppColors.primary),
                            ),
                          WBox(6.w),
                          Image.asset('assets/icons/emoji_best.png', width: 27.w, height: 27.h,)
                        ],
                      )
                      : e.rating == 2
                          ? Row(
                            children: [
                              Text(
                                  'Хорошо',
                                  style: AppTextStyles.body14Secondary.copyWith(
                                      color: AppColors.additionalGreenMedium),
                                ),
                              WBox(6.w),
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
                              WBox(6.w),
                              Image.asset('assets/icons/emoji_angry.png', width: 27.w, height: 27.h,)
                            ],
                          ),
                  Text(formatDate(e.createdDate), style: AppTextStyles.bodySecondaryTen,),
                ],
              ),
              HBox(
                12.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.grayCategory
                ),
                child: Text(e.category),
              ),
              HBox(
                12.h,
              ),
              Text(
                e.feedback,
                style: AppTextStyles.bodySecondaryTen
                    .copyWith(fontSize: 14.sp),
              ),
              SizedBox(
                height: 8.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: e.files.map((file) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImage(
                                files: e.files
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 94.w,
                        height: 84.h,
                        margin: EdgeInsets.only(
                            right: 16.w, top: 8.h, bottom: 4.h),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(
                                  0, 1.h), // changes position of shadow
                            ),
                          ],
                          image: DecorationImage(
                              image: NetworkImage(file.url),
                              fit: BoxFit.fill),
                          color: AppColors.primary.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary),
                        ),
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
                  e.authorFullName,
                  style: AppTextStyles.bodySecondaryTen,
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
//
// class FeedbackListScreen extends StatelessWidget {
//   final List<PublicationReview> feedbackItems;
//
//   FeedbackListScreen(this.feedbackItems);
//
//   @override
//   Widget build(BuildContext context) {
//     return feedbackItems.isNotEmpty ? ListView.builder(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: feedbackItems.length,
//       itemBuilder: (context, index) {
//         PublicationReview feedback = feedbackItems[index];
//         return Container(
//           margin: EdgeInsets.only(bottom: 8.h),
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4.w),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 0,
//                 blurRadius: 8,
//                 offset: Offset(0, 3.w), // changes position of shadow
//               ),
//             ],
//             color: AppColors.white,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   feedback.rating == 3
//                       ? Row(
//                         children: [
//                           Text(
//                               'Отлично',
//                               style: AppTextStyles.body14Secondary
//                                   .copyWith(color: AppColors.primary),
//                             ),
//                           Image.asset('assets/icons/emoji_best.png', width: 27.w, height: 27.h,)
//                         ],
//                       )
//                       : feedback.rating == 2
//                           ? Row(
//                             children: [
//                               Text(
//                                   'Хорошо',
//                                   style: AppTextStyles.body14Secondary.copyWith(
//                                       color: AppColors.additionalGreenMedium),
//                                 ),
//                               Image.asset('assets/icons/emoji_good.png', width: 27.w, height: 27.h,)
//                             ],
//                           )
//                           : Row(
//                             children: [
//                               Text(
//                                   'Плохо',
//                                   style: AppTextStyles.body14Secondary
//                                       .copyWith(color: AppColors.red),
//                                 ),
//                               Image.asset('assets/icons/emoji_angry.png', width: 27.w, height: 27.h,)
//                             ],
//                           ),
//                   Text(
//                       formatDate(feedback.createdDate ?? DateTime.now()) ?? ''),
//                 ],
//               ),
//               SizedBox(
//                 height: 12.h,
//               ),
//               Text(
//                 feedback.category ?? '',
//                 style: AppTextStyles.bodySecondary.copyWith(
//                     color: AppColors.blackGreyText,
//                     fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 feedback.feedback ?? '',
//                 style: AppTextStyles.bodySecondary
//                     .copyWith(color: AppColors.blackGreyText),
//               ),
//               SizedBox(
//                 height: 8.h,
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: feedback.files.map((file) {
//                     return Container(
//                       width: 94.w,
//                       height: 84.h,
//                       margin:
//                           EdgeInsets.only(right: 16.w, top: 8.h, bottom: 4.h),
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 0,
//                             blurRadius: 8,
//                             offset:
//                                 Offset(0, 3.h), // changes position of shadow
//                           ),
//                         ],
//                         image: DecorationImage(
//                             image: NetworkImage(file.url), fit: BoxFit.fill),
//                         color: AppColors.primary.withOpacity(0.6),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: AppColors.primary),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               SizedBox(
//                 height: 12.h,
//               ),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Text(
//                   feedback.authorFullName ?? '',
//                   style: AppTextStyles.bodySecondary
//                       .copyWith(color: AppColors.blackGreyText),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     ) : const Center(
//       child: Text('Нет данных'),
//     );
//   }
// }
