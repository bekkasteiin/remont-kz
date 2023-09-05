import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/task/category/category_task_filter.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class GetPublicationOrTaskByCategory extends StatefulWidget {
  CategoryElement category;
  int cityId;
  int fromPrice;
  int toPrice;
  bool isContractual;
  GetPublicationOrTaskByCategory({Key? key, required this.category, required this.toPrice, required this.fromPrice, required this.cityId, required this.isContractual}) : super(key: key);

  @override
  State<GetPublicationOrTaskByCategory> createState() => _GetPublicationOrTaskByCategoryState();
}

class _GetPublicationOrTaskByCategoryState extends State<GetPublicationOrTaskByCategory> {
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
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> GetFilter(category: widget.category, task: false,)));
              },
              child: Image.asset('assets/icons/filter.png',
                width: 20.w,
                height: 17.h,),
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          widget.category.name,
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: widget.fromPrice == 0 && !widget.isContractual ?RestServices().getAllTaskByCategory(widget.category.id) : RestServices().getAllTaskByCategoryFilter(widget.category.id,widget.cityId, widget.fromPrice, widget.toPrice, widget.isContractual),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<TaskModel> model = snapshot.data;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: model.length,
                  itemBuilder: (context, index) {
                    TaskModel items = model[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailTaskScreen(
                              id: items.id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.w),
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                items.files.isNotEmpty
                                    ? Container(
                                        height: 146.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.w),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                items.files.first.url),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 146.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.w),
                                            color: AppColors.graySearch),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.w),
                                      color: AppColors.black.withOpacity(0.5),
                                    ),
                                    child: Text("1/${items.files.length.toString()}",
                                      style: AppTextStyles.captionPrimary.copyWith(color: AppColors.white),),
                                  ),
                                ) : SizedBox(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Категория',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(color: AppColors.primaryGray),
                                ),
                                Text(items.category,
                                    style: AppTextStyles.body14Secondary),
                              ],
                            ),
                            HBox(6.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Стоимость работ',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(color: AppColors.primaryGray),
                                ),
                                items.isContractual ?
                                Text("договорная",
                                    style: AppTextStyles.body14Secondary)
                                :
                                Text("${items.price.toInt().toString()} ₸",
                                    style: AppTextStyles.body14Secondary),
                              ],
                            ),
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
        ),
      ),
    );
  }
}
