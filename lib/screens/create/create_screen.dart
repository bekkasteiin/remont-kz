import 'dart:io';

import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/global_widgets/file_services.dart';
import 'package:remont_kz/utils/main_list.dart';
import 'package:remont_kz/utils/routes.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  TextEditingController description = TextEditingController();
  TextEditingController priceText = TextEditingController();
  TextEditingController city = TextEditingController();
  dynamic price;
  dynamic categories;
  List<File> files = [];

  var model = [
    'от 1 000 ₸',
    'от 5 000 ₸',
    'договорная',
  ];

  var category = [
    'Строитель',
    'Сантехника',
    'Электрик',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondBackGround,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Создать объявление',
            style: AppTextStyles.h18Regular,
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => getAllVaccines(),
              child: Container(
                  margin: EdgeInsets.all(8.w),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(2.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      color: AppColors.white),
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/category.png',
                      width: 25,
                      height: 25,
                      color: AppColors.blackGreyText,
                    ),
                    title: Text(
                      categories ?? 'Категория',
                      style: AppTextStyles.body14Secondary,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 25.h,
                      color: AppColors.blackGreyText,
                    ),
                  )),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                  margin: EdgeInsets.all(8.w),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(2.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      color: AppColors.white),
                  child: ListTile(
                      leading: Image.asset(
                        'assets/images/location.png',
                        width: 25,
                        height: 25,
                        color: AppColors.blackGreyText,
                      ),
                      title: TextField(
                        maxLines: null,
                        controller: city,
                        onChanged: (val) {},
                        decoration: InputDecoration.collapsed(
                          hintText: 'Адрес работ',
                          hintStyle: AppTextStyles.body14Secondary.copyWith(
                              color: AppColors.primaryGray,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      trailing: Text(
                        '| Карта',
                        style: AppTextStyles.body14Secondary,
                      ))),
            ),
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Text(
                'Описание работ',
                style: AppTextStyles.body14Secondary.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null,
                  controller: description,
                  onChanged: (val) {},
                  decoration: InputDecoration.collapsed(
                    hintText: 'Опишите, какие услуги вы можете предоставить',
                    hintStyle: AppTextStyles.body14Secondary.copyWith(
                        color: AppColors.primaryGray,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12),
              child: Text(
                'Цена, тг',
                style: AppTextStyles.body14Secondary
                    .copyWith(color: AppColors.primaryGray),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                child: SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: model.length,
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () {
                            price = model[i];
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.w),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: price != null && price == model[i]
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(
                              model[i],
                              style: AppTextStyles.body14Secondary.copyWith(
                                  color: price != null && price == model[i]
                                      ? AppColors.white
                                      : AppColors.blackGreyText),
                            ),
                          ),
                        );
                      }),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
              child: Text(
                'Или укажите свою цену',
                style: AppTextStyles.body14Secondary
                    .copyWith(color: AppColors.primaryGray),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: ListTile(
                leading: Text('От'),
                title: TextField(
                  maxLines: null,
                  controller: priceText,
                  onChanged: (val) {},
                  decoration: InputDecoration.collapsed(
                    hintText: '10 000',
                    hintStyle: AppTextStyles.body14Secondary.copyWith(
                        color: AppColors.primaryGray,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                trailing: Text('₸'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              child: Text(
                'Добавьте фото',
                style: AppTextStyles.body14Secondary.copyWith(
                    color: AppColors.blackGreyText,
                    fontWeight: FontWeight.w500),
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
                    children: files.map((e){
                      return Container(
                        width: 167.w,
                        height: 108.h,
                        margin: EdgeInsets.all(8.w),
                        padding: EdgeInsets.all(22.w),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(e), fit: BoxFit.fill),
                          color: AppColors.primary.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
              child: GestureDetector(
                onTap: () async {
                  createTaskList.add(MainList(
                      name: categories,
                      description: description.text,
                      image: files.first,
                      fullName: 'Test test',
                      price: price,
                      street: city.text,
                      city: city.text,
                      isFav: false));
                  await Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.mainNav, (route) => true);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(12.w),
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
          ],
        ),
      ),
    );
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
                      files.add(File(file.path));
                      setState(() {});
                    }
                  },
                  child: const Text('Камера')),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final file = await FileService.getImage(context);
                    if (file != null) {
                      files.add(File(file.path));
                      setState(() {});
                    }
                  },
                  child: const Text('Галерея')),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                'Отменв',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  getAllVaccines() {
    var size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 0.6,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
            color: Colors.transparent,
            height: size.height * 0.5,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 5,
                    width: size.width / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary.withOpacity(0.4),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    'Выберите категорию из списка',
                    style: AppTextStyles.body14Secondary
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, i) {
                          var current = false;
                          if (categories != null) {
                            current = category[i] == categories;
                          }
                          return InkWell(
                            child: CheckCategoryItem(category[i], current),
                            onTap: () => setState(() {
                              if (!current) {
                                categories = category[i];
                              }
                              Navigator.pop(context);
                            }),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                              height: 1,
                            ),
                        itemCount: category.length),
                  ),
                ),
              ],
            ),
          );
        });
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
