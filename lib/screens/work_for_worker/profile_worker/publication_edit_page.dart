// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/publication/upload_publication_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/file_services.dart';
import 'package:remont_kz/utils/routes.dart';

class EditOrderScreen extends StatefulWidget {
  PublicationModel model;
  EditOrderScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  TextEditingController description = TextEditingController();
  TextEditingController priceText = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController title = TextEditingController();
  dynamic price;
  CategoryElement? categories;
  CitiesModel? cities;
  List<FileDescriptor> files = [];
  bool isMoney = false;
  late int cityIdSend;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
        ),
        title: Text(
          'Редактировать объявление',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Listener(
          onPointerDown: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                    height: 44.h,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 1.w),
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
                          width: 25.w,
                        ),
                        Expanded(
                          child: Text(
                            widget.model.category ?? 'Категория',
                            style: AppTextStyles.body14W500,
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
                  SizedBox(
                    height: 8.h,
                  ),
                  GestureDetector(
                    onTap: () => getCity(),
                    child: Container(
                      height: 44.h,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      alignment: Alignment.center,
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
                          borderRadius: BorderRadius.circular(4.w),
                          color: AppColors.white),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            size: 32.h,
                          ),
                          SizedBox(
                            width: 24.w,
                          ),
                          Text(
                            widget.model.city,
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
                      margin: EdgeInsets.only(
                          top: 8.h, left: 8.w, right: 8.w),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      alignment: Alignment.center,
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
                          borderRadius: BorderRadius.circular(4.w),
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
                            width: 24.w,
                          ),
                          Expanded(
                            child: TextFormField(
                              maxLines: null,
                              initialValue: widget.model.address,
                              onChanged: (val) {
                                widget.model.address = val;
                                setState(() {});
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: '',
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
                  SizedBox(
                    height: 12.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'Описание работ',
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
                          offset: Offset(
                              0, 1.w), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 5,
                        maxLength: 5000,
                        initialValue: widget.model.description,
                        style: AppTextStyles.body14Secondary
                            .copyWith(color: AppColors.primaryGray),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5000),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Описание не должен быть пустым");
                          }
                          if (value.length < 70) {
                            return "Описание должен содержать минимум 70 символов";
                          }

                          return null;
                        },
                        onChanged: (val) {
                          widget.model.description = val;
                          setState(() {});
                        },
                        decoration: InputDecoration.collapsed(
                          hintText:
                              'Опишите, какие услуги вы можете предоставить',
                          hintStyle: AppTextStyles.body14Secondary
                              .copyWith(
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
                      style: AppTextStyles.body14Secondary
                          .copyWith(color: AppColors.primaryGray),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.model.isContractual =
                          !widget.model.isContractual;
                      setState(() {});
                      if (widget.model.isContractual) {
                        priceText.clear();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 8.h, horizontal: 16.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          border: Border.all(color: AppColors.primary),
                          color: widget.model.isContractual
                              ? AppColors.primary
                              : AppColors.white),
                      child: Text(
                        'договорная',
                        style: AppTextStyles.body14Secondary.copyWith(
                            color: widget.model.isContractual
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
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 8.w, horizontal: 24.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(
                              0, 1.w), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text('От'),
                        SizedBox(
                          width: 24.w,
                        ),
                        widget.model.isContractual
                            ? const Expanded(
                                child: SizedBox(),
                              )
                            : Expanded(
                                child: TextFormField(
                                  maxLines: 1,
                                  initialValue: widget.model.price
                                      .toInt()
                                      .toString(),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[1-9][0-9]*$')),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.length < 4) {
                                      return "Минимальная цена 1000 тг";
                                    }

                                    return null;
                                  },
                                  onChanged: (val) {
                                    int price = int.parse(val);
                                    widget.model.price = price.toDouble();
                                    setState(() {});
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: '10 000',
                                    hintStyle: AppTextStyles
                                        .body14Secondary
                                        .copyWith(
                                            color: AppColors.primaryGray,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                        const Text('₸'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 12.w),
                    child: Text('Добавьте фото',
                        style: AppTextStyles.body14W500),
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
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            padding: EdgeInsets.all(22.w),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: Offset(0,
                                      1.w), // changes position of shadow
                                ),
                              ],
                              color: AppColors.primary.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppColors.primary),
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
                          children: widget.model.files.map((e) {
                            return Stack(
                              children: [
                                Container(
                                  width: 167.w,
                                  height: 108.h,
                                  margin: EdgeInsets.all(8.w),
                                  padding: EdgeInsets.all(22.w),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0,
                                            1.w), // changes position of shadow
                                      ),
                                    ],
                                    image: DecorationImage(
                                        image: NetworkImage(e.url),
                                        fit: BoxFit.fill),
                                    color: AppColors.primary
                                        .withOpacity(0.6),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.primary),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      files.removeWhere((element) =>
                                          element.url == e.url);
                                      setState(() {});
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
                  HBox(12.h),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (widget.model.category == null) {
                            errorText(
                                title: 'Выберите категорию', context: context);
                          }
                          else if (widget.model.city == null) {
                            errorText(title: 'Выберите город', context: context);
                          }
                          else if (widget.model.address == '') {
                            errorText(
                                title: 'Заполните адрес работ', context: context);
                          }else{
                            if (cities == null) {
                              List<CitiesModel> model =
                              await RestServices().getAllCities();
                              for (var cityId in model) {
                                if (cityId.name == widget.model.city) {
                                  setState(() {
                                    cityIdSend = cityId.id!;
                                  });
                                }
                              }
                            }
                            var createPublication =
                            await RestServices().editPublication(
                              EditPublication(
                                files: widget.model.files,
                                address: widget.model.address
                                    .replaceAll(RegExp(r'\s+'), ' '),
                                title: '',
                                price: widget.model.isContractual
                                    ? null
                                    : int.parse(
                                    widget.model.price.toInt().toString()),
                                cityId: cities?.id ?? cityIdSend,
                                categoryId: widget.model.categoryId,
                                status: "ACTIVATED",
                                isContractual:
                                widget.model.isContractual ? true : null,
                                id: widget.model.id,
                                description: widget.model.description
                                    .replaceAll(RegExp(r'\s+'), ' '),
                              ),
                            );
                            if (createPublication == 200) {
                              await Navigator.pushNamedAndRemoveUntil(context,
                                  AppRoutes.mainNavWorker, (route) => true);
                            } else {
                              MotionToast.error(
                                description: const Text(
                                  'Вы уже создали под этой категории объявление',
                                  style: TextStyle(fontSize: 12),
                                ),
                                position: MotionToastPosition.top,
                                layoutOrientation: ToastOrientation.ltr,
                                animationType: AnimationType.fromTop,
                                dismissable: true,
                              ).show(context);
                            }
                          }

                        } else {}
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
                          'Опубликовать объявление',
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
      ),
    );
  }

  void errorText({required String title, required BuildContext context}) {
    return MotionToast.error(
      description: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      position: MotionToastPosition.top,
      layoutOrientation: ToastOrientation.ltr,
      animationType: AnimationType.fromTop,
      dismissable: true,
    ).show(context);
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
                        await RestServices().uploadImage(File(file.path));
                    widget.model.files.add(upload);
                    setState(() {});
                  }
                },
                child: const Text('Камера'),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final file = await FileService.getImage(context);
                  if (file != null) {
                    FileDescriptor upload =
                        await RestServices().uploadImage(File(file.path));
                    if (upload != null) {
                      widget.model.files.add(upload);
                      setState(() {});
                    }
                  }
                },
                child: const Text('Галерея'),
              ),
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

  getCategory() {
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
            ),
          ),
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
              future: RestServices().getCategory(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 100.w),
                        child: const CircularProgressIndicator(),
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
                                child: Text(
                                  model[index].name,
                                  style: AppTextStyles.h3Regular
                                      .copyWith(color: AppColors.primary),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: model[index].categories.map((e) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            categories = e;
                                            widget.model.categoryId = e.id;
                                            widget.model.category = e.name;
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
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 12.w,
                                                  color:
                                                      AppColors.blackGreyText,
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
                              ),
                            ],
                          );
                        });
              },
            ),
          ),
        ),
      ),
    );
  }

  getCity() {
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
            ),
          ),
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
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cities = model[index];
                                  widget.model.city = cities?.name ?? '';
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
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CheckCategoryItem extends StatelessWidget {
  final dynamic checkCategoryPojo;
  final bool current;
  const CheckCategoryItem(this.checkCategoryPojo, this.current, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: current ? AppColors.primary.withOpacity(0.2) : null,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          checkCategoryPojo,
          style: AppTextStyles.body14Secondary,
        ),
        trailing: current
            ? const Icon(
                Icons.check_circle_outline,
                color: AppColors.primary,
              )
            : null,
      ),
    );
  }
}
