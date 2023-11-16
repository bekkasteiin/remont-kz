import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/task_card_view.dart';

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
        final mainProfile = await RestServices().getMyProfile();

        if (mounted) {
          setState(() {
            profile = mainProfile;
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
      body: profile.username!=null ?
      FutureBuilder(
        future: RestServices().getMyTasks(userName: profile.username ?? ''),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<TaskModel> model = snapshot.data;
            return model.isNotEmpty? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: model.length,
                itemBuilder: (context, index) {
                  TaskModel items = model[index];
                  return Column(
                    children: [
                      GestureDetector(
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
                        child: TaskCardView(items: items,),
                      ),
                      HBox(12.h)
                    ],
                  );
                })
            : Center(
              child: Text('Нет данных', style: AppTextStyles.body14Secondary,),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ) : const SizedBox(),
    );
  }
}
