import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/chat/chat_list_model.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/chat/chat_type_screen.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class ShowPersonTask extends StatefulWidget {
  bool isClients;
  TaskModel publication;

  ShowPersonTask(
      {Key? key,
        required this.isClients,
        required this.publication})
      : super(key: key);

  @override
  State<ShowPersonTask> createState() => _ShowPersonTaskState();
}

class _ShowPersonTaskState extends State<ShowPersonTask> {
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
          'Сообщения',
          style: AppTextStyles.h18Regular.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: profile.username!= null ?
          FutureBuilder(
            future:  !profile.isClient! ? RestServices().getActivateRequestTask() :RestServices().getActivateRequestTaskId(widget.publication.id) ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
               if(snapshot.hasData){
                 List<ChatList> list = [];
                 List<ChatList> rejectList = [];
                 List<ChatList> activeTask = [];

                 if(!profile.isClient!){
                   List<ChatList> lists = snapshot.data;
                   for(var s in lists){
                     if(s.typeId == widget.publication.id){
                       list.add(s);
                       rejectList = list.where((element) => element.status == 'TASK_REJECTED').toList();
                       activeTask = list.where((element) => element.status != 'TASK_REJECTED').toList();
                     }
                   }
                 }else{
                   list = snapshot.data;
                  rejectList = list.where((element) => element.status == 'TASK_REJECTED').toList();
                  activeTask = list.where((element) => element.status != 'TASK_REJECTED').toList();
                 }
                 return  Column(
                   children: [
                     Expanded(
                       child: SingleChildScrollView(
                         child: Padding(
                           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               GestureDetector(
                                 onTap: () {
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (_) => DetailTaskScreen(
                                             id: widget.publication.id,
                                             myTask: profile.isClient! ? true : false,
                                           ),),);
                                   setState((){});
                                 },
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     widget.publication.files.isNotEmpty
                                         ? Container(
                                       height: 40.h,
                                       width: 40.h,
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(4),
                                           image: DecorationImage(
                                               fit: BoxFit.fitWidth,
                                               image: NetworkImage(

                                                   widget.publication.files.first.url))),
                                     )
                                         : Container(
                                         height: 40.h,
                                         width: 40.h,
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
                                               : Text("до ${widget.publication.price.toInt().toString()} ₸"),
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
                                 children: activeTask.map((item) {

                                   return Column(
                                     children: [
                                       GestureDetector(
                                         onTap: () async{
                                           await Navigator.push(
                                             context,
                                             MaterialPageRoute(
                                               builder: (_) => MessagePage(
                                                 modelTask: widget.publication,
                                                   chatId: item.id.toString(),
                                                   categoryId: widget.publication.categoryId,
                                                   index: !profile.isClient! ? 2 : 3,
                                                 id: widget.publication.id,
                                               ),
                                             ),
                                           ).then((value) => setState((){}));
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
                                               : getMessageByStatusWorker(
                                               item.lastMessage ?? ''),
                                           trailing: Column(
                                             children: [
                                               SizedBox(
                                                 height: 4.h,
                                               ),
                                               Text(dateFormatForChat(item.time)
                                               ),
                                               SizedBox(
                                                 height: 4.h,
                                               ),
                                               if (item.countOfNewMessages != null)
                                                 Container(
                                                   width: 27.w,
                                                   height: 20.h,
                                                   alignment: Alignment.center,
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
                                       ),
                                       const Divider()
                                     ],
                                   );


                                 }).toList(),
                               ),
                               HBox(12.h),
                               rejectList.isNotEmpty?
                               Text('Отклоненные отклики',
                                 style: AppTextStyles.h18Regular.copyWith(fontWeight: FontWeight.w400, color: AppColors.red),): SizedBox(),
                               HBox(12.h),
                               Column(
                                 children: rejectList.map((item) {
                                   return Column(
                                     children: [
                                       GestureDetector(
                                         onTap: () {
                                           Navigator.push(
                                             context,
                                             MaterialPageRoute(
                                               builder: (_) => MessagePage(
                                                 modelTask: widget.publication,
                                                 categoryId: widget.publication.categoryId,
                                                 chatId: item.id.toString(),
                                                 index: !profile.isClient! ? 2 : 3,
                                                 id: widget.publication.id,
                                               ),
                                             ),
                                           ).then((value) {
                                             setState(() {});
                                           });
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
                                               : getMessageByStatusWorker(
                                               item.lastMessage ?? ''),
                                           trailing: Column(
                                             children: [
                                               SizedBox(
                                                 height: 4.h,
                                               ),
                                               Text(dateFormatForChat(item.time)
                                               ),
                                               SizedBox(
                                                 height: 4.h,
                                               ),
                                               if (item.countOfNewMessages != null)
                                                 Container(
                                                   width: 27.w,
                                                   height: 20.h,
                                                   alignment: Alignment.center,
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
                                       ),
                                       const Divider()
                                     ],
                                   );
                                 }).toList(),
                               ),

                             ],
                           ),

                         ),
                       ),
                     ),
                     profile.isClient! ?
                     SafeArea(
                       child: Padding(
                         padding: EdgeInsets.all(12.w),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Принимать отклики', style: AppTextStyles.body14W500,),
                             Row(
                               children: [
                                 Text(widget.publication.openRequest ? 'Да' : 'Нет', style: AppTextStyles.body14W500.copyWith(
                                     color: widget.publication.openRequest ? CupertinoColors.systemGreen
                                         : AppColors.blackGreyText
                                 ),),
                                 WBox(6.w),
                                 CupertinoSwitch(value: widget.publication.openRequest, onChanged: (bool val)async{
                                   if(widget.publication.openRequest == true){
                                     final closeRequest = await RestServices().postClosedRequest(taskID: widget.publication.id);
                                     if(closeRequest == 200){
                                       setState(() {
                                         widget.publication.openRequest = val;
                                       });
                                     }else{
                                       print('error');
                                     }
                                   }else{
                                     final openClose = await RestServices().postOpenClosedRequest(taskID: widget.publication.id);
                                     if(openClose == 200){
                                       setState(() {
                                         widget.publication.openRequest = val;
                                       });
                                     }else{
                                       print('error');
                                     }
                                   }



                                 }),
                               ],
                             )
                           ],
                         ),
                       ),
                     ) : SizedBox(),
                   ],
                 );
               }else{
                 return SizedBox();
               }
          })

      :const SizedBox(),
    );
  }
}



