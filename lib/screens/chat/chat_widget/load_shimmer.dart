import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class LoadSimmer extends StatelessWidget {
  const LoadSimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomWidget.rectangular(
                  height: 14.w,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                CustomWidget.rectangular(
                  height: 14.w,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ],
            ),
          ),
          Divider(
            height: 1.w,
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                child: Row(
                  children: [
                    CustomWidget.circular(height: 32.w, width: 32.w),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomWidget.rectangular(
                              height: 12.w,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                          SizedBox(
                            height: 8.w,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: CustomWidget.rectangular(
                                height: 10.w,
                                width: MediaQuery.of(context).size.width * 0.6,
                              )),
                          SizedBox(
                            height: 8.w,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomWidget.rectangular(
                              height: 10.w,
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      child: CustomWidget.circular(height: 24.w, width: 24.w),
                    )
                  ],
                ),
              );
            },
            itemCount: 10,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 1.w,
              );
            },
          )
        ],
      ),
    );
  }
}

class LoadShimmerPublication extends StatelessWidget {
  const LoadShimmerPublication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child:Container(
              padding: EdgeInsets.all(12.h),
              margin: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 1.h), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidget.rectangular(
                        height: 12.w,
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                      GestureDetector(
                        child: const Icon(Icons.star_border,
                            color: AppColors.primaryYellow),
                      ),
                    ],
                  ),
                  HBox(5.h),
                  CustomWidget.rectangular(
                    height: 12.w,
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  HBox(12.h),
                  Row(
                    children: [
                      Stack(
                        children: [
                          CustomWidget.rectangular(
                            height: 85.w,
                            width: 140.w,
                          ),
                        ],
                      ),
                      WBox(10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget.rectangular(
                            height: 12.w,
                            width: 50.w,
                          ),
                          HBox(16.h),
                          SizedBox(
                            width: 50.w,
                            child: CustomWidget.rectangular(
                              height: 12.w,
                              width: 50.w,
                            ),
                          ),
                          HBox(4.h),
                          CustomWidget.rectangular(
                            height: 12.w,
                            width: 50.w,
                          ),
                        ],
                      )
                    ],
                  ),
                  HBox(12.h),
                ],
              ),
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomWidget.rectangular(
      {this.width = double.infinity, required this.height})
      : shapeBorder = const RoundedRectangleBorder();

  const CustomWidget.circular(
      {this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: AppColors.primary.withOpacity(0.2),
        highlightColor: Colors.grey.shade300,
        period: Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[400],
            shape: shapeBorder,
          ),
        ),
      );
}
