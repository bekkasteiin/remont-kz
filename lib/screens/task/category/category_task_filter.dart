import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/task/category/category_publication_filter.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class GetTaskByCategoryId extends StatefulWidget {
  CategoryElement category;
  int cityId;
  int fromPrice;
  int toPrice;
  bool isContractual;
  GetTaskByCategoryId({Key? key, required this.category, required this.toPrice, required this.fromPrice, required this.cityId, required this.isContractual}) : super(key: key);

  @override
  State<GetTaskByCategoryId> createState() => _GetTaskByCategoryIdState();
}

class _GetTaskByCategoryIdState extends State<GetTaskByCategoryId> {

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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> GetFilter(category: widget.category, task:  true,)));
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
      body: FutureBuilder(
        future: widget.fromPrice == 0 && !widget.isContractual ?RestServices().getAllPublicationByCategory(widget.category.id) : RestServices().getAllPublicationByCategoryFilter(widget.category.id,widget.cityId, widget.fromPrice, widget.toPrice, widget.isContractual),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<PublicationModel> model = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: model.length,
                itemBuilder: (context, index) {
                  PublicationModel items = model[index];
                  return SafeArea(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailWorkerScreen(
                              id: items.id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.h),
                        margin: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          color:  AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset:
                                  Offset(0, 3.h), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  items.user.fullName ?? '',
                                  style: AppTextStyles.h18Regular.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w400),
                                ),
                                GestureDetector(
                                    onTap: () async{
                                      if(items.favourite){
                                        await RestServices().deleteFavouritePublication(items.id.toString());
                                      }else{
                                        await RestServices().addFavourite(items.id.toString());
                                      }

                                      setState(() {

                                      });
                                    },
                                    child: Icon(
                                        items.favourite
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: items.favourite
                                            ? AppColors.primaryYellow
                                            : null))
                              ],
                            ),
                            HBox(5.h),
                            items.isContractual
                            ?
                            Text(
                              'договорная',
                              style: AppTextStyles.body14Secondary,
                            ):
                            Text(
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
                                                  BorderRadius.circular(4.w),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    items.files.first.url),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 85.h,
                                            width: 150.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.graySearch,
                                              borderRadius:
                                                  BorderRadius.circular(8.w),
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
                                    ?
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.h, horizontal: 16.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.w),
                                          color: AppColors.black.withOpacity(0.5),
                                        ),
                                        child: Text(
                                          "1/${items.files.length.toString()}",
                                          style: AppTextStyles.captionPrimary
                                              .copyWith(color: AppColors.white),
                                        ),
                                      ),
                                    ) : const SizedBox(),
                                  ],
                                ),
                                WBox(6.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items.category,
                                      style: AppTextStyles.body14Secondary
                                          .copyWith(fontWeight: FontWeight.w500),
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
                                )
                              ],
                            ),
                            HBox(12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            )
                          ],
                        ),
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
    );
  }


}

class GetFilter extends StatefulWidget {
  CategoryElement category;
  bool task;
  GetFilter({Key? key, required this.category, required this.task}) : super(key: key);

  @override
  State<GetFilter> createState() => _GetFilterState();
}

class _GetFilterState extends State<GetFilter> {
  CitiesModel? cities;
  dynamic timesWork;
  int fromPrice = 0;
  int toPrice = 0;
  bool isPrice = false;

