import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/chat/chat_list_model.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/screens/work_for_worker/chat/chat_type_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class ShowPersonPublication extends StatefulWidget {
  List<ChatList> items;
  bool isClients;
  PublicationModel publication;

  ShowPersonPublication(
      {Key? key,
        required this.items,
        required this.isClients,
        required this.publication})
      : super(key: key);

  @override
  State<ShowPersonPublication> createState() => _ShowPersonPublicationState();
}

class _ShowPersonPublicationState extends State<ShowPersonPublication> {
  final formatDate = DateFormat('HH:mm');

  GetProfile profile = GetProfile();


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loadProfile = await RestServices().getMyProfile();

        if (mounted) {
          setState(() {

            profile=loadProfile;

          });
        }
      } catch (e) {
        // Handle any errors that might occur during the network request.
        print("Error fetching publication: $e");
      }
    });
    super.initState();
  }

  Widget getMessageByStatus(String message) {
    var chatMes = "";
    switch (message) {
      case "PUBLICATION_CHAT_ACTIVE":
        chatMes =
        "Вы можете выбрать данного специалиста, но сперва опишите детали работ";
        break;
      case "PUBLICATION_APPROVED_BY_CLIENT":
        chatMes =
        "Вы выбрали специалиста! Теперь ждем его подтверждения о начале работы";
        break;

      case "PUBLICATION_CONFIRMED_WORK":
        chatMes =
        'Специалист подтвердил готовность работать. Пожалуйста оставьте отзыв о проделанной работе, когда исполнитель её завершит.';
        break;
      case "PUBLICATION_COMPLETED_WORK":
        chatMes = 'Специалист завершил работу';
        break;

      case "TASK_REQUEST_FROM_EXECUTOR":
        chatMes =
        'Если вас устраивает этот специалист, вы можете выбрать его для выполнения своего задания прям здесь';
        break;
      case "TASK_APPROVED":
        chatMes =
        'Пожалуйста оставьте отзыв о проделанной работе, когда исполнитель её завершит';
        break;
      case "TASK_COMPLETED":
        chatMes = 'Работа завершена, оцените специалиста';
        break;
      case "TASK_REJECTED":
        chatMes = 'Вы отколнили этого специалиста';
        break;
      case "TASK_CANCELED":
        chatMes = 'Вы отменили сделку с данным специалистом';
        break;
      case "PUBLICATION_REJECTED_WORK":
        chatMes =
        "Сожалеем, но специалист отклонил вашу работу. Вы можете назначить работу со специалистом в другой день и оставить отзыв";
        break;
      case "WORK_COMPLETED_AND_HAS_REVIEW":
        chatMes =
        "Вы оставили отзыв! Благодарим вас за использование нашей платформы и будем рады видеть вас снова";
        break;
    }
    return Text(chatMes == '' ? message : chatMes);
  }

  Widget getMessageByStatusWorker(String message) {
    var chatMes = "";
    switch (message) {
      case "PUBLICATION_CHAT_ACTIVE":
        chatMes = "";
        break;
      case "PUBLICATION_APPROVED_BY_CLIENT":
        chatMes =
        "Заказчик выбрал вас для выполнения работы Подтвердите свою готовность к выполнению или отклоните";
        break;
      case "PUBLICATION_CONFIRMED_WORK":
        chatMes =
        "Вы выполняете работу. Выполните свою работу хорошо, что бы получить отзыв.";
        break;
      case "PUBLICATION_COMPLETED_WORK":
        chatMes = 'Специалист завершил работу';
        break;
      case "TASK_REQUEST_FROM_EXECUTOR":
        chatMes =
        'Вы откликнулись на это Задание! Напишите заказчику первым или дождись, пока он сам с вами свяжется.';
        break;
      case "TASK_APPROVED":
        chatMes =
        'Поздравляем, заказчик выбрал вас для выполнения своего задания.';
        break;
      case "PUBLICATION_REJECTED_WORK":
        chatMes =
        'Вы отклонили заявку, вы можете связаться позже с заказчиком, договориться о работе и попросить оставить отзыв';
        break;
      case "TASK_REJECTED":
        chatMes = 'Сожалеем, но заказчик отклонил ваш отклик';
        break;
      case "TASK_CANCELED":
        chatMes = 'Заказчик отменил сделку';
        break;
      case "TASK_COMPLETED":
        chatMes = 'Работа завершена';
        break;
      case "WORK_COMPLETED_AND_HAS_REVIEW":
        chatMes = "Поздравляем! Вы завершили работу!";
        break;
    }
    return Text(chatMes == '' ? message : chatMes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          widget.publication.category,
          style: AppTextStyles.h18Regular.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailWorkerScreen(
                              id: widget.publication.id,
                              myPublication: profile.isClient! ? false : true)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.publication.files.isNotEmpty
                        ? Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.publication.files.first.url))),
                    )
                        : Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.graySearch,
                        ),
                        child: Text(
                          'Нет фото',
                          textAlign: TextAlign.center,
                        )),
                    Column(
                      children: [
                        SizedBox(
                            width: 250,
                            child: Text(
                              widget.publication.title,
                              maxLines: 1,
                            )),
                        SizedBox(
                          width: 250,
                          child: widget.publication.isContractual
                              ? Text("договорная")
                              : Text(
                              "${widget.publication.price.toInt().toString()} ₸"),
                        ),
                      ],
                    ),
                    Text(widget.publication.city)
                  ],
                ),
              ),
              const Divider(),
              HBox(16.h),
              Column(
                children: widget.items.map((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MessagePage(
                              categoryId: widget.publication.categoryId,
                            chatId: item.id.toString(),
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: item.photoUrl == null
                          ? Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: AppColors.primary,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: const Icon(Icons.person),
                        ),
                      )
                          : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                item.photoUrl.toString(),
                              ),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(30.h),
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(item.userFullName ?? ''),
                      subtitle: profile.isClient!
                          ? getMessageByStatus(item.lastMessage ?? '')
                          : getMessageByStatusWorker(item.lastMessage ?? ''),
                      trailing: Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(formatDate.format(item.time ?? DateTime.now())),
                          SizedBox(
                            height: 4.h,
                          ),
                          if (item.countOfNewMessages != null)
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4.h),
                              ),
                              child: Text(
                                item.countOfNewMessages.toString(),
                                style: AppTextStyles.bodyPrimary.copyWith(
                                    color: AppColors.white, fontSize: 12),
                              ),
                            )
                          else
                            const SizedBox(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}