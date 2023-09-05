import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class GetAllMyTask extends StatefulWidget {
  const GetAllMyTask({Key? key}) : super(key: key);

  @override
  State<GetAllMyTask> createState() => _GetAllMyTaskState();
}

class _GetAllMyTaskState extends State<GetAllMyTask> {
  GetProfile profile = GetProfile();



  @override
  void initState() {
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
        centerTitle: true,
        title: Text(
          'Мои заявки',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: FutureBuilder(
        future: RestServices().getMyTasks(userName: profile.username ?? ''),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<TaskModel> model = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: model.length,
                itemBuilder: (context, index) {
                  TaskModel items = model[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailTaskScreen(
                            id: items.id,
                            myTask: true,
                          ),
                        ),
                      );
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
                            offset: Offset(0, 3.w),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              items.files.isNotEmpty
                                  ? Container(
                                      height: 146.h,
                                      width: MediaQuery.of(context).size.width,
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
                                      height: 146.h,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.w),
                                          color: AppColors.graySearch),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.no_photography_outlined),
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
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: AppColors.black.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    "1/${items.files.length.toString()}",
                                    style: AppTextStyles.captionPrimary
                                        .copyWith(color: AppColors.white),
                                  ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Категория',
                                style: AppTextStyles.body14Secondary
                                    .copyWith(color: AppColors.primaryGray),
                              ),
                              Text(items.category,
                                  style: AppTextStyles.body14Secondary),
                            ],
                          ),
                          HBox(6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Стоимость работ',
                                style: AppTextStyles.body14Secondary
                                    .copyWith(color: AppColors.primaryGray),
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
      ),
    );
  }
}
