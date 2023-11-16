import 'package:carousel_slider/carousel_slider.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/screens/task/main_screen/profile_worker_info.dart';
import 'package:remont_kz/screens/task/main_screen/show_all_rate_screen.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/full_screen_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/publication/publication_review.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/date.dart';

class DetailWorkerScreen extends StatefulWidget {
  int id;
  bool myPublication = false;
  DetailWorkerScreen({Key? key, required this.id, this.myPublication = false})
      : super(key: key);

  @override
  State<DetailWorkerScreen> createState() => _DetailWorkerScreenState();
}

class _DetailWorkerScreenState extends State<DetailWorkerScreen> {
  String phoneNumber = '';
  int itemIndexValue = 0;
  late PublicationModel model;
  TextEditingController controller = TextEditingController();
  late String formattedNumber;
  GetProfile profile = GetProfile();

  void launchPhoneCall(String phoneNumber) async {
    final phoneUrl = 'tel:${formatPhone(phoneNumber)}';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  String formatPhone(String input) {
    if (input.length >= 10) {
      final countryCode = '+${input.substring(0, 1)}';
      final areaCode = input.substring(1, 4);
      final firstPart = input.substring(4, 7);
      final secondPart = input.substring(7, 9);
      final thirdPart = input.substring(9);
      formattedNumber =
          '$countryCode($areaCode)$firstPart-$secondPart-$thirdPart';

      return formattedNumber;
    } else {
      setState(() {
        formattedNumber = '';
      });
      return formattedNumber;
    }
  }

  @override
  void initState() {
    stompClient.activate();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final tokenStore = await RestServices().getMyProfile();

        if (mounted) {
          setState(() {
            profile = tokenStore;
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
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokenStore = getIt.get<TokenStoreService>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: FutureBuilder(
        future: tokenStore.accessToken != null
            ? RestServices().getPublicationByIdAccessToken(widget.id)
            : RestServices().getPublicationById(widget.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            model = snapshot.data;
            phoneNumber = model.user.username ?? '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        model.files.isNotEmpty
                            ? Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullScreenImage(
                                            files: model.files,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CarouselSlider.builder(
                                      itemCount: model.files.length,
                                      itemBuilder: (BuildContext context,
                                          int itemIndex, int pageViewIndex) {
                                        return SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 360.h,
                                          child: Image.network(
                                            model.files[itemIndex].url,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                        onPageChanged: (int index, _) {
                                          itemIndexValue = index;
                                          setState(() {});
                                        },
                                        height: 360.h,
                                        enlargeCenterPage: true,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.zoom,
                                        autoPlay: false,
                                        enableInfiniteScroll: false,
                                        initialPage: 0,
                                        scrollDirection: Axis.horizontal,
                                        viewportFraction: 1,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 45.h,
                                    left: 15.w,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        height: 35.h,
                                        width: 35.w,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: AppColors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: AppColors.grayDark,
                                              blurRadius: 2.0,
                                              offset: Offset(0.0, 0.75),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.h, horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        color: AppColors.black.withOpacity(0.5),
                                      ),
                                      child: Text(
                                        "${itemIndexValue + 1}/${model.files.length.toString()}",
                                        style: AppTextStyles.captionPrimary
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  Container(
                                    height: 360.h,
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColors.graySearch,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.no_photography_outlined),
                                        Text('Нет фото')
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 45.h,
                                    left: 15.w,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        height: 35.h,
                                        width: 35.w,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: AppColors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: AppColors.grayDark,
                                              blurRadius: 2.0,
                                              offset: Offset(0.0, 0.75),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        Padding(
                          padding: EdgeInsets.all(12.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    model.user.fullName,
                                    style: AppTextStyles.h18Regular.copyWith(
                                        color: AppColors.blackGreyText),
                                  ),
                                  widget.myPublication
                                      ? GestureDetector(
                                          onTap: () => Share.share(
                                              model.description,
                                              subject: model.category),
                                          child: const Icon(
                                            Icons.ios_share_rounded,
                                            color: AppColors.primary,
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Share.share(
                                                  model.description,
                                                  subject: model.category),
                                              child: const Icon(
                                                Icons.ios_share_rounded,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 24.w,
                                            ),
                                            GestureDetector(
                                                onTap: tokenStore.accessToken !=
                                                        null
                                                    ? () async {
                                                        if (model.favourite) {
                                                          await RestServices()
                                                              .deleteFavouritePublication(
                                                                  model.id
                                                                      .toString());
                                                        } else {
                                                          await RestServices()
                                                              .addFavourite(model
                                                                  .id
                                                                  .toString());
                                                        }

                                                        setState(() {});
                                                      }
                                                    : null,
                                                child: Icon(
                                                  model.favourite
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: model.favourite
                                                      ? AppColors.primaryYellow
                                                      : AppColors.primary,
                                                  size: 28,
                                                ))
                                          ],
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Категория',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(color: AppColors.primaryGray),
                                  ),
                                  Text(model.category,
                                      style: AppTextStyles.body14W500),
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Регион',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(color: AppColors.primaryGray),
                                  ),
                                  Text(model.city,
                                      style: AppTextStyles.body14W500),
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Стоимость работ',
                                    style: AppTextStyles.body14Secondary
                                        .copyWith(color: AppColors.primaryGray),
                                  ),
                                  model.isContractual
                                      ? Text('договорная',
                                          style: AppTextStyles.body14W500)
                                      : Text('от ${model.price.toInt()} ₸',
                                          style: AppTextStyles.body14W500),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.2.h,
                          color: AppColors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Описание',
                                style: AppTextStyles.h18Regular.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary),
                              ),
                              HBox(
                                12.h,
                              ),
                              Text(
                                model.description,
                                style: AppTextStyles.body14Secondary,
                              ),
                              HBox(
                                12.h,
                              ),
                              FutureBuilder(
                                  future: RestServices()
                                      .getAllReviewByPublication(
                                          userName: model.user.username ?? '',
                                          categoryId: 0,
                                          rating: 0),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshotReview) {
                                    if (snapshotReview.hasData) {
                                      PublicationReview reviewModel =
                                          snapshotReview.data;
                                      return reviewModel.comments.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                HBox(12.h),
                                                Text(
                                                  'Отзывы (${reviewModel.commentsSize})',
                                                  style: AppTextStyles
                                                      .body14Secondary,
                                                ),
                                                HBox(12.h),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12.h),
                                                  padding: EdgeInsets.all(12.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.w),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0,
                                                        blurRadius: 4,
                                                        offset: Offset(0,
                                                            1.w), // changes position of shadow
                                                      ),
                                                    ],
                                                    color: AppColors.white,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          reviewModel
                                                                      .comments
                                                                      .first
                                                                      .rating ==
                                                                  3
                                                              ? Row(
                                                                  children: [
                                                                    Text(
                                                                      'Отлично',
                                                                      style: AppTextStyles
                                                                          .body14Secondary
                                                                          .copyWith(
                                                                              color: AppColors.primary),
                                                                    ),
                                                                    WBox(6.w),
                                                                    Image.asset(
                                                                      'assets/icons/emoji_best.png',
                                                                      width:
                                                                          23.w,
                                                                      height:
                                                                          23.h,
                                                                    )
                                                                  ],
                                                                )
                                                              : reviewModel
                                                                          .comments
                                                                          .first
                                                                          .rating ==
                                                                      2
                                                                  ? Row(
                                                                      children: [
                                                                        Text(
                                                                          'Хорошо',
                                                                          style: AppTextStyles
                                                                              .body14Secondary
                                                                              .copyWith(color: AppColors.additionalGreenMedium),
                                                                        ),
                                                                        WBox(6
                                                                            .w),
                                                                        Image
                                                                            .asset(
                                                                          'assets/icons/emoji_good.png',
                                                                          width:
                                                                              23.w,
                                                                          height:
                                                                              23.h,
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        Text(
                                                                          'Плохо',
                                                                          style: AppTextStyles
                                                                              .body14Secondary
                                                                              .copyWith(color: AppColors.red),
                                                                        ),
                                                                        WBox(6
                                                                            .w),
                                                                        Image
                                                                            .asset(
                                                                          'assets/icons/emoji_angry.png',
                                                                          width:
                                                                              23.w,
                                                                          height:
                                                                              23.h,
                                                                        )
                                                                      ],
                                                                    ),
                                                          Text(
                                                            formatDate(reviewModel
                                                                .comments
                                                                .first
                                                                .createdDate),
                                                            style: AppTextStyles
                                                                .bodySecondaryTen,
                                                          ),
                                                        ],
                                                      ),
                                                      HBox(12.h),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.w,
                                                                vertical: 4.h),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: AppColors
                                                                .grayCategory),
                                                        child: Text(reviewModel
                                                            .comments
                                                            .first
                                                            .category),
                                                      ),
                                                      HBox(12.h),
                                                      Text(
                                                        reviewModel.comments
                                                            .first.feedback,
                                                        style: AppTextStyles
                                                            .bodySecondary
                                                            .copyWith(
                                                                color: AppColors
                                                                    .blackGreyText),
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: reviewModel
                                                              .comments
                                                              .first
                                                              .files
                                                              .map((file) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) => FullScreenImage(
                                                                        files: reviewModel
                                                                            .comments
                                                                            .first
                                                                            .files),
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                width: 94.w,
                                                                height: 84.h,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right: 15
                                                                            .w,
                                                                        top: 12
                                                                            .h,
                                                                        bottom:
                                                                            12.h),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          0,
                                                                      blurRadius:
                                                                          4,
                                                                      offset: Offset(
                                                                          0,
                                                                          1.h), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(file
                                                                          .url),
                                                                      fit: BoxFit
                                                                          .fill),
                                                                  color: AppColors
                                                                      .primary
                                                                      .withOpacity(
                                                                          0.6),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color: AppColors
                                                                          .primary),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                          reviewModel
                                                                  .comments
                                                                  .first
                                                                  .authorFullName ??
                                                              '',
                                                          style: AppTextStyles
                                                              .bodySecondaryTen,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                reviewModel.commentsSize >= 1
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  ShowAllRateScreen(
                                                                      userName:
                                                                          model.user.username ??
                                                                              ''),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      8.h),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.w),
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .primary)),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'Смотреть все отзывы (${reviewModel.commentsSize})',
                                                            style: AppTextStyles
                                                                .body14W500
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .primary),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                HBox(
                                                  12.h,
                                                ),
                                              ],
                                            )
                                          : SizedBox();
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
                              tokenStore.accessToken != null
                                  ? const SizedBox()
                                  : HBox(40.h),
                              if (tokenStore.accessToken != null)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: FutureBuilder(
                                      future: RestServices()
                                          .getProfileByUsername(
                                              userName:
                                                  model.user.username ?? ''),
                                      builder: (_, AsyncSnapshot snapshots) {
                                        if (snapshots.hasData) {
                                          GetProfile profile = snapshots.data;
                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePersonInfo(
                                                  username:
                                                      profile.username ?? '',
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                profile.photoUrl == null
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                        radius: 39.w,
                                                        child: Icon(
                                                          Icons.person,
                                                          color:
                                                              AppColors.white,
                                                          size: 32.w,
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                        radius: 39.w,
                                                        backgroundImage:
                                                            NetworkImage(profile
                                                                .photoUrl),
                                                      ),
                                                SizedBox(
                                                  width: 16.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      model.user.fullName,
                                                      style: AppTextStyles
                                                          .h18Regular
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16.h,
                                                              color: AppColors
                                                                  .blackGreyText),
                                                    ),
                                                    HBox(6.h),
                                                    Text(
                                                      'На REMONT.KZ c ${formatMonthNamedDate(profile.createdDate!)}',
                                                      style: AppTextStyles
                                                          .body14Secondary
                                                          .copyWith(
                                                              color: AppColors
                                                                  .primaryGray),
                                                    ),
                                                    HBox(6.h),
                                                    FutureBuilder(
                                                        future: RestServices()
                                                            .getProfileSession(
                                                                userName: model
                                                                        .user
                                                                        .username ??
                                                                    ''),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshotDate) {
                                                          if (snapshotDate
                                                              .hasData) {
                                                            return Text(
                                                              'Онлайн в ${snapshotDate.data}',
                                                              style: AppTextStyles
                                                                  .body14Secondary
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .primaryGray),
                                                            );
                                                          } else {
                                                            return SizedBox();
                                                          }
                                                        }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                model.user.username == profile.username
                    ? SizedBox()
                    : tokenStore.accessToken != null
                        ? Container(
                            height: 70.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 0.75),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.only(
                                bottom: 20.h, left: 12.w, right: 12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.h),
                                            topRight: Radius.circular(16.h),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.8,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 24.h,
                                                horizontal: 16.w),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Звонок на ${formatPhone(phoneNumber)}',
                                                  style: AppTextStyles
                                                      .body14Secondary
                                                      .copyWith(
                                                          color: AppColors
                                                              .primary),
                                                ),
                                                HBox(24.h),
                                                Text(
                                                  'При звонке сообщите специалисту, что вы нашли его объявление на REMONT.KZ. Если вы договоритесть о встрече, то выберите специалиста сразу после звонка, что бы зафиксировать факт найма и получить возможность оставить отзыв специалисту. Желаем вам удачи, Команда Remont.kz',
                                                  style: AppTextStyles
                                                      .body14Secondary,
                                                ),
                                                HBox(16.h),
                                                GestureDetector(
                                                  onTap: () => launchPhoneCall(
                                                      phoneNumber),
                                                  child: Container(
                                                    height: 34.h,
                                                    padding:
                                                        EdgeInsets.all(4.h),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.h),
                                                        color:
                                                            AppColors.primary),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Позвонить ${formatPhone(phoneNumber)}',
                                                      style: AppTextStyles
                                                          .bodyPrimary
                                                          .copyWith(
                                                              color: AppColors
                                                                  .white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.phone_callback_outlined,
                                    size: 24.w,
                                    color: AppColors.primary,
                                  ),
                                ),
                                WBox(4.w),
                                Expanded(
                                  child: SizedBox(
                                    height: 35.h,
                                    child: TextFormField(
                                      controller: controller,
                                      maxLines: 3,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 8.h),
                                        hintText: "Напишите сообщение",
                                        labelStyle: TextStyle(
                                            fontSize: 14.w,
                                            color: AppColors.primaryGray),
                                        fillColor: Colors.blue,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(13.w),
                                          ),
                                          borderSide: const BorderSide(
                                              color: Colors.purpleAccent),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppColors.primary,
                                  ),
                                  iconSize: 20.w,
                                  onPressed: () {
                                    final tokenStore =
                                        getIt.get<TokenStoreService>();
                                    if (tokenStore.accessToken != null) {
                                      var body = '''{
                                        "executorUsername": "${model.user.username}",
                                        "clientUsername": "${profile.username}",
                                        "senderUsername": "${profile.username}",
                                        "recipientUsername": "${model.user.username}",
                                        "typeId": ${model.id},
                                        "type": "PUBLICATION",
                                        "content": "${controller.text}",
                                        "categoryId": ${model.categoryId},
                                        "isSystemContent": ${false}
                                      }''';
                                      stompClient.send(
                                          destination: '/app/chat', body: body);
                                      controller.clear();
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.focusedChild?.unfocus();
                                      }
                                      MotionToast toast = MotionToast.success(
                                        description: const Text(
                                          'Сообщение отправлено, специалист ответит Вам в ближайшее время. Если вы не хотите ждать ответа в чате, позвоните специалисту.',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        position: MotionToastPosition.top,
                                        layoutOrientation: ToastOrientation.ltr,
                                        animationType: AnimationType.fromTop,
                                        dismissable: true,
                                      );
                                      toast.show(context);
                                      Future.delayed(const Duration(seconds: 2))
                                          .then((value) {
                                        toast.dismiss();
                                      });
                                    } else {
                                      MotionToast.error(
                                        description: const Text(
                                          'Чтобы связаться с мастером пройдите авторизацию/регистрацию',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        position: MotionToastPosition.top,
                                        layoutOrientation: ToastOrientation.ltr,
                                        animationType: AnimationType.fromTop,
                                        dismissable: true,
                                      ).show(context);
                                      controller.clear();
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        : SizedBox()
              ],
            );
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
