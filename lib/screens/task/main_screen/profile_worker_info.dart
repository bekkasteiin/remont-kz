import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/publication/publication_review.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/screens/task/main_screen/show_all_rate_screen.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/date.dart';

class ProfilePersonInfo extends StatefulWidget {
  String username;
  ProfilePersonInfo({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfilePersonInfo> createState() => _ProfilePersonInfoState();
}

class _ProfilePersonInfoState extends State<ProfilePersonInfo> {
  List<PublicationReview> reviewModels = [];
  List<PublicationModel> modelPubl = [];
  GetProfile profile = GetProfile();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loadProfile = await RestServices().getMyProfile();
        final reviewModelRev =await RestServices().getAllReviewByPublication(widget.username);

        if (mounted) {
          setState(() {
            reviewModels = reviewModelRev;
            profile = loadProfile;
          });
        }
      } catch (e) {
        // Handle any errors that might occur during the network request.
        print("Error fetching publication: $e");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: RestServices().getProfileByUsername(userName: widget.username),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            GetProfile profile = snapshot.data;
            print(profile.isClient);
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  profile.isClient! ? 'Профиль заказчика' : 'Профиль исполнителя',
                  style: AppTextStyles.h18Regular,
                ),
                leading: GestureDetector(
                  onTap: ()=>Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: AppColors.white,),
                ),
                centerTitle: true,
              ),
              body:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HBox(24.h),
                  if (profile.photoUrl!= null) Center(
                    child: CircleAvatar(
                      radius: 75.w,
                      backgroundImage: NetworkImage(profile.photoUrl),
                    ),
                  ) else Center(
                    child: CircleAvatar(
                      radius: 75.w,
                    ),
                  ),
                  HBox(12.h),
                  Center(
                    child: Text(
                      '${profile.name ?? ''} ${profile.lastname ?? ''}',
                      style: AppTextStyles.h18Regular.copyWith(color: AppColors.blackGreyText),),
                  ),
                  !profile.isClient!
                  ? HBox(12.h) : SizedBox(),
                  !profile.isClient!
                  ?
                  Center(
                    child: Text(
                      'Работ ${modelPubl.length} |Отзывы (${reviewModels.length})',
                      style: AppTextStyles.body14W500.copyWith(color: AppColors.blackGreyText),),
                  ) : SizedBox(),
                  HBox(12.h),
                  !profile.isClient!
                      ? isWorker(profile)
                      : isClients(profile)
                ],
              ),
            ),
            );
          }else{
            return const Center(child: CircularProgressIndicator(),);
          }
        });
  }


  Widget isWorker(GetProfile profile){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'О исполнителе',
            style: AppTextStyles.body14Secondary
                .copyWith(color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        HBox(12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          height: 150.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 3.w), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              maxLines: 10,
              onChanged: (val) {},
              decoration: InputDecoration.collapsed(
                hintText: profile.aboutMe ?? '',
                hintStyle: AppTextStyles.body14Secondary.copyWith(
                    color: AppColors.primaryGray, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
        HBox(12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'Объявления исполнителя',
            style: AppTextStyles.body14Secondary
                .copyWith(color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        HBox(12.h),
        myPublications(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: getReview(),
        ),
      ],
    );
  }


  Widget isClients(GetProfile profile){
    return myRequest(profile);
  }


  Widget myPublications(){

    return widget.username!= null ?
    FutureBuilder(
      future: RestServices().getMyPublication(userName: widget.username),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<PublicationModel> model = snapshot.data;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: model.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                PublicationModel items = model[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailWorkerScreen(id: items.id, myPublication: profile.isClient! ? false : true,),),);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.h),
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
                          offset: Offset(0, 3.h), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              items.user.fullName,
                              style: AppTextStyles.h18Regular.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        HBox(5.h),
                        items.isContractual
                        ? Text(
                          'Договорная',
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
                                items.files.isNotEmpty ?
                                Container(
                                  height: 85.h,
                                  width: 156.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    image: DecorationImage(
                                      image: NetworkImage(items.files.first.url),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ) : Container(
                                  height: 85.h,
                                  width: 156.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: AppColors.graySearch
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.no_photography_outlined),
                                      Text('Нет фото')
                                    ],
                                  ),
                                ),
                                items.files.isNotEmpty?
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
                                ) : SizedBox()
                              ],
                            ),
                            WBox(6.w),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 162.w,
                                  child: Text(
                                    items.category,
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(
                                        fontWeight: FontWeight.w600),
                                  ),
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
                            ),
                          ],
                        ),
                        HBox(12.h),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
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
    )
    : SizedBox();
  }


  Widget getReview(){
    return SafeArea(
      child: FutureBuilder(
          future: RestServices().getAllReviewByPublication(widget.username),
          builder: (BuildContext context, AsyncSnapshot snapshotReview){
            if (snapshotReview.hasData){
              List<PublicationReview> reviewModel = snapshotReview.data;
              return reviewModel.isNotEmpty?
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HBox(12.h),
                  Text(
                    'Отзывы (${reviewModel.length })',
                    style: AppTextStyles.body14Secondary,
                  ),
                  HBox(12.h),

                  Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: Offset(0, 3.w), // changes position of shadow
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
                            reviewModel.first.rating ==5
                                ? Row(
                              children: [
                                Text('Отлично', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primary),),
                                Image.asset('assets/icons/emoji_best.png', width: 23.w, height: 23.h,)
                              ],
                            )
                                : reviewModel.first.rating == 4
                                ?  Row(
                              children: [
                                Text('Хорошо', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.additionalGreenMedium),),
                                Image.asset('assets/icons/emoji_good.png', width: 23.w, height: 23.h,)
                              ],
                            )
                                : Row(
                              children: [
                                Text('Плохо', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.red),),
                                Image.asset('assets/icons/emoji_angry.png', width: 23.w, height: 23.h,)
                              ],
                            ),

                            Text(formatDate(reviewModel.first.createdDate ?? DateTime.now())),
                          ],
                        ),
                        HBox(12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.grayCategory
                        ),
                          child: Text(reviewModel.first.category ?? ''),
                        ),
                        HBox(12.h),
                        Text(reviewModel.first.feedback ?? '',
                          style:  AppTextStyles.bodySecondary.copyWith(color: AppColors.blackGreyText),),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: reviewModel.first.files.map((file){
                              return  Container(
                                width: 94.w,
                                height: 84.h,
                                margin: EdgeInsets.only(right: 15.w, top: 12.h, bottom: 12.h),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: Offset(0, 3.h), // changes position of shadow
                                    ),
                                  ],
                                  image: DecorationImage(
                                      image: NetworkImage(file.url), fit: BoxFit.fill),
                                  color: AppColors.primary.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primary),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(reviewModel.first.authorFullName ?? '',
                            style:  AppTextStyles.bodySecondary.copyWith(color: AppColors.blackGreyText),),
                        ),
                      ],
                    ),
                  ),
                  reviewModel.length>=1
                      ? Padding(
                         padding: EdgeInsets.only(bottom: 40.h),
                        child: GestureDetector(
                    onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (_)=> ShowAllRateScreen(userName: widget.username),),);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            border: Border.all(color: AppColors.primary)
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Смотреть все отзывы (${reviewModel.length})',
                          style: AppTextStyles.body14W500.copyWith(color: AppColors.primary),
                        ),
                    ),
                  ),
                      ) : const SizedBox()
                ],
              ) :SizedBox();
            }else{
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Widget myRequest(GetProfile profile){
    return FutureBuilder(
      future: RestServices().getMyTasks(userName: profile.username ?? ''),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<TaskModel> model = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              model.length>=1?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'Текущие задания',
                  style: AppTextStyles.body14Secondary
                      .copyWith(color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ) : SizedBox(),
              HBox(6.h),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: model.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    TaskModel items = model[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailTaskScreen(
                              id: items.id,

                            ),),);
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
                              offset: Offset(
                                  0, 3.w
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                items.files.isNotEmpty ?
                                Container(
                                  height: 146.h,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    image: DecorationImage(
                                      image:
                                      NetworkImage(items.files.first.url),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ) : Container(
                                  height: 146.h,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: AppColors.graySearch
                                  ),
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
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Категория',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(
                                      color: AppColors.primaryGray),
                                ),
                                Text(items.category,
                                    style: AppTextStyles.body14Secondary),
                              ],
                            ),
                            HBox(6.h),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Стоимость работ',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(
                                      color: AppColors.primaryGray),
                                ),
                                items.isContractual?
                                Text("договорная",
                                    style: AppTextStyles.body14Secondary)
                                :
                                Text("${items.price.toInt().toString()} ₸",
                                    style: AppTextStyles.body14Secondary),
                              ],
                            ),
                            HBox(8.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Описание',
                                  style: AppTextStyles.body14Secondary
                                      .copyWith(
                                      color: AppColors.black, fontWeight: FontWeight.w600),
                                ),
                                Text(items.description,
                                    style: AppTextStyles.body14Secondary,
                                maxLines: 2,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}