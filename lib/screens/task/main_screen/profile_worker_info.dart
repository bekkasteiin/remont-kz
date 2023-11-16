import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/publication/publication_review.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/chat/chat_widget/load_shimmer.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/screens/task/main_screen/show_all_rate_screen.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/date.dart';
import 'package:remont_kz/utils/global_widgets/full_screen_image.dart';
import 'package:remont_kz/utils/global_widgets/publication_card_view.dart';
import 'package:remont_kz/utils/global_widgets/task_card_view.dart';

class ProfilePersonInfo extends StatefulWidget {
  String username;
  ProfilePersonInfo({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfilePersonInfo> createState() => _ProfilePersonInfoState();
}

class _ProfilePersonInfoState extends State<ProfilePersonInfo> {
  List<PublicationModel> modelPubl = [];
 GetProfile profile = GetProfile();
 bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loadProfile = await RestServices().getMyProfile();

        if (mounted) {
          setState(() {
            profile = loadProfile;
            isLoading = false;
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
    return FutureBuilder(
        future: RestServices().getProfileByUsername(userName: widget.username),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            GetProfile profileWork = snapshot.data;
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: isLoading?
                    SizedBox()
                :
                Text(
                  !profile.isClient! ? 'Профиль заказчика' : 'Профиль исполнителя',
                  style: AppTextStyles.h18Regular,
                ),
                leading: GestureDetector(
                  onTap: ()=>Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: AppColors.white,),
                ),
                centerTitle: true,
              ),
              body: isLoading
              ? LoadSimmer(): SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HBox(24.h),
                  if (profileWork.photoUrl!= null) Center(
                    child: CircleAvatar(
                      radius: 75.w,
                      backgroundImage: NetworkImage(profileWork.photoUrl),
                    ),
                  ) else Center(
                    child: CircleAvatar(
                      radius: 75.w,
                    ),
                  ),
                  Center(
                    child: FutureBuilder(
                        future: RestServices().getProfileSession(userName: profileWork.username??''),
                        builder: (BuildContext context, AsyncSnapshot snapshotDate){
                          if(snapshotDate.hasData){
                            return  Column(
                              children: [
                                HBox(6.h),
                                Text(
                                    'Онлайн в ${snapshotDate.data}',
                                  style: AppTextStyles
                                      .body14Secondary
                                      .copyWith(
                                      color: AppColors
                                          .primary),
                                ),
                              ],
                            );
                          }else{
                            return SizedBox();
                          }
                        }),
                  ),
                  HBox(12.h),
                  Center(
                    child: Text(
                      '${profileWork.name ?? ''} ${profileWork.lastname ?? ''}',
                      style: AppTextStyles.h18Regular.copyWith(color: AppColors.blackGreyText),),
                  ),
                  profile.isClient!
                  ? HBox(12.h) : SizedBox(),
                  profile.isClient!
                  ?
                      FutureBuilder(
                        future: RestServices().getCompletedWorkProfile(widget.username),
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            return Center(
                              child: Text(
                                'Работ ${snapshot.data['countCompletedWorks']} | Отзывы (${snapshot.data['countReview']})',
                                style: AppTextStyles.body14W500.copyWith(color: AppColors.blackGreyText),),
                            );
                          }else{
                            return const SizedBox();
                          }
                      })
                  : const SizedBox(),
                  HBox(12.h),
                  profile.isClient!
                      ? isWorker(profileWork)
                      : isClients(profileWork)
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
            style: AppTextStyles.h18Regular
                .copyWith(color: AppColors.blackGreyText, fontWeight: FontWeight.w400),
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
                blurRadius: 4,
                offset: Offset(0, 1.w), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              readOnly: true,
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
            style: AppTextStyles.h18Regular
                .copyWith(color: AppColors.blackGreyText, fontWeight: FontWeight.w400),
          ),
        ),
        HBox(12.h),
        myPublications(),
        getReview(),
      ],
    );
  }


  Widget isClients(GetProfile profile){
    return myRequest(profile);
  }


  Widget myPublications(){
    return profile.username!=null?
     FutureBuilder(
      future: tokenStore.accessToken != null
          ? RestServices().getMyPublicationWithToken(userName: widget.username)
          : RestServices().getMyPublication(userName: widget.username),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<PublicationModel> model = snapshot.data;
          return ListView.builder(
            padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: model.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                PublicationModel items = model[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailWorkerScreen(
                              id: items.id,
                            ),),).then(
                                (value) => setState(() {}));
                      },
                      child: PublicationCardView(items: items,
                        showStar: true,
                        onTap: tokenStore.accessToken !=
                            null
                            ? () async {
                          if (items.favourite) {
                            await RestServices()
                                .deleteFavouritePublication(
                                items.id
                                    .toString());
                            setState(() {});
                          } else {
                            await RestServices()
                                .addFavourite(items.id
                                .toString());
                          }
                          setState(() {});
                        }
                            : null,),
                    ),
                    HBox(12.h),
                  ],
                );
              });

        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
    : const SizedBox();
  }


  Widget getReview(){
    return  FutureBuilder(
        future: RestServices().getAllReviewByPublication(userName:
        widget.username, categoryId: 0, rating: 0),
        builder: (BuildContext context, AsyncSnapshot snapshotReview){
          if (snapshotReview.hasData){
            PublicationReview reviewModel = snapshotReview.data;
            return reviewModel.comments.isNotEmpty?
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Отзывы (${reviewModel.commentsSize })',
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
                          blurRadius: 4,
                          offset: Offset(0, 1.w), // changes position of shadow
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
                            reviewModel.comments.first.rating==3
                                ? Row(
                              children: [
                                Text('Отлично', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primary),),
                                WBox(6.w),
                                Image.asset('assets/icons/emoji_best.png', width: 23.w, height: 23.h,)
                              ],
                            )
                                : reviewModel.comments.first.rating == 2
                                ?  Row(
                              children: [
                                Text('Хорошо', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.additionalGreenMedium),),
                                WBox(6.w),
                                Image.asset('assets/icons/emoji_good.png', width: 23.w, height: 23.h,)
                              ],
                            )
                                : Row(
                              children: [
                                Text('Плохо', style: AppTextStyles.body14Secondary.copyWith(color: AppColors.red),),
                                WBox(6.w),
                                Image.asset('assets/icons/emoji_angry.png', width: 23.w, height: 23.h,)
                              ],
                            ),

                            Text(formatDate(reviewModel.comments.first.createdDate), style: AppTextStyles.bodySecondaryTen,),
                          ],
                        ),
                        HBox(12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColors.grayCategory
                          ),
                          child: Text(reviewModel.comments.first.category),
                        ),
                        HBox(12.h),
                        Text(reviewModel.comments.first.feedback,
                          style:  AppTextStyles.bodySecondary.copyWith(color: AppColors.blackGreyText),),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: reviewModel.comments.first.files.map((file){
                              return  GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImage(
                                          files: reviewModel.comments.first.files
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 94.w,
                                  height: 84.h,
                                  margin: EdgeInsets.only(right: 15.w, top: 12.h, bottom: 12.h),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0, 1.h), // changes position of shadow
                                      ),
                                    ],
                                    image: DecorationImage(
                                        image: NetworkImage(file.url), fit: BoxFit.fill),
                                    color: AppColors.primary.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(reviewModel.comments.first.authorFullName,
                              style:  AppTextStyles.bodySecondaryTen),
                        ),
                      ],
                    ),
                  ),
                  reviewModel.commentsSize>=1
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
                          'Смотреть все отзывы (${reviewModel.commentsSize})',
                          style: AppTextStyles.body14W500.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ) : const SizedBox()
                ],
              ),
            ) :SizedBox();
          }else{
            return const CircularProgressIndicator();
          }
        });
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
                      child: TaskCardView(items: items),
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