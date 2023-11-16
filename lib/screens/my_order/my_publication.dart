import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/publication_card_view.dart';

class GetAllMyPublication extends StatefulWidget {
  const GetAllMyPublication({Key? key}) : super(key: key);

  @override
  State<GetAllMyPublication> createState() => _GetAllMyPublicationState();
}

class _GetAllMyPublicationState extends State<GetAllMyPublication> {
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
          'Мои объявления',
          style: AppTextStyles.h18Regular,
        ),
      ),
      body: profile.username != null
          ? FutureBuilder(
              future: RestServices()
                  .getMyPublication(userName: profile.username ?? ''),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<PublicationModel> model = snapshot.data;
                  return model.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: model.length,
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
                                      myPublication: true,
                                    ),
                                  ),
                                );
                              },
                              child: PublicationCardView(
                                items: items, onTap: null, showStar: false,
                              ),
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
            )
          : const SizedBox(),
    );
  }
}
