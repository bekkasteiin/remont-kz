import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/task_card_view.dart';

class FavoriteWorkerScreen extends StatefulWidget {
  const FavoriteWorkerScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteWorkerScreen> createState() => _FavoriteWorkerScreenState();
}

class _FavoriteWorkerScreenState extends State<FavoriteWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                onTap: ()=> Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: AppColors.white,),
              ),
              centerTitle: true,
              title: Text(
                'Избранное',
                style: AppTextStyles.h18Regular,
              ),
            ),
            body: SingleChildScrollView(
              child: FutureBuilder(
                future: RestServices().getFavoriteTask(),
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<TaskModel> model = snapshot.data;
                    return model.isNotEmpty
                        ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: model.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                                      ),),).then((value) => setState((){}));
                                },
                                child: TaskCardView(items: items),
                              ),
                              HBox(12.h),
                            ],
                          );
                        })
                    : Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.5.h),
                      child: Center(
                        child: Text('Нет избранных задании', style: AppTextStyles.body14Secondary,),
                      ),
                    );
                  }else{
                    return const SizedBox();
                  }

                },
              ),
            ),
          );
  }
}
