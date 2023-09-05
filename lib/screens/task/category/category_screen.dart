// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/screens/task/category/category_publication_filter.dart';
import 'package:remont_kz/screens/task/category/category_task_filter.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';

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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
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
                               padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Text(model[index].name, style: AppTextStyles.h3Regular.copyWith(color: AppColors.primary),),
                              ),
                              Column(
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
                                          Navigator.push(context, MaterialPageRoute(builder: (_)=>GetTaskByCategoryId(category: e, toPrice: 0, fromPrice: 0, cityId: 0, isContractual: false,),),).then((value) => setState((){}))
                                           : Navigator.push(context, MaterialPageRoute(builder: (_)=>GetPublicationOrTaskByCategory(category: e, toPrice: 0, fromPrice: 0, cityId: 0, isContractual: false,),),).then((value) => setState((){}));
                                        },
                                        child: Container(
                                          color: AppColors.transparent,

                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
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
                                      const Divider(),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        });
              },),
        ),
      ),
    );
  }
}