import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/chat/chat_list_model.dart';
import 'package:collection/collection.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/work_for_worker/chat/chat_type_screen.dart';
import 'package:remont_kz/screens/work_for_worker/chat/chat_widget/load_shimmer.dart';
import 'package:remont_kz/screens/work_for_worker/chat/chat_widget/show_all_chat_publication.dart';
import 'package:remont_kz/screens/work_for_worker/chat/chat_widget/show_all_chat_task.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';

class ChatScreens extends StatefulWidget {
  bool isClient = false;
  ChatScreens({Key? key, this.isClient = false}) : super(key: key);

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens>
    with SingleTickerProviderStateMixin {
  final formatDate = DateFormat('HH:mm');
  TabController? _tabController;
  int indexPage = 0;
  late List<ChatList> loadPublicationChat;
  late PublicationModel publicationModel;
  var loading = true;
  var loadingPublication = true;
  GetProfile profile = GetProfile();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loadChat = await RestServices().getMyAllMessage();
        final loadProfile = await RestServices().getMyProfile();

        if (mounted) {
          setState(() {
            loadPublicationChat = loadChat;
            profile=loadProfile;
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

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Сообщения',
          style: AppTextStyles.h18Regular.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: loading?LoadSimmer():
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: myRequest(),
            ),
          ],
        ),
      ),
    );
  }

  Widget myRequest() {
    List<ChatList> model = loadPublicationChat;
    List<ChatList> activatedTasks =
    model.where((task) => task.type == 'PUBLICATION').toList();
    List<ChatList> completedTasks =
    model.where((task) => task.type == 'TASK').toList();

    final groupedPublication =
    groupBy(activatedTasks, (task) => task.typeId);

    final groupedTask = groupBy(completedTasks, (task) => task.typeId);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  indexPage = 0;
                  setState(() {});
                },
                child: Container(
                  height: 35.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(
                          width: 1.w, color: AppColors.primary),
                      color: indexPage == 0
                          ? AppColors.primary
                          : AppColors.white),
                  alignment: Alignment.center,
                  child: Text(
                    profileByChat.isClient! ? 'Заявки' : 'Мои объявления',
                    style: AppTextStyles.body14W500.copyWith(
                        fontWeight: FontWeight.w400,
                        color: indexPage == 0
                            ? AppColors.white
                            : AppColors.blackGreyText),
                  ),
                ),
              ),
              WBox(12.w),
              GestureDetector(
                onTap: () {
                  indexPage = 1;
                  setState(() {});
                },
                child: Container(
                  height: 35.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(
                          width: 1.w, color: AppColors.primary),
                      color: indexPage == 1
                          ? AppColors.primary
                          : AppColors.white),
                  child: Text(
                    profileByChat.isClient! ? 'Мои задания' : 'Отклики на задание',
                    style: AppTextStyles.body14W500.copyWith(
                        fontWeight: FontWeight.w400,
                        color: indexPage == 1
                            ? AppColors.white
                            : AppColors.blackGreyText),
                  ),
                ),
              ),
              WBox(12.w),
              GestureDetector(
                onTap: () {
                  indexPage = 2;
                  setState(() {});
                },
                child: Container(
                  height: 35.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(
                          width: 1.w, color: AppColors.primary),
                      color: indexPage == 2
                          ? AppColors.primary
                          : AppColors.white),
                  child: Text(
                    'Завершенные',
                    style: AppTextStyles.body14W500.copyWith(
                        fontWeight: FontWeight.w400,
                        color: indexPage == 2
                            ? AppColors.white
                            : AppColors.blackGreyText),
                  ),
                ),
              ),
            ],
          ),
        ),
        HBox(25.h),
        indexPage == 0
            ? buildPublicationView(groupedPublication)
            : indexPage == 1
            ? buildTaskView(groupedTask)
            : buildCompleteView(),
      ],
    );
  }

  Widget buildPublicationView(var groupedPublication){
    return Expanded(
      child: ListView.builder(
        itemCount: groupedPublication.length,
        itemBuilder: (context, index) {
          final typeId =
          groupedPublication.keys.elementAt(index);

          final publicationWithSameTypeId =
          groupedPublication[typeId]!;
          return FutureBuilder(
            future: RestServices().getPublicationById(typeId ?? 0),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return SizedBox(); // Or any other widget you want.
              }else if (snapshot.hasData) {
                publicationModel = snapshot.data;
                return GestureDetector(
                  onTap: () {
                    if (publicationModel.id == typeId) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShowPersonPublication(
                            isClients: widget.isClient,
                            items: publicationWithSameTypeId,
                            publication: publicationModel,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    }
                    setState(() {

                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.w, horizontal: 8.w),
                    margin:
                    EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              publicationModel.user.fullName,
                              style: AppTextStyles.h18Regular
                                  .copyWith(
                                  color:
                                  AppColors.primary,
                                  fontWeight:
                                  FontWeight.w400),
                            ),
                          ],
                        ),
                        publicationModel.isContractual
                            ? Text(
                          'Цена: договорная',
                          style: AppTextStyles
                              .body14Secondary,
                        )
                            : Text(
                          'Цена: ${publicationModel.price.toInt()} ₸',
                          style: AppTextStyles
                              .body14Secondary,
                        ),
                        HBox(8.h),
                        Row(
                          children: [
                            Stack(
                              children: [
                                publicationModel.files.isNotEmpty
                                    ? Container(
                                  height: 85.h,
                                  width: 140.w,
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        8.w),
                                    image:
                                    DecorationImage(
                                      image:
                                      NetworkImage(
                                          publicationModel
                                              .files
                                              .first
                                              .url),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                )
                                    : Container(
                                  height: 85.h,
                                  width: 140.w,
                                  decoration:
                                  BoxDecoration(
                                    color: AppColors
                                        .graySearch,
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        8.w),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: const [
                                      Icon(Icons
                                          .no_photography_outlined),
                                      Text('Нет фото')
                                    ],
                                  ),
                                ),
                                publicationModel.files.isNotEmpty?
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(
                                        vertical: 4.h,
                                        horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius
                                          .circular(4.w),
                                      color: AppColors.black
                                          .withOpacity(0.5),
                                    ),
                                    child: Text(
                                      "1/${publicationModel.files.length
                                          .toString()}",
                                      style: AppTextStyles
                                          .captionPrimary
                                          .copyWith(
                                          color: AppColors
                                              .white),
                                    ),
                                  ),
                                ) : SizedBox()
                              ],
                            ),
                            WBox(8.w),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  publicationModel.category,
                                  maxLines: 2,
                                  style: AppTextStyles
                                      .captionPrimary
                                      .copyWith(
                                      fontWeight:
                                      FontWeight
                                          .w600),
                                ),
                                HBox(16.h),
                                Container(
                                  width: 162.w,
                                  child: Text(
                                    publicationModel.description,
                                    style: AppTextStyles
                                        .body14Secondary
                                        .copyWith(
                                        fontSize: 10),
                                  ),
                                ),
                                HBox(4.h),
                                Text(
                                  publicationModel.city,
                                  style: AppTextStyles
                                      .body14Secondary
                                      .copyWith(
                                      fontSize: 10,
                                      color: AppColors
                                          .grayDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }else{
                return SizedBox();
              }

            }
          );
        },
      ),
    );
  }

  void getPublication(typeId) async {
    try {
      final fetchedPublication = await RestServices().getPublicationById(typeId ?? 0);

      if (mounted) {
        setState(() {
          publicationModel = fetchedPublication;
          loadingPublication = false;
        });
      }
    } catch (e) {
      // Handle any errors that might occur during the network request.
      print("Error fetching publication: $e");
    }
  }

  Widget buildTaskView(var groupedTask){
    return Expanded(
      child: ListView.builder(
        itemCount: groupedTask.length,
        itemBuilder: (__, index) {
          final typeId = groupedTask.keys.elementAt(index);
          final tasksWithSameTypeId = groupedTask[typeId]!;
          return FutureBuilder(
              future:
              RestServices().getTaskById(typeId ?? 0),
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SizedBox(); // Or any other widget you want.
                } else if (snapshot.hasData) {
                  TaskModel items = snapshot.data;
                  return GestureDetector(
                    onTap: () {
                      if (items.id == typeId) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShowPersonTask(
                              isClients: widget.isClient,
                              items: tasksWithSameTypeId,
                              publication: items,
                            ),
                          ),
                        ).then((value) => setState(() {}));
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.symmetric(
                          vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0,
                                3.h), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              items.files.isNotEmpty
                                  ? Container(
                                height: 160.h,
                                width: MediaQuery.of(
                                    context)
                                    .size
                                    .width,
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      6.w),
                                  image:
                                  DecorationImage(
                                    image:
                                    NetworkImage(
                                        items
                                            .files
                                            .first
                                            .url),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                                  : Container(
                                height: 160.h,
                                width: MediaQuery.of(
                                    context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        6.w),
                                    color: AppColors
                                        .graySearch),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: const [
                                    Icon(Icons
                                        .no_photography_outlined),
                                    Text('Нет фото')
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding:
                                  EdgeInsets.symmetric(
                                      vertical: 4.h,
                                      horizontal: 16.w),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .circular(4.w),
                                    color: AppColors.black
                                        .withOpacity(0.5),
                                  ),
                                  child: Text(
                                    items.files.length
                                        .toString(),
                                    style: AppTextStyles
                                        .captionPrimary
                                        .copyWith(
                                        color: AppColors
                                            .white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          HBox(12.h),
                          Text(
                            items.title,
                            style: AppTextStyles
                                .body14Secondary
                                .copyWith(
                                fontWeight:
                                FontWeight.w600),
                          ),
                          HBox(6.h),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                'Категория',
                                style: AppTextStyles
                                    .body14Secondary
                                    .copyWith(
                                    color: AppColors
                                        .primaryGray),
                              ),
                              Text(items.category,
                                  style: AppTextStyles
                                      .body14Secondary),
                            ],
                          ),
                          HBox(6.h),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                'Стоимость работ',
                                style: AppTextStyles
                                    .body14Secondary
                                    .copyWith(
                                    color: AppColors
                                        .primaryGray),
                              ),
                              items.isContractual
                                  ? Text("договорная",
                                  style: AppTextStyles
                                      .body14Secondary)
                                  : Text(
                                  "${items.price.toInt().toString()} ₸",
                                  style: AppTextStyles
                                      .body14Secondary),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              });
        },
      ),
    );
  }

  Widget buildCompleteView(){
    return Expanded(
      child: FutureBuilder(
          future: RestServices().getCompletedAllMessage(),
          builder: (BuildContext context,
              AsyncSnapshot dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (dataSnapshot.hasData) {
              List<ChatList> model = dataSnapshot.data;
              return ListView.builder(
                itemCount: model.length,
                itemBuilder: (context, index) {
                  model.sort((a, b) => a.time!.compareTo(b.time!));
                  ChatList items = model[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MessagePage(
                                  chatId: items.id.toString(),
                                  categoryId: 0,
                                ),
                              ),
                            ).then((value) => setState(() {}));
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: items.photoUrl == null
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
                                      items.photoUrl.toString(),
                                    ),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(30.h),
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(items.userFullName ?? ''),
                            subtitle: profile.isClient!
                                ? getMessageByStatus(items.lastMessage ?? '')
                                : getMessageByStatusWorker(items.lastMessage ?? ''),
                            trailing: Column(
                              children: [
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(formatDate.format(items.time ?? DateTime.now())),
                                SizedBox(
                                  height: 4.h,
                                ),
                                if (items.countOfNewMessages != null)
                                  Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4.h),
                                    ),
                                    child: Text(
                                      items.countOfNewMessages.toString(),
                                      style: AppTextStyles.bodyPrimary
                                          .copyWith(color: AppColors.white, fontSize: 12),
                                    ),
                                  )
                                else
                                  const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Нет данных'),
              );
            }
          }),
    );
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
      case "WORK_COMPLETED_AND_HAS_REVIEW":
        chatMes = "Поздравляем! Вы завершили работу!";
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
    }
    return Text(chatMes == '' ? message : chatMes);
  }
}