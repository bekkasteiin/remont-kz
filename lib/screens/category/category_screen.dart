// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/screens/category/category_publication_filter.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';

import 'category_task_filter.dart';

class CategoriesScreen extends StatefulWidget {
  bool isClient = false;
  CategoryElement? model;
  bool? isTap = false;
  bool showLeading = false;
  CategoriesScreen({Key? key, this.model, this.isTap, required this.showLeading, this.isClient = false}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future _future;
  late RestServices api;

  @override
  void initState() {
    api = RestServices();
    _future = api.getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.showLeading ? IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios,
        color: AppColors.white,),)
        : const SizedBox(),
        centerTitle: true,
        title: Text(
          'Категории',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100.w),
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        List<CategoryModel> model = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                             padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 24.w),
                              child: Text(model[index].name, style: AppTextStyles.h3Regular.copyWith(color: AppColors.primary),),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 36.w,right: 14.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: model[index].categories.map((e){
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          if(widget.isTap == true){
                                            setState(() {
                                              widget.model = e;
                                            });
                                            Navigator.pop(context, true);
                                          }
                                          widget.isClient?
                                          Navigator.push(context, MaterialPageRoute(builder: (_)=> GetTaskByCategoryId(category: e,),),)
                                           : Navigator.push(context, MaterialPageRoute(builder: (_)=>GetPublicationOrTaskByCategory(category: e),),);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 8.h),
                                          color: AppColors.transparent,

                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 4.h,),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(child: Text(e.name, style: AppTextStyles.body14Secondary,)),
                                                Icon(Icons.arrow_forward_ios, size: 12.w, color: AppColors.blackGreyText,),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 0.2.h,
                                        width: MediaQuery.of(context).size.width,
                                        color: AppColors.primaryGray,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      });
            },),
      ),
    );
  }
}