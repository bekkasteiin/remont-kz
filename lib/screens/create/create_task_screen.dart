import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';
import 'package:remont_kz/model/task/create_task_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/file_services.dart';
import 'package:remont_kz/utils/global_widgets/no_user.dart';
import 'package:remont_kz/utils/routes.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  TextEditingController description = TextEditingController();
  TextEditingController priceText = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController title = TextEditingController();
  ScrollController _scrollController = ScrollController();
  dynamic price;
  dynamic timesWork;
  CategoryElement? categories;
  CitiesModel? cities;
  List<FileDescriptor> files = [];
  bool isMoney = false;
  GlobalKey<FormState> _formKey = GlobalKey();

  var times = [
    'в течении 3х часов',
    'сегодня',
    'другой день',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tokenStore = getIt.get<TokenStoreService>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Создать задание',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: tokenStore.accessToken != null
          ? Form(
              key: _formKey,
              child: Listener(
                onPointerDown: (_) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.focusedChild?.unfocus();
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => getCategory(),
                          child: Container(
                            height: 44.h,
                            margin: EdgeInsets.all(8.w),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 1.w), // changes position of shadow
                                  ),
                                ],
                                color: AppColors.white),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/category.png',
                                  width: 25.w,
                                  height: 25.h,
                                  color: AppColors.blackGreyText,
                                ),
                                SizedBox(
                                  width: 24.w,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    categories?.name ?? 'Категория',
                                    style: AppTextStyles.body14W500,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 25.h,
                                      color: AppColors.blackGreyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => getCity(),
                          child: Container(
                            height: 44.h,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 1.w), // changes position of shadow
                                  ),
                                ],
                                color: AppColors.white),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_city,
                                  size: 32.w,
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  cities?.name ?? 'Город',
                                  style: AppTextStyles.body14W500,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 25.h,
                                      color: AppColors.blackGreyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            height: 44.h,
                            margin: EdgeInsets.all(8.w),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 1.w), // changes position of shadow
                                  ),
                                ],
                                color: AppColors.white),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/location.png',
                                  width: 25.w,
                                  height: 25.h,
                                  color: AppColors.blackGreyText,
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    controller: address,
                                    style: AppTextStyles.body14W500,
                                    onChanged: (val) {},
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Адрес работ',
                                      hintStyle: AppTextStyles.body14Secondary
                                          .copyWith(
                                              color: AppColors.primaryGray,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Заголовок',
                            style: AppTextStyles.body14W500,
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 1.w), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLength: 70,
                              maxLines: 3,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Заголовок не должен быть пустым");
                                }
                                if (value.length < 14) {
                                  return "Заголовок должен содержать минимум 14 символов";
                                }

                                return null;
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(70),
                              ],
                              controller: title,
                              onChanged: (val) {},
                              decoration: InputDecoration.collapsed(
                                hintText: 'Заголовок',
                                hintStyle: AppTextStyles.body14Secondary.copyWith(
                                    color: AppColors.primaryGray,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Описание работ',
                            style: AppTextStyles.body14Secondary,
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 1.w), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLines: 5,
                              maxLength: 5000,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Описание не должен быть пустым");
                                }
                                if (value.length < 50) {
                                  return "Описание должен содержать минимум 50 символов";
                                }

                                return null;
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5000),
                              ],
                              controller: description,
                              onChanged: (val) {},
                              decoration: InputDecoration.collapsed(
                                hintText:
                                    'Опишите, какие услуги вы можете предоставить',
                                hintStyle: AppTextStyles.body14Secondary.copyWith(
                                    color: AppColors.primaryGray,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Цена, тг',
                            style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isMoney = !isMoney;
                            setState(() {});
                            if(isMoney){
                              priceText.clear();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 12.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.w, vertical: 5.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                border: Border.all(color: AppColors.primary),
                                color: isMoney
                                    ? AppColors.primary
                                    : AppColors.white),
                            child: Text(
                              'договорная',
                              style: AppTextStyles.body14Secondary.copyWith(
                                  color: isMoney
                                      ? AppColors.white
                                      : AppColors.blackGreyText),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Или укажите свою цену',
                            style: AppTextStyles.bodySecondaryTen,
                          ),
                        ),
                        HBox(12.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 1.w),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'До',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              isMoney?
                              Expanded(
                                child: SizedBox(),
                              )
                              : Expanded(
                                child: TextFormField(
                                  readOnly: false,
                                  maxLines: 1,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[1-9][0-9]*$')),
                                  ],
                                  controller: priceText,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {},
                                  validator: (value) {
                                    if (value!.length < 4) {
                                      return "Минимальная цена 1000 тг";
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: '10 000',
                                    hintStyle: AppTextStyles.body14Secondary
                                        .copyWith(
                                            color: AppColors.primaryGray,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Text('₸'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Время работ',
                            style: AppTextStyles.body14Secondary,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: SizedBox(
                            height: 30.h,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: times.length,
                                itemBuilder: (_, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      timesWork = times[i];
                                      setState(() {});
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 7.w),
                                      margin: EdgeInsets.only(right: 10.w),
                                      decoration: BoxDecoration(
                                        color: timesWork != null &&
                                                timesWork == times[i]
                                            ? AppColors.primary
                                            : AppColors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(0,
                                                1.w), // changes position of shadow
                                          ),
                                        ],
                                        border:
                                            Border.all(color: AppColors.primary),
                                      ),
                                      child: Text(
                                        times[i],
                                        style: AppTextStyles.body14Secondary
                                            .copyWith(
                                                color: timesWork != null &&
                                                        timesWork == times[i]
                                                    ? AppColors.white
                                                    : AppColors.blackGreyText),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Добавьте фото',
                            style: AppTextStyles.body14Secondary,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => filePickerDialog(),
                                child: Container(
                                  width: 91.w,
                                  height: 108.h,
                                  margin: EdgeInsets.all(8.w),
                                  padding: EdgeInsets.all(22.w),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(
                                            0, 1.w), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColors.primary.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                  child: CircleAvatar(
                                    radius: 2,
                                    backgroundColor: AppColors.white,
                                    child: Image.asset(
                                      'assets/images/photo.png',
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: files.map((e) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 167.w,
                                        height: 108.h,
                                        margin: EdgeInsets.all(8.w),
                                        padding: EdgeInsets.all(22.w),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(e.url),
                                              fit: BoxFit.fill),
                                          color: AppColors.primary.withOpacity(0.6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: Offset(
                                                  0, 1.h), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border:
                                              Border.all(color: AppColors.primary),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            files.removeWhere((element) => element.url == e.url);
                                            setState(() {

                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {

                                if(categories==null){
                                  errorText(title: 'Выберите категорию', context: context);
                                }else if(cities == null){
                                  errorText(title: 'Выберите город', context: context);
                                }else if(address.text == ''){
                                  errorText(title: 'Заполните адрес работ', context: context);
                                }else if(timesWork == null){
                                  errorText(title: 'Выберите время работ', context: context);
                                }else{
                                  var send = await RestServices().createNewTask(
                                    TaskPublication(
                                        files: files,
                                        address: address.text.replaceAll(RegExp(r'\s+'), ' '),
                                        title: title.text.replaceAll(RegExp(r'\s+'), ' '),
                                        price: isMoney ? null : int.parse(priceText.text),
                                        city: cities,
                                        category: categories,
                                        status: "ACTIVATED",
                                        isContractual: isMoney ? true : null,
                                        id: null,
                                        description: description.text.replaceAll(RegExp(r'\s+'), ' '),
                                        workTime: timesWork),
                                  );
                                  if(send == 200){
                                    await Navigator.pushNamedAndRemoveUntil(
                                        context, AppRoutes.mainNav, (route) => true);
                                  }else{
                                    print('sdf');
                                  }


                                }

                              } else {}
                            },
                            child: Container(
                              height: 44.h,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(12.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.w),
                                  color: AppColors.primary),
                              child: Text(
                                'Опубликовать задание',
                                style: AppTextStyles.body14Secondary
                                    .copyWith(color: AppColors.white, fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ),
                        HBox(12.h),
                      ],
                    ),
                  ),
                ),
              ),
            )
          :  const NoAuthPageView(),
    );
  }

  void errorText({required String title, required BuildContext context}){
    return MotionToast.error(
      description:  Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      position: MotionToastPosition.top,
      layoutOrientation: ToastOrientation.ltr,
      animationType: AnimationType.fromTop,
      dismissable: true,
    ).show(context);
  }

  getCity() {
    showDialog(
      barrierColor: AppColors.transparent,
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
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            child: FutureBuilder(
                future: RestServices().getAllCities(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 100.w),
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            List<CitiesModel> model = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cities = model[index];
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Container(
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
                                const Divider()
                              ],
                            );
                          });
                }),
          ),
        ),
      ),
    );
  }

  getCategory() {
    showDialog(
        barrierColor: AppColors.transparent,
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
                  'Категории',
                  style: AppTextStyles.h18Regular,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  child: FutureBuilder(
                      future: RestServices().getCategory(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 100.w),
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  List<CategoryModel> model = snapshot.data;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4.h),
                                        child: Text(
                                          model[index].name,
                                          style: AppTextStyles.h3Regular
                                              .copyWith(
                                                  color: AppColors.primary),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            model[index].categories.map((e) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    categories = e;
                                                  });
                                                  Navigator.pop(context, true);
                                                },
                                                child: Container(
                                                  color: AppColors.transparent,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 4.h,
                                                        horizontal: 16.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                            child: Text(
                                                          e.name,
                                                          style: AppTextStyles
                                                              .body14Secondary,
                                                        )),
                                                        Icon(
                                                          Icons.arrow_forward_ios,
                                                          size: 12.w,
                                                          color: AppColors
                                                              .blackGreyText,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                            ],
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  );
                                });
                      }),
                ),
              ),
            ));
  }

  filePickerDialog() {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final file = await FileService.getImageCamera(context);

                    if (file != null) {
                      FileDescriptor upload =
                          await RestServices().uploadImageTask(File(file.path));
                      if (upload != null) {
                        files.add(upload);
                        setState(() {});
                      }
                    }
                  },
                  child: const Text('Камера')),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final file = await FileService.getImage(context);
                    if (file != null) {
                      FileDescriptor upload =
                          await RestServices().uploadImageTask(File(file.path));
                      if (upload != null) {
                        files.add(upload);
                        setState(() {});
                      }
                    }
                  },
                  child: const Text('Галерея')),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                'Отмена',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}