class ShowPersonTaskSingle extends StatefulWidget {
  bool isClients;
  TaskModel publication;

  ShowPersonTaskSingle(
      {Key? key,
        required this.isClients,
        required this.publication})
      : super(key: key);

  @override
  State<ShowPersonTaskSingle> createState() => _ShowPersonTaskSingleState();
}

class _ShowPersonTaskSingleState extends State<ShowPersonTaskSingle> {
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
          'Сообщения',
          style: AppTextStyles.h18Regular.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: profile.username!= null ?
          FutureBuilder(
            future: !profile.isClient! ? RestServices().getCompleteTaskForWorker() : RestServices().getCompleteTaskForClient(widget.publication.id),
              builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.isNotEmpty){
                List<ChatList> list = snapshot.data;
                ChatList chatList = ChatList();
                if(!profile.isClient!){
                  for(var taskChat in list){
                    if(taskChat.typeId == widget.publication.id){
                      chatList = taskChat;

                    }
                  }
                }else{
                  chatList = list.first;
                }
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DetailTaskScreen(
                                            id: widget.publication.id,
                                            myTask: profile.isClient! ? true : false,
                                          ),),);
                                  setState((){});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.publication.files.isNotEmpty
                                        ? Container(
                                      height: 40.h,
                                      width: 40.h,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: NetworkImage(
                                                  widget.publication.files.first.url))),
                                    )
                                        : Container(
                                        height: 40.h,
                                        width: 40.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: AppColors.graySearch,
                                        ),
                                        child: const Text(
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
                                              ? const Text("договорная")
                                              : Text("до ${widget.publication.price.toInt().toString()} ₸"),
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
                                children: [
                                  GestureDetector(
                                    onTap: () async{
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MessagePage(
                                            modelTask: widget.publication,
                                            index: !profile.isClient! ? 4 : 5,
                                            chatId: chatList.id.toString(),
                                            categoryId: widget.publication.categoryId,
                                            id: widget.publication.id,
                                          ),
                                        ),
                                      ).then((value) => setState((){}));
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: chatList.photoUrl == null
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
                                                chatList.photoUrl.toString(),
                                              ),
                                              fit: BoxFit.fill),
                                          borderRadius: BorderRadius.circular(30.h),
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      title: Text(chatList.userFullName ?? ''),
                                      subtitle: profile.isClient!
                                          ? getMessageByStatus(chatList.lastMessage ?? '')
                                          : getMessageByStatusWorker(
                                          chatList.lastMessage ?? ''),
                                      trailing: Column(
                                        children: [
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          Text(dateFormatForChat(chatList.time)
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          if (chatList.countOfNewMessages != null)
                                            Container(
                                              width: 27.w,
                                              height: 20.h,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(4.h),
                                              ),
                                              child: Text(
                                                chatList.countOfNewMessages.toString(),
                                                style: AppTextStyles.bodyPrimary.copyWith(
                                                    color: AppColors.white, fontSize: 12),
                                              ),
                                            )
                                          else
                                            const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider()
                                ],
                              )

                            ],
                          ),

                        ),
                      ),
                    ),
                  ],
                );
              }else{
                return SizedBox();
              }


            }else{
              return const SizedBox();
            }
          })

          :const SizedBox(),
    );
  }
}