  var price = [
    'от 1 000 до 5 000 ₸',
    'от 5 000 до 10 000 ₸',
    'от 10 000 до 25 000 ₸',
    'договорная',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),),
        centerTitle: true,
        title: Text(
          'Фильтр',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Показать сначала', style: AppTextStyles.body14W500.copyWith(fontWeight: FontWeight.w400, color: AppColors.primaryGray),),
              GestureDetector(
                onTap: (){
                  setState(() {

                  });
                  getCity();
                  setState(() {

                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Новый',
                      style: AppTextStyles.body14W500.copyWith(color: AppColors.primary),),
                    HBox(6.h),
                    Icon(Icons.arrow_forward_ios, color: AppColors.primary,)
                  ],
                ),
              ),
              HBox(12.h),
              Text('Регион', style: AppTextStyles.body14W500.copyWith(fontWeight: FontWeight.w400, color: AppColors.primaryGray),) ,
              GestureDetector(
                onTap: (){
                  setState(() {

                  });
                  getCity();
                  setState(() {

                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cities?.name ?? 'Выберите город',
                      style: AppTextStyles.body14W500.copyWith(color: AppColors.primary),),
                    HBox(6.h),
                    Icon(Icons.arrow_forward_ios, color: AppColors.primary,)
                  ],
                ),
              ),
              HBox(12.h),
              Text('Цена, тг', style: AppTextStyles.body14W500.copyWith(fontWeight: FontWeight.w400, color: AppColors.primaryGray),),
              HBox(6.h),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                children: price.map((e) => GestureDetector(
                    onTap: () {
                      isPrice = true;
              timesWork = e;
              setState(() {});
              },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  margin: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                    color: timesWork != null &&
                        timesWork == e
                        ? AppColors.primary
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0,
                            3), // changes position of shadow
                      ),
                    ],
                    border:
                    Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    e,
                    style: AppTextStyles.body14Secondary
                        .copyWith(
                        color: timesWork != null &&
                            timesWork == e
                            ? AppColors.white
                            : AppColors.blackGreyText),
                  ),
                ),
              ),
                ).toList(),
              ),
              HBox(12.h),
              Text('Или укажите свою цену', style: AppTextStyles.body14W500.copyWith(fontWeight: FontWeight.w400, color: AppColors.primaryGray),),
              HBox(10.h),
              Row(
                children: [
                  Text('От', style: AppTextStyles.body14W500.copyWith(fontWeight: FontWeight.w400, color: AppColors.primaryGray),),
                  WBox(10.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.h),
                      border: Border.all(color: AppColors.primary, width: 1.h)
                    ),
                    width: 80.w,
                    height: 24.h,
                    child: TextField(
                      readOnly: isPrice ? true : false,
                      decoration: InputDecoration.collapsed(

                        hintText: '',
                        hintStyle: AppTextStyles.body14Secondary.copyWith(
                            color: AppColors.primaryGray,
                            fontWeight: FontWeight.w400),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        fromPrice = int.parse(val);
                      },
                    ),
                  ),
                  WBox(10.w),
                  Text('До', style: AppTextStyles.body14W500.copyWith(fontWeight: FontWeight.w400, color: AppColors.primaryGray),),
                  WBox(10.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.h),
                        border: Border.all(color: AppColors.primary, width: 1.h)
                    ),
                    width: 80.w,
                    height: 24.h,
                    child: TextField(
                      readOnly: isPrice ? true : false,
                      decoration: InputDecoration.collapsed(

                        hintText: '',
                        hintStyle: AppTextStyles.body14Secondary.copyWith(
                            color: AppColors.primaryGray,
                            fontWeight: FontWeight.w400),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        toPrice = int.parse(val);
                      },
                    ),
                  ),
                ],
              ),
              HBox(24.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GestureDetector(
                  onTap: () async {
                    widget.task?
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>
                       GetTaskByCategoryId(category: widget.category, toPrice:

                       timesWork == 'от 1 000 до 5 000 ₸'?
                           5000
                       : timesWork == 'от 5 000 до 10 000 ₸'
                           ? 10000
                       : timesWork == 'от 10 000 до 25 000 ₸'
                           ? 25000
                       :toPrice, fromPrice:
                       timesWork == 'от 1 000 до 5 000 ₸'?
                       1000
                           : timesWork == 'от 5 000 до 10 000 ₸'
                           ? 5000
                           : timesWork == 'от 10 000 до 25 000 ₸'
                           ? 10000:

                       fromPrice, cityId: cities?.id ?? 0,
                   isContractual: isPrice ? timesWork == 'договорная' ? true : false : false)),)
                    :Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>
                        GetPublicationOrTaskByCategory(category: widget.category, toPrice:

                        timesWork == 'от 1 000 до 5 000 ₸'?
                        5000
                            : timesWork == 'от 5 000 до 10 000 ₸'
                            ? 10000
                            : timesWork == 'от 10 000 до 25 000 ₸'
                            ? 25000
                            :toPrice, fromPrice:
                        timesWork == 'от 1 000 до 5 000 ₸'?
                        1000
                            : timesWork == 'от 5 000 до 10 000 ₸'
                            ? 5000
                            : timesWork == 'от 10 000 до 25 000 ₸'
                            ? 10000:

                        fromPrice, cityId: cities?.id ?? 0,
                            isContractual: isPrice ? timesWork == 'договорная' ? true : false : false)),);


                  },
                  child: Container(
                    height: 40.h,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        color: AppColors.primary),
                    child: Text(
                      'Показать результаты',
                      style: AppTextStyles.body14Secondary
                          .copyWith(color: AppColors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  getCity(){
    showDialog(
        context: context,
        builder: (_) => Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.white,
                )),
            centerTitle: true,
            title: Text(
              'Город',
              style: AppTextStyles.h18Regular,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.h, horizontal: 12.w),
              child: FutureBuilder(
                  future: RestServices().getAllCities(),
                  builder: (BuildContext context,
                      AsyncSnapshot snapshot) {
                    return snapshot.connectionState ==
                        ConnectionState.waiting
                        ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100.w),
                      child: CircularProgressIndicator(),
                    )
                        : ListView.builder(
                        physics:
                        NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                        snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          List<CitiesModel> model =
                              snapshot.data;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cities = model[index];
                                  setState(() {});
                                  setState(() {

                                  });
                                  Navigator.pop(context, true);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      model[index].name ?? '',
                                      style: AppTextStyles
                                          .body14Secondary,
                                    ),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),

                              ),
                              const Divider(),
                            ],
                          );
                        });
                  }),
            ),
          ),
        )
    );
  }
}

