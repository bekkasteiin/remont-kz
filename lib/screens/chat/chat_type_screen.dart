// ignore_for_file: use_build_context_synchronously

import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/chat/chat_list_model.dart';
import 'package:remont_kz/model/chat/chat_room.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/chat/chat_widget/load_shimmer.dart';
import 'package:remont_kz/screens/chat/create_rate.dart';
import 'package:remont_kz/screens/task/main_screen/detail_worker_screen.dart';
import 'package:remont_kz/screens/task/main_screen/profile_worker_info.dart';
import 'package:remont_kz/screens/work_for_worker/main_screen_worker/detail_task_screen.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class MessagePage extends StatefulWidget {
  String? chatId;
  int categoryId;
  int? index;
  int? id;
  TaskModel? modelTask;
  PublicationModel? modelPub;
  MessagePage(
      {Key? key, this.chatId, required this.categoryId, this.id, this.index, this.modelTask, this.modelPub})
      : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final formatDate = DateFormat('HH:mm');
  final textController = TextEditingController();
  final _scrollController = ScrollController();
  String recipientUsername = '';
  bool serviceBool = false;
  bool isClientService = false;
  List<bool> _isChecked = [];
  ChatList listChatAll = ChatList();
  GetProfile profile = GetProfile();
  var loading = true;
  var loadingPage = true;
  late String formattedNumber;
  var listOfExpertise = [
    'Слишком дорого',
    'В профиле мало информации',
    'Нет отзывов',
    'Я уже выбрал другого специалиста'
  ];

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
    _loadMessages();
    _isChecked = List<bool>.filled(listOfExpertise.length, false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final getProfile = await RestServices().getMyProfile();
        await updatePage();

        if (mounted) {
          setState(() {
            profile = getProfile;
            isClientService = profile.isClient!;
            loading = false;
          });
        }
      } catch (e) {
        // Handle any errors that might occur during the network request.
        print("Error fetching publication: $e");
      }
    });
    super.initState();
  }



  updatePage() async {
    serviceBool = await RestServices().getReviewExists(widget.chatId ?? '');
    final loadChat = widget.index == 0
        ? await RestServices().getMyActivateRequestPub()
        : widget.index == 1
            ? await RestServices().getMyChatByPubId(widget.id!)
            : widget.index == 2
                ? await RestServices().getActivateRequestTask()
                : widget.index == 3
                    ? await RestServices().getActivateRequestTaskId(widget.id!)
                    : widget.index == 4
                        ? await RestServices().getCompleteTaskForWorker()
                        : widget.index == 5
                            ? await RestServices()
                                .getCompleteTaskForClient(widget.id!)
                            : widget.index == 6
                                ? await RestServices()
                                    .getCompletedAllPublicationClient()
                                : await RestServices()
                                    .getMyCompeteByPubId(widget.id!);
    for (var chat in loadChat) {
      if (widget.chatId == chat.id.toString()) {
        listChatAll = chat;
        loadingPage = false;
        setState(() {});
      }
    }
  }

  _loadMessages() async {
    try {
      final tokenStore = getIt.get<TokenStoreService>();
      final dio = Dio();
      dio.options.headers = {
        'Accept-Language': 'ru',
        'Authorization': 'Bearer ${tokenStore.accessToken}',
      };
      final response = await dio.get(
        'https://remontor.kz/service/messages-of-chat/${widget.chatId}',
      );
      if (response.statusCode == 200) {
        final message = (response.data as List)
            .map((e) => ChatRoom.fromJson(e as Map<String, dynamic>))
            .toList();
        if (message.first.executorUsername == profile.username) {
          if (message.first.senderUsername == profile.username) {
            recipientUsername = message.first.clientUsername ?? '';
          } else {
            recipientUsername = message.first.senderUsername ?? '';
          }
        } else {
          recipientUsername = message.first.executorUsername ?? '';
        }
        serviceBool = await RestServices().getReviewExists(widget.chatId ?? '');
          setState((){
            messagesList = message;
          });

        // print(messagesList.length);
        return messagesList;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  sendMessages(String text, BuildContext context) async {

    if(!stompClient.isActive){
      stompClient.activate();
    }
    try {
      String recipientUsername = '';
      if (messagesList.first.executorUsername == profile.username) {
        if (messagesList.first.senderUsername == profile.username) {
          recipientUsername = messagesList.first.clientUsername ?? '';
        } else {
          recipientUsername = messagesList.first.senderUsername ?? '';
        }
      } else {
        recipientUsername = messagesList.first.executorUsername ?? '';
      }
      var body = '''{
          "senderUsername": "${profile.username}",
          "recipientUsername": "$recipientUsername",
          "content": "$text",
          "chatRoomId": ${widget.chatId},
          "categoryId": ${widget.categoryId},
          "isSystemContent": ${false}
   }''';
      stompClient.send(destination: '/app/chat', body: body);
      await Future.delayed(Duration(milliseconds: 500));
      await _loadMessages();
      setState(() {
      });

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
            '${listChatAll.userFullName ?? ''} выбран в качестве специалиста! Пожалуйста оставьте отзыв о проделанной работе, когда исполнитель её завершит';
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
    return Container(
      width: MediaQuery.of(context).size.width / 1.05,
      margin: EdgeInsets.all(8.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: const Color(0xffFFD60A),
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Text(chatMes),
    );
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
        chatMes = 'Вы завершили работу';
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
    }
    return chatMes != ""
        ? Container(
            width: MediaQuery.of(context).size.width / 1.05,
            margin: EdgeInsets.all(8.h),
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: const Color(0xffFFD60A),
              borderRadius: BorderRadius.circular(12.h),
            ),
            child: Text(chatMes),
          )
        : const SizedBox();
  }

  Widget selectRejectWorkerForClient(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              height: 30.h,
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(
                    vertical: 5.h, horizontal: 10.w),
                color: AppColors
                    .additionalGreenMediumButton,
                borderRadius:
                BorderRadius.circular(27.w),
                onPressed: () async{
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.only(
                          topRight:
                          Radius.circular(16.w),
                          topLeft:
                          Radius.circular(16.w),
                        ),
                      ),
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                            builder:
                                (BuildContext context,
                                StateSetter
                                setState) {
                              return Container(
                                height:
                                MediaQuery.of(context)
                                    .size
                                    .width /
                                    1.2,
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 8.h,
                                    horizontal: 24.w),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius:
                                  BorderRadius.only(
                                    topRight:
                                    Radius.circular(
                                        16.w),
                                    topLeft:
                                    Radius.circular(
                                        16.w),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Вы действительно хотите выбрать специалиста? После вызавершения работы не забудьте оставить отзыв специалисту',
                                      textAlign: TextAlign
                                          .center,
                                      style: AppTextStyles
                                          .body14W500,
                                    ),
                                    HBox(16.h),
                                    Container(
                                      alignment: Alignment
                                          .center,
                                      child:
                                      FutureBuilder(
                                          future: RestServices().getProfileByUsername(
                                              userName:
                                              listChatAll.username ??
                                                  ''),
                                          builder: (_,
                                              AsyncSnapshot
                                              snapshots) {
                                            if (snapshots
                                                .hasData) {
                                              GetProfile
                                              profile =
                                                  snapshots.data;
                                              return GestureDetector(
                                                onTap: () =>
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ProfilePersonInfo(
                                                          username: profile.username ?? '',
                                                        ),
                                                      ),
                                                    ),
                                                child:
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    profile.photoUrl == null
                                                        ? CircleAvatar(
                                                      backgroundColor: AppColors.primary,
                                                      radius: 39.w,
                                                      child: Icon(
                                                        Icons.person,
                                                        color: AppColors.white,
                                                        size: 14.w,
                                                      ),
                                                    )
                                                        : CircleAvatar(
                                                      backgroundColor: AppColors.primary,
                                                      radius: 39.w,
                                                      backgroundImage: NetworkImage(profile.photoUrl),
                                                    ),
                                                    SizedBox(
                                                      width: 16.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${profile.name ?? ''} ${profile.lastname ?? ''}",
                                                          style: AppTextStyles.h18Regular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.h, color: AppColors.blackGreyText),
                                                        ),
                                                        HBox(6.h),
                                                        Text(
                                                          'На REMONT.KZ ${formatMonthNamedDate(profile.createdDate!)}',
                                                          style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),
                                                        ),
                                                        HBox(6.h),
                                                        FutureBuilder(
                                                            future: RestServices().getProfileSession(userName: profile.username ?? ''),
                                                            builder: (BuildContext context, AsyncSnapshot snapshotDate) {
                                                              if (snapshotDate.hasData) {
                                                                return Text(
                                                                  'Онлайн в ${snapshotDate.data}',
                                                                  style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),
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
                                    ),
                                    HBox(16.h),
                                    SizedBox(
                                      height: 50.h,
                                      width:
                                      MediaQuery.of(
                                          context)
                                          .size
                                          .width,
                                      child:
                                      CupertinoButton(
                                          color: Colors
                                              .green,
                                          child: Text(
                                            'Да, выбрать специалиста',
                                            style: AppTextStyles
                                                .body14Secondary
                                                .copyWith(
                                                color: AppColors.white),
                                          ),
                                          onPressed:
                                              () async {
                                            await RestServices()
                                                .approveSpecialist(
                                                widget.chatId);
                                            await updatePage();
                                            setState(
                                                    () {});
                                          }),
                                    ),
                                    HBox(8.h),
                                    Container(
                                      width:
                                      MediaQuery.of(
                                          context)
                                          .size
                                          .width,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              8
                                                  .w),
                                          border: Border.all(
                                              color: AppColors
                                                  .grayDark,
                                              width: 1)),
                                      child:
                                      CupertinoButton(
                                        padding: EdgeInsets
                                            .symmetric(
                                            vertical:
                                            2.h,
                                            horizontal:
                                            4.w),
                                        color: AppColors
                                            .white,
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            8.w),
                                        onPressed: () {
                                          Navigator.pop(
                                              context);
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Нет, я решил выбрать другого',
                                          style: AppTextStyles
                                              .body14Secondary
                                              .copyWith(
                                              color: AppColors
                                                  .primaryGray),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }).then((value) => setState((){}));
                  await Future.delayed(Duration(milliseconds: 200));
                  await updatePage();
                  await _loadMessages();
                  setState(() {});
                },
                child: Text(
                  'Выбрать специалиста',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Container(
              height: 30.h,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(27.w),
                border: Border.all(
                    color: AppColors.red, width: 1),
              ),
              child: CupertinoButton(
                padding: EdgeInsets.symmetric(
                    vertical: 5.h, horizontal: 10.w),
                color: AppColors.white,
                borderRadius:
                BorderRadius.circular(27.w),
                onPressed: () async {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.only(
                          topRight:
                          Radius.circular(16.w),
                          topLeft:
                          Radius.circular(16.w),
                        ),
                      ),
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                            builder:
                                (BuildContext context,
                                StateSetter
                                setState) {
                              return Padding(
                                padding:
                                EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 32.h),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    HBox(32.h),
                                    Text(
                                      'Почему вы хотите отклонить специалиста?',
                                      style: AppTextStyles
                                          .body14W500
                                          .copyWith(
                                        color: AppColors
                                            .black,
                                      ),
                                    ),
                                    ListView.builder(
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                      listOfExpertise
                                          .length,
                                      itemBuilder:
                                          (_, i) {
                                        return CheckboxListTile(
                                          contentPadding:
                                          EdgeInsets
                                              .zero,
                                          checkboxShape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  30.h)),
                                          title: Text(
                                              listOfExpertise[
                                              i]),
                                          value:
                                          _isChecked[
                                          i],
                                          onChanged:
                                              (val) =>
                                              setState(
                                                      () {
                                                    _isChecked[
                                                    i] = val!;
                                                  }),
                                        );
                                      },
                                    ),
                                    HBox(16.h),
                                    GestureDetector(
                                      onTap: () async =>
                                      await RestServices()
                                          .cancelSpecialist(
                                          widget
                                              .chatId),
                                      child: Container(
                                        width:
                                        MediaQuery.of(
                                            context)
                                            .size
                                            .width,
                                        alignment:
                                        Alignment
                                            .center,
                                        padding: EdgeInsets
                                            .symmetric(
                                            vertical:
                                            8.h,
                                            horizontal:
                                            10.w),
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              16.w),
                                          border: Border.all(
                                              color:
                                              AppColors
                                                  .red,
                                              width: 1.w),
                                        ),
                                        child: Text(
                                          'Отклонить специалиста',
                                          style: TextStyle(
                                              fontSize:
                                              14.sp,
                                              fontWeight:
                                              FontWeight
                                                  .w500,
                                              color:
                                              AppColors
                                                  .red),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      }).then((value) => setState((){}));
                  await Future.delayed(Duration(milliseconds: 200));
                  await _loadMessages();
                  setState(() {});
                },
                child: Text(
                  'Отклонить специалиста',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskApprovedCanceledWorkerForClient(){
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 30.h,
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w),
                    color: AppColors
                        .additionalGreenMediumButton,
                    borderRadius:
                    BorderRadius.circular(
                        27.w),
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext
                        context) {
                          return StatefulBuilder(
                              builder: (BuildContext
                              context,
                                  StateSetter
                                  setState) {
                                return AlertDialog(
                                  content: Text(
                                    'Вы хотите завершить работу! Работа была действительно завершена?',
                                    style: AppTextStyles
                                        .body14W500
                                        .copyWith(
                                        color: AppColors
                                            .primary),
                                  ),
                                  actions: [
                                    GestureDetector(
                                      onTap: () =>
                                          Navigator.pop(
                                              context),
                                      child:
                                      Container(
                                        height: 30.h,
                                        padding: EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            4.w),
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              27.w),
                                          border: Border.all(
                                              color: AppColors
                                                  .red,
                                              width:
                                              1),
                                        ),
                                        alignment:
                                        Alignment
                                            .center,
                                        child: Text(
                                          'Нет, работа не окончена',
                                          style: AppTextStyles
                                              .body14W500
                                              .copyWith(
                                              color:
                                              AppColors.red),
                                        ),
                                      ),
                                    ),
                                    HBox(8.w),
                                    GestureDetector(
                                      onTap:
                                          () async {
                                        await RestServices()
                                            .approveSpecialistAfterTask(
                                            widget
                                                .chatId);
                                        await _loadMessages();
                                        await updatePage();
                                        setState(
                                                () {});
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                CreateRateWorker(
                                                    username: listChatAll
                                                        .username ??
                                                        '',
                                                    chatId:
                                                    widget.chatId ?? '',
                                                    list: listChatAll),
                                          ),
                                        ).then((value) => setState(() {
                                          _loadMessages();
                                          updatePage();
                                        }));
                                      },
                                      child:
                                      Container(
                                        height: 30.h,
                                        padding: EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            4.w),
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              27.w),
                                          border: Border.all(
                                              color: AppColors
                                                  .additionalGreenMediumButton,
                                              width:
                                              1),
                                        ),
                                        alignment:
                                        Alignment
                                            .center,
                                        child: Text(
                                          'Да, завершить работу',
                                          style: AppTextStyles
                                              .body14W500
                                              .copyWith(
                                              color:
                                              AppColors.additionalGreenMediumButton),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      ).then((value) => setState((){
                        _loadMessages();
                      }));
                      await Future.delayed(Duration(milliseconds: 200));

                      await _loadMessages();
                      await updatePage();
                      setState(() {});
                    },
                    child: Text(
                      'Завершить работу',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight:
                          FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(
                          27.w),
                      border: Border.all(
                          color: AppColors.red,
                          width: 1)),
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w),
                    color: AppColors.white,
                    borderRadius:
                    BorderRadius.circular(
                        27.w),
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext
                        context) {
                          return StatefulBuilder(
                              builder: (BuildContext
                              context,
                                  StateSetter
                                  setState) {
                                return AlertDialog(
                                  content: Text(
                                    'Вы хотите отменить сделку с данным специалистом. После отмены вы не сможете с ним связаться. Вы уверены?',
                                    style: AppTextStyles
                                        .body14W500
                                        .copyWith(
                                        color: AppColors
                                            .primary),
                                  ),
                                  actions: [
                                    GestureDetector(
                                      onTap: () =>
                                          Navigator.pop(
                                              context),
                                      child:
                                      Container(
                                        height: 30.h,
                                        padding: EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            4.w),
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              27.w),
                                          border: Border.all(
                                              color: AppColors
                                                  .additionalGreenMediumButton,
                                              width:
                                              1),
                                        ),
                                        alignment:
                                        Alignment
                                            .center,
                                        child: Text(
                                          'Нет, продолжу работать',
                                          style: AppTextStyles
                                              .body14W500
                                              .copyWith(
                                              color:
                                              AppColors.additionalGreenMediumButton),
                                        ),
                                      ),
                                    ),
                                    HBox(8.w),
                                    GestureDetector(
                                      onTap:
                                          () async {
                                        await RestServices()
                                            .cancelSpecialistAfterTask(
                                            widget
                                                .chatId);
                                        await updatePage();
                                        await _loadMessages();
                                        setState(
                                                () {});
                                      },
                                      child:
                                      Container(
                                        height: 30.h,
                                        padding: EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            4.w),
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              27.w),
                                          border: Border.all(
                                              color: AppColors
                                                  .red,
                                              width:
                                              1),
                                        ),
                                        alignment:
                                        Alignment
                                            .center,
                                        child: Text(
                                          'Да, отменить сделку',
                                          style: AppTextStyles
                                              .body14W500
                                              .copyWith(
                                              color:
                                              AppColors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      ).then((value) => setState((){
                        _loadMessages();
                      }));
                      await Future.delayed(Duration(milliseconds: 200));
                      await _loadMessages();
                      await updatePage();
                      setState(() {});
                    },
                    child: Text(
                      'Отменить сделку',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight:
                          FontWeight.w500,
                          color: AppColors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget rejectView(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listOfExpertise.length,
      itemBuilder: (_, i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(listOfExpertise[i]),
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.h)),
              value: _isChecked[i],
              onChanged: (val) => setState(() {
                _isChecked[i] = val!;
              }),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, messagesList.first.content);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          title: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePersonInfo(
                    username: listChatAll.username ?? '',
                  ),
                ),
              );
            },
            leading: listChatAll.photoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(listChatAll.photoUrl ?? ''),
                  )
                : Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.white),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 25.h,
                    ),
                  ),
            title: Text(listChatAll.userFullName ?? '',
                style: theme.textTheme.headline6
                    ?.copyWith(color: AppColors.white)),
          ),
        ),
        body: loadingPage
         ? const LoadSimmer()
        :
        Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => listChatAll.type == "TASK" ?
                              DetailTaskScreen(
                                  id: widget.id!.toInt(),
                                  myTask:
                                  profile.isClient! ? false : true)
                          :DetailWorkerScreen(
                                  id: widget.id!.toInt(),
                                  myPublication:
                                  profile.isClient! ? false : true),
                          ),);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        listChatAll.type == "TASK" ?
                        widget.modelTask!.files.isNotEmpty
                            ? Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.w),
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(widget.modelTask!.files.first.url))),
                        )
                            : Container(
                            height: 40.h,
                            width: 40.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColors.graySearch,
                            ),
                            child: const Text(
                              'Нет фото',
                              textAlign: TextAlign.center,
                            ))
                            : widget.modelPub!.files.isNotEmpty
                        ? Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.w),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                  image: NetworkImage(widget.modelPub?.files.first.url ?? ''),)),
                        )
                            : Container(
                            height: 40.h,
                            width: 40.w,
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
                                  listChatAll.type == "TASK"
                                  ?
                                  widget.modelTask?.user.fullName ?? ''
                                  : widget.modelPub?.user.fullName ?? '',
                                  maxLines: 1,
                                )),
                            listChatAll.type == "TASK"
                                ?
                            SizedBox(
                              width: 250,
                              child: widget.modelTask!.isContractual
                                  ? const Text("договорная")
                                  : Text(
                                  "до ${widget.modelTask!.price.toInt().toString()} ₸"),
                            ) : SizedBox(
                              width: 250,
                              child: widget.modelPub!.isContractual
                                  ? const Text("договорная")
                                  : Text(
                                  "от ${widget.modelPub!.price.toInt().toString()} ₸"),
                            ),
                          ],
                        ),
                        Text(listChatAll.type == "TASK" ? widget.modelTask!.city : widget.modelPub!.city)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1.h,
                  color: AppColors.grayDark.withOpacity(0.5),
                ),
                Expanded(
                  child: messagesList.isNotEmpty
                      ? loading
                          ? const LoadSimmer()
                          : ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              controller: _scrollController,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              itemCount: messagesList.length,
                              itemBuilder: (context, index) {
                                messagesList
                                    .sort((a, b) => b.id!.compareTo(a.id!));

                                if (messagesList[index].senderUsername ==
                                    profile.username) {
                                  return Column(
                                    children: [
                                      isClientService
                                          ? messagesList[index]
                                                  .isSystemContent!
                                              ? getMessageByStatus(
                                                  messagesList[index]
                                                          .content ??
                                                      '')
                                              : const SizedBox()
                                          : messagesList[index]
                                                  .isSystemContent!
                                              ? getMessageByStatusWorker(
                                                  messagesList[index]
                                                          .content ??
                                                      '')
                                              : const SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          !messagesList[index]
                                                  .isSystemContent!
                                              ? Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 250.h),
                                                  padding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 24.w,
                                                          vertical: 12.h),
                                                  margin: EdgeInsets.only(
                                                      right: 12.w,
                                                      bottom: 12.h),
                                                  decoration: BoxDecoration(
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: AppColors.white,
                                                  ),
                                                  child: Text(
                                                    messagesList[index]
                                                            .content ??
                                                        '',
                                                    style: theme
                                                        .textTheme.bodyText2
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .primary),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      Column(
                                        children: [
                                          isClientService
                                              ? messagesList[index]
                                                      .isSystemContent!
                                                  ? getMessageByStatus(
                                                      messagesList[index]
                                                              .content ??
                                                          '')
                                                  : const SizedBox()
                                              : messagesList[index]
                                                      .isSystemContent!
                                                  ? getMessageByStatusWorker(
                                                      messagesList[index]
                                                              .content ??
                                                          '')
                                                  : const SizedBox(),
                                          !messagesList[index]
                                                  .isSystemContent!
                                              ? Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 250.h),
                                                  padding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 24.w,
                                                          vertical: 12.h),
                                                  margin: EdgeInsets.only(
                                                      left: 12.w, bottom: 12.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: AppColors.primary,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          messagesList[index]
                                                                  .content ??
                                                              '',
                                                          style: theme
                                                              .textTheme
                                                              .bodyText2
                                                              ?.copyWith(
                                                                  color: AppColors
                                                                      .white)),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              })
                      : const AlertDialog(
                          content: CupertinoActivityIndicator(
                          color: AppColors.primary,
                          radius: 25,
                          animating: true,
                        )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      listChatAll.status == "TASK_REQUEST_FROM_EXECUTOR" &&
                              isClientService
                          ? selectRejectWorkerForClient()
                          : listChatAll.status == "TASK_APPROVED" &&
                                  isClientService
                              ? taskApprovedCanceledWorkerForClient()
                              : listChatAll.status ==
                                          'PUBLICATION_CHAT_ACTIVE' &&
                                      isClientService
                                  ? Container(
                                    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                    height: 30.h,
                                    width: MediaQuery.of(context).size.width,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                          horizontal: 10.w),
                                      color: AppColors
                                          .additionalGreenMediumButton,
                                      borderRadius:
                                          BorderRadius.circular(
                                              27.w),
                                      onPressed: () async {
                                        showModalBottomSheet(
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius
                                                          .only(
                                                    topRight: Radius
                                                        .circular(
                                                            16.w),
                                                    topLeft: Radius
                                                        .circular(
                                                            16.w),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (_) {
                                                  return StatefulBuilder(builder:
                                                      (BuildContext
                                                              context,
                                                          StateSetter
                                                              setState) {
                                                    return Container(
                                                      height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          1.2,
                                                      padding: EdgeInsets.symmetric(
                                                          vertical:
                                                              8.h,
                                                          horizontal:
                                                              24.w),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: AppColors
                                                            .white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  16.w),
                                                          topLeft: Radius
                                                              .circular(
                                                                  16.w),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Вы действительно хотите выбрать специалиста? После вызавершения работы не забудьте оставить отзыв специалисту',
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: AppTextStyles
                                                                .body14W500,
                                                          ),
                                                          HBox(
                                                              16.h),
                                                          Container(
                                                            alignment:
                                                                Alignment.center,
                                                            child: FutureBuilder(
                                                                future: RestServices().getProfileByUsername(userName: listChatAll.username ?? ''),
                                                                builder: (_, AsyncSnapshot snapshots) {
                                                                  if (snapshots.hasData) {
                                                                    GetProfile profile = snapshots.data;
                                                                    return GestureDetector(
                                                                      onTap: () => Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => ProfilePersonInfo(
                                                                            username: profile.username ?? '',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child: Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          profile.photoUrl == null
                                                                              ? CircleAvatar(
                                                                                  backgroundColor: AppColors.primary,
                                                                                  radius: 39.w,
                                                                                  child: Icon(
                                                                                    Icons.person,
                                                                                    color: AppColors.white,
                                                                                    size: 14.w,
                                                                                  ),
                                                                                )
                                                                              : CircleAvatar(
                                                                                  backgroundColor: AppColors.primary,
                                                                                  radius: 39.w,
                                                                                  backgroundImage: NetworkImage(profile.photoUrl),
                                                                                ),
                                                                          SizedBox(
                                                                            width: 16.w,
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "${profile.name ?? ''} ${profile.lastname ?? ''}",
                                                                                style: AppTextStyles.h18Regular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.h, color: AppColors.blackGreyText),
                                                                              ),
                                                                              HBox(6.h),
                                                                              Text(
                                                                                'На REMONT.KZ c ${formatMonthNamedDate(profile.createdDate!)}',
                                                                                style: AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),
                                                                              ),
                                                                              HBox(6.h),
                                                                              Center(
                                                                                child: FutureBuilder(
                                                                                    future: RestServices().getProfileSession(userName: profile.username ?? ''),
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
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return CircularProgressIndicator();
                                                                  }
                                                                }),
                                                          ),
                                                          HBox(
                                                              16.h),
                                                          SizedBox(
                                                            height:
                                                                50.h,
                                                            width: MediaQuery.of(context)
                                                                .size
                                                                .width,
                                                            child: CupertinoButton(
                                                                color: Colors.green,
                                                                child: Text(
                                                                  'Да, выбрать специалиста',
                                                                  style: AppTextStyles.body14Secondary.copyWith(color: AppColors.white),
                                                                ),
                                                                onPressed: () async {
                                                                  await RestServices().selectSpecialist(widget.chatId);
                                                                  await updatePage();
                                                                  setState(() {});
                                                                }),
                                                          ),
                                                          HBox(8.h),
                                                          Container(
                                                            width: MediaQuery.of(context)
                                                                .size
                                                                .width,
                                                            height:
                                                                50.h,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(8.w),
                                                                border: Border.all(color: AppColors.grayDark, width: 1)),
                                                            child:
                                                                CupertinoButton(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 2.h,
                                                                  horizontal: 4.w),
                                                              color:
                                                                  AppColors.white,
                                                              borderRadius:
                                                                  BorderRadius.circular(8.w),
                                                              onPressed:
                                                                  () {
                                                                Navigator.pop(context);
                                                                setState(() {});
                                                              },
                                                              child:
                                                                  Text(
                                                                'Нет, я решил выбрать другого',
                                                                style:
                                                                    AppTextStyles.body14Secondary.copyWith(color: AppColors.primaryGray),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                                });
                                        await updatePage();
                                        await _loadMessages();
                                        setState(() {});
                                      },
                                      child: Text(
                                        'Выбрать специалиста',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight:
                                                FontWeight.w500),
                                      ),
                                    ),
                                  )
                                  : const SizedBox(),
                      listChatAll.status == "TASK_COMPLETED" &&
                              isClientService == false
                          ? Row(
                              children: [
                                Image.asset(
                                  'assets/icons/emoji_best.png',
                                  width: 50.w,
                                  height: 50.h,
                                ),
                                WBox(4.w),
                                Flexible(
                                  child: Text(
                                    "Поздравляем! Вы завершили работу! Можете попросить заказчика оставить вам отзыв!",
                                    style: AppTextStyles.body14W500.copyWith(
                                        color: AppColors
                                            .additionalGreenMediumButton),
                                  ),
                                ),
                              ],
                            )
                          : listChatAll.status == "TASK_COMPLETED" &&
                                  isClientService
                              ? !serviceBool
                                  ? Container(
                                      margin: EdgeInsets.all(8.h),
                                      height: 30.h,
                                      width:
                                          MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                          color: AppColors
                                              .additionalGreenMediumButton),
                                      child: CupertinoButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 10.w),
                                        color: AppColors
                                            .additionalGreenMediumButton,
                                        borderRadius:
                                            BorderRadius.circular(4.w),
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CreateRateWorker(
                                                      username: listChatAll
                                                              .username ??
                                                          '',
                                                      chatId:
                                                          widget.chatId ?? '',
                                                      list: listChatAll),
                                            ),
                                          ).then((value) => setState(() {
                                                updatePage();
                                              }));
                                          await updatePage();
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Оставить отзыв',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.white),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                      listChatAll.status ==
                                  "PUBLICATION_APPROVED_BY_CLIENT" &&
                              isClientService == false
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 30.h,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 10.w),
                                        color: AppColors
                                            .additionalGreenMediumButton,
                                        borderRadius:
                                            BorderRadius.circular(27.w),
                                        onPressed: () async {
                                          showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return AlertDialog(
                                                  content: Text(
                                                    'Вы действительно хотите подтвердить работу и начать её выполнение?',
                                                    style: AppTextStyles
                                                        .body14W500
                                                        .copyWith(
                                                            color: AppColors
                                                                .primary),
                                                  ),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Container(
                                                        height: 30.h,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      27.w),
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .red,
                                                              width: 1),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Нет, я не готов к выполнению',
                                                          style: AppTextStyles
                                                              .body14W500
                                                              .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .red),
                                                        ),
                                                      ),
                                                    ),
                                                    HBox(8.w),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await RestServices()
                                                            .confirmWork(
                                                                widget
                                                                    .chatId);
                                                        await updatePage();
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        height: 30.h,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      27.w),
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .additionalGreenMediumButton,
                                                              width: 1),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Да, подтвердить',
                                                          style: AppTextStyles
                                                              .body14W500
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .additionalGreenMediumButton),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                            },
                                          );
                                          await updatePage();
                                          await _loadMessages();
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Подтвердить работу',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Container(
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(27.w),
                                          border: Border.all(
                                              color: AppColors.red,
                                              width: 1.w)),
                                      child: CupertinoButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 10.w),
                                        color: AppColors.white,
                                        borderRadius:
                                            BorderRadius.circular(27.w),
                                        onPressed: () async {
                                          showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return AlertDialog(
                                                  content: Text(
                                                    'Вы действительно хотите отклонить работу? После её отклонения, вы не сможете приступить к выполнению этого задания.',
                                                    style: AppTextStyles
                                                        .body14W500
                                                        .copyWith(
                                                            color: AppColors
                                                                .primary),
                                                  ),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await RestServices()
                                                            .rejectWorkWorker(
                                                                widget
                                                                    .chatId);
                                                        await updatePage();
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        height: 30.h,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      27.w),
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .red,
                                                              width: 1),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Да, отклонить',
                                                          style: AppTextStyles
                                                              .body14W500
                                                              .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .red),
                                                        ),
                                                      ),
                                                    ),
                                                    HBox(8.w),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      child: Container(
                                                        height: 30.h,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      27.w),
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .additionalGreenMediumButton,
                                                              width: 1),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Нет, я выполню эту работу',
                                                          style: AppTextStyles
                                                              .body14W500
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .additionalGreenMediumButton),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                            },
                                          );
                                          await updatePage();
                                          await _loadMessages();
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Отклонить работу',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : listChatAll.status ==
                                      "PUBLICATION_REJECTED_WORK" &&
                                  isClientService
                              ? !serviceBool
                                  ? GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CreateRateWorker(
                                                username:
                                                    listChatAll.username ??
                                                        '',
                                                chatId: widget.chatId ?? '',
                                                list: listChatAll),
                                          ),
                                        ).then((value) => setState(() {
                                              updatePage();
                                            }));
                                        await updatePage();
                                        setState(() {});
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 4.h),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(

                                          borderRadius:
                                              BorderRadius.circular(4.h),
                                          color: AppColors
                                              .additionalGreenMediumButton,
                                        ),
                                        child: Text(
                                          'Оставить отзыв',
                                          style: AppTextStyles.body14W500
                                              .copyWith(
                                                  color: AppColors.white),
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                              : listChatAll.status ==
                                          "PUBLICATION_CONFIRMED_WORK" &&
                                      isClientService == false
                                  ? Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                setState) {
                                                  return AlertDialog(
                                                    content: Text(
                                                      'Вы хотите завершить работу! Работа была действительно завершена и заказчик остался доволен?',
                                                      style: AppTextStyles
                                                          .body14W500
                                                          .copyWith(
                                                              color: AppColors
                                                                  .primary),
                                                    ),
                                                    actions: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Container(
                                                          height: 30.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      4.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        27.w),
                                                            border: Border.all(
                                                                color:
                                                                    AppColors
                                                                        .red,
                                                                width: 1),
                                                          ),
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                            'Нет, работа не окончена',
                                                            style: AppTextStyles
                                                                .body14W500
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .red),
                                                          ),
                                                        ),
                                                      ),
                                                      HBox(8.w),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await RestServices()
                                                              .completeWorkWorker(
                                                                  widget
                                                                      .chatId);
                                                          await _loadMessages();
                                                          await updatePage();
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          height: 30.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      4.w),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        27.w),
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .additionalGreenMediumButton,
                                                                width: 1),
                                                          ),
                                                          alignment: Alignment
                                                              .center,
                                                          child: Text(
                                                            'Да, завершить работу',
                                                            style: AppTextStyles
                                                                .body14W500
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .additionalGreenMediumButton),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                              },
                                            ).then((value) => setState((){
                                              _loadMessages();
                                            }));
                                            await updatePage();
                                            await _loadMessages();
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 4.h),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.h),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.h),
                                              color: AppColors
                                                  .additionalGreenMediumButton,
                                            ),
                                            child: Text(
                                              'Завершить работу',
                                              style: AppTextStyles.body14W500
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : listChatAll.status ==
                                              "PUBLICATION_COMPLETED_WORK" &&
                                          isClientService == false
                                      ? Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/emoji_best.png',
                                              width: 50.w,
                                              height: 50.h,
                                            ),
                                            WBox(4.w),
                                            Flexible(
                                              child: Text(
                                                "Поздравляем! Вы завершили работу! Можете попросить заказчика оставить вам отзыв!",
                                                style: AppTextStyles
                                                    .body14W500
                                                    .copyWith(
                                                        color: AppColors
                                                            .additionalGreenMediumButton),
                                              ),
                                            ),
                                          ],
                                        )
                                      : listChatAll.status ==
                                                  "PUBLICATION_COMPLETED_WORK" &&
                                              isClientService
                                          ? serviceBool
                                              ? SizedBox()
                                              : Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) => CreateRateWorker(
                                                                username:
                                                                    listChatAll
                                                                            .username ??
                                                                        '',
                                                                chatId: widget
                                                                        .chatId ??
                                                                    '',
                                                                list:
                                                                    listChatAll),
                                                          ),
                                                        );
                                                        await updatePage();
                                                        await _loadMessages();
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16.w,
                                                                vertical:
                                                                    4.h),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    12.h),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.h),
                                                          color: AppColors
                                                              .additionalGreenMediumButton,
                                                        ),
                                                        child: Text(
                                                          'Оставить отзыв',
                                                          style: AppTextStyles
                                                              .body14W500
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .white),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                          : const SizedBox(),
                      listChatAll.status == "TASK_CANCELED" && isClientService
                          ? const SizedBox()
                          : listChatAll.status == "TASK_REJECTED" &&
                                  isClientService
                              ? const SizedBox()
                              : listChatAll.status == "TASK_REJECTED" &&
                                      isClientService == false
                                  ? Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/emoji_sad.png',
                                          width: 50.w,
                                          height: 50.h,
                                        ),
                                        WBox(4.w),
                                        Text(
                                          "Сожалеем, но заказчик отклонил ваш отклик",
                                          style: AppTextStyles.body14W500
                                              .copyWith(color: AppColors.red),
                                        ),
                                      ],
                                    )
                                  : listChatAll.status == "TASK_CANCELED" &&
                                          isClientService == false
                                      ? Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/emoji_sad.png',
                                              width: 50.w,
                                              height: 50.h,
                                            ),
                                            WBox(4.w),
                                            Flexible(
                                              child: Text(
                                                "Сожалеем, но заказчик отменил сделку. Вы больше не сможете ответить на неё",
                                                style: AppTextStyles
                                                    .body14W500
                                                    .copyWith(
                                                        color: AppColors.red),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          margin: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                offset: const Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 8,
                                                left: 8,
                                                bottom: 12.h,
                                                top: 8),
                                            child: Stack(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:  EdgeInsets.only(left: 8.w),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            launch(
                                                                "tel://${formatPhone(listChatAll.username ?? '')}");
                                                          },
                                                          child:  Icon(
                                                              Icons
                                                                  .phone_callback_outlined,
                                                              size: 28.h,
                                                              color: AppColors
                                                                  .additionalGreenMediumButton),
                                                        ),
                                                      ),
                                                    ),
                                                    WBox(6.w),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets.only(
                                                                      bottom:
                                                                          5.h),
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        textController,
                                                                    minLines:
                                                                        1,
                                                                    maxLines:
                                                                        5,
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      contentPadding: EdgeInsets.only(
                                                                          right:
                                                                              16.w,
                                                                          left: 20.w,
                                                                          bottom: 10.h,
                                                                          top: 10.h),
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.grey.shade700),
                                                                      hintText:
                                                                          'Type a message',
                                                                      border:
                                                                          InputBorder.none,
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          AppColors.white,
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        gapPadding:
                                                                            0,
                                                                        borderSide:
                                                                            BorderSide(color: Colors.grey.shade200),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        gapPadding:
                                                                            0,
                                                                        borderSide:
                                                                            const BorderSide(color: AppColors.black),
                                                                      ),
                                                                    ),
                                                                    onChanged:
                                                                        (value) {},
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          splashRadius: 20.h,
                                                          icon: const Icon(
                                                              Icons.send,
                                                              color: AppColors
                                                                  .primary),
                                                          onPressed:
                                                              () async {
                                                            final trimmedText =
                                                                textController
                                                                    .text
                                                                    .trim();

                                                            // Check if the trimmed text is empty
                                                            if (trimmedText
                                                                .isEmpty) {
                                                              // Text is empty or contains only whitespace characters, do not send the message
                                                              return;
                                                            } else {
                                                              await sendMessages(
                                                                  textController
                                                                      .text,
                                                                  context);
                                                              textController
                                                                  .clear();
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
