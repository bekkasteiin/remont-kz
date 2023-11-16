import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/publication_card_view.dart';

class GetTaskByCategoryId extends StatefulWidget {
  CategoryElement category;
  GetTaskByCategoryId({Key? key, required this.category}) : super(key: key);

  @override
  State<GetTaskByCategoryId> createState() => _GetTaskByCategoryIdState();
}

class _GetTaskByCategoryIdState extends State<GetTaskByCategoryId> {
  CitiesModel? cities;
  dynamic timesWork;
  bool listFilter = false;
  int fromPrice = 0;
  int toPrice = 0;
  bool isPrice = false;
  String sortText = 'Новые';

  var sortBy = ['Новые', 'Дешёвые', 'Дорогие'];

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () async {
                setState(() {});
                listFilter = await getCategory();
                setState(() {});
              },
              child: Image.asset(
                'assets/icons/filter.png',
                width: 20.w,
                height: 17.h,
              ),
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
        future: !listFilter
            ? RestServices().getAllPublicationByCategory(widget.category.id)
            : RestServices().getAllPublicationByCategoryFilter(
                categoryId: widget.category.id,
                cityId: cities?.id ?? 0,
                fromPrice: timesWork == 'от 1 000 до 5 000 ₸'
                    ? 1000
                    : timesWork == 'от 5 000 до 10 000 ₸'
                        ? 5000
                        : timesWork == 'от 10 000 до 25 000 ₸'
                            ? 10000
                            : fromPrice,
                toPrice: timesWork == 'от 1 000 до 5 000 ₸'
                    ? 5000
                    : timesWork == 'от 5 000 до 10 000 ₸'
                        ? 10000
                        : timesWork == 'от 10 000 до 25 000 ₸'
                            ? 25000
                            : toPrice,
                isContractual: isPrice
                    ? timesWork == 'договорная'
                        ? true
                        : false
                    : false,
                sorting: sortText == 'Новые'
                    ? 'NEW'
                    : sortText == 'Дешёвые'
                        ? 'CHEAP'
                        : 'EXPENSIVE',
              ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<PublicationModel> model = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: model.length,
                itemBuilder: (context, index) {
                  PublicationModel items = model[index];
                  return SafeArea(
                    child: Column(
                      children: [
                        GestureDetector(
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
                          child: PublicationCardView(
                            items: items,
                            showStar: true,
                            onTap: () async {
                              if (items.favourite) {
                                await RestServices().deleteFavouritePublication(
                                    items.id.toString());
                              } else {
                                await RestServices()
                                    .addFavourite(items.id.toString());
                              }

                              setState(() {});
                            },
                          ),
                        ),
                        HBox(12.h),
                      ],
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

  Future<CitiesModel?> selectCity(BuildContext context) async {
    return await showDialog<CitiesModel>(
      context: context,
      barrierColor: AppColors.transparent,
      builder: (_) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Город',
            style: AppTextStyles.h18Regular,
          ),
        ),
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: FutureBuilder(
                future: RestServices()
                    .getAllCities(), // Replace with your API call
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 100.h),
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            List<CitiesModel> model = snapshot.data;
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cities = model[index];
                                    setState(() {});
                                    Navigator.pop(context, cities);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.h),
                                    color: AppColors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          model[index].name ?? '',
                                          style: AppTextStyles.body14Secondary,
                                        ),
                                        const Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 0.1.h,
                                  color: AppColors.grayDark,
                                ),
                              ],
                            );
                          },
                        );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  getCategory() async {
    return await showDialog(
        barrierColor: AppColors.transparent,
        context: context,
        builder: (_) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.white,
                ),
              ),
              centerTitle: true,
              title: Text(
                'Фильтр',
                style: AppTextStyles.h18Regular,
              ),
            ),
            body: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Показать сначала',
                        style: AppTextStyles.body14W500.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryGray),
                      ),
                      HBox(6.h),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height / 3.5,
                                minHeight:
                                    MediaQuery.of(context).size.height / 3.5,
                                minWidth: MediaQuery.of(context).size.width),
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.h),
                                topRight: Radius.circular(16.h),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            isScrollControlled: false,
                            isDismissible: true,
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Показать сначала',
                                            style: AppTextStyles.h18Regular
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .blackGreyText),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Icon(Icons.close))
                                        ],
                                      ),
                                    ),
                                    HBox(8.h),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: sortBy.map((e) {
                                        return GestureDetector(
                                          onTap: () {
                                            sortText = e;
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 8.h),
                                            color: e == sortText
                                                ? AppColors.primary
                                                    .withOpacity(0.1)
                                                : Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  e,
                                                  style: AppTextStyles
                                                      .h18Regular
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .blackGreyText),
                                                ),
                                                e == sortText
                                                    ? const Icon(
                                                        Icons.arrow_forward_ios)
                                                    : const SizedBox()
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).then((value) => setState(() {}));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          color: AppColors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sortText,
                                style: AppTextStyles.body14W500
                                    .copyWith(color: AppColors.primary),
                              ),
                              HBox(6.h),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      HBox(12.h),
                      Text(
                        'Регион',
                        style: AppTextStyles.body14W500.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryGray),
                      ),
                      HBox(6.h),
                      GestureDetector(
                        onTap: () async {
                          final selectedCity = await selectCity(context);
                          if (selectedCity != null) {
                            cities = selectedCity;
                            setState(() {});
                          }
                        },
                        child: Container(
                          color: AppColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cities?.name ?? 'Выберите город',
                                style: AppTextStyles.body14W500
                                    .copyWith(color: AppColors.primary),
                              ),
                              HBox(6.h),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      HBox(12.h),
                      Text(
                        'Цена, тг',
                        style: AppTextStyles.body14W500.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryGray),
                      ),
                      HBox(6.h),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: price
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  if(timesWork ==e){
                                    isPrice = false;
                                    timesWork = null;
                                    fromPrice = 0;
                                    toPrice = 0;
                                  }else{
                                    isPrice = true;
                                    timesWork = e;
                                    fromPrice = 0;
                                    toPrice = 0;
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  margin: EdgeInsets.only(right: 4.w),
                                  decoration: BoxDecoration(
                                    color: timesWork != null && timesWork == e
                                        ? AppColors.primary
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0,
                                            1.w), // changes position of shadow
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
                            )
                            .toList(),
                      ),
                      HBox(12.h),
                      Text(
                        'Или укажите свою цену',
                        style: AppTextStyles.body14W500.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryGray),
                      ),
                      HBox(10.h),
                      Row(
                        children: [
                          Text(
                            'От',
                            style: AppTextStyles.body14W500.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryGray),
                          ),
                          WBox(10.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.h),
                                border: Border.all(
                                    color: AppColors.primary, width: 1.h)),
                            width: 80.w,
                            height: 24.h,
                            child: !isPrice
                            ? TextField(
                              decoration: InputDecoration.collapsed(
                                hintText: '',
                                hintStyle: AppTextStyles.body14Secondary
                                    .copyWith(
                                        color: AppColors.primaryGray,
                                        fontWeight: FontWeight.w400),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                fromPrice = int.parse(val);
                              },
                            ) :SizedBox(),
                          ),
                          WBox(10.w),
                          Text(
                            'До',
                            style: AppTextStyles.body14W500.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryGray),
                          ),
                          WBox(10.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.h),
                                border: Border.all(
                                    color: AppColors.primary, width: 1.h)),
                            width: 80.w,
                            height: 24.h,
                            child:  !isPrice ?
                            TextField(
                              decoration: InputDecoration.collapsed(
                                hintText: '',
                                hintStyle: AppTextStyles.body14Secondary
                                    .copyWith(
                                        color: AppColors.primaryGray,
                                        fontWeight: FontWeight.w400),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                toPrice = int.parse(val);
                              },
                            ) : SizedBox(),
                          ),
                        ],
                      ),
                      HBox(24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {});
                            Navigator.pop(context, true);
                            setState(() {});
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
                              style: AppTextStyles.body14Secondary.copyWith(
                                  color: AppColors.white, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
