import 'package:dependencies/dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/chat/chat_list_model.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/screens/chat/chat_type_screen.dart';
import 'package:remont_kz/screens/chat/chat_widget/load_shimmer.dart';
import 'package:remont_kz/screens/chat/chat_widget/show_all_chat_publication.dart';
import 'package:remont_kz/screens/chat/chat_widget/show_all_chat_task.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/no_user.dart';
import 'package:collection/collection.dart';
import 'package:remont_kz/utils/global_widgets/publication_card_view.dart';
import 'package:remont_kz/utils/global_widgets/task_card_view.dart';

class ChatScreens extends StatefulWidget {
  bool isClient = false;
  ChatScreens({Key? key, this.isClient = false}) : super(key: key);

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int indexPage = 0;
  int pages = 1;
  var loading = true;
  var loadingPublication = true;
  GetProfile profile = GetProfile();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loadProfile = await RestServices().getMyProfile();
        if (mounted) {
          setState(() {
            newMessage = false;
            profile = loadProfile;
            loading = false;
          });
        }
      } catch (e) {
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
    final tokenStore = getIt.get<TokenStoreService>();
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
      body: tokenStore.accessToken == null
          ? const NoAuthPageView()
          : loading
              ? const LoadSimmer()
              : Padding(
        padding: EdgeInsets.only(top: 12.h, left: 12.h, right: 12.h),
          child: myRequest())
    );
  }

  Widget myRequest() {
    return SingleChildScrollView(
      child: Column(
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
                        border: Border.all(width: 1.w, color: AppColors.primary),
                        color:
                            indexPage == 0 ? AppColors.primary : AppColors.white),
                    alignment: Alignment.center,
                    child: Text(
                      profile.isClient! ? 'Заявки' : 'Мои объявления',
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
                        border: Border.all(width: 1.w, color: AppColors.primary),
                        color:
                            indexPage == 1 ? AppColors.primary : AppColors.white),
                    child: Text(
                      profile.isClient! ? 'Мои задания' : 'Отклики на задание',
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
                        border: Border.all(width: 1.w, color: AppColors.primary),
                        color:
                            indexPage == 2 ? AppColors.primary : AppColors.white),
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
          HBox(12.h),
          indexPage == 0
              ? profile.isClient!
                  ? getPublicationForClient()
                  : getMyPublication()
              : indexPage == 1
                  ? !profile.isClient!
                      ? getTaskForWorker()
                      : getMyActiveTask()
                  : buildCompleteView(),
        ],
      ),
    );
  }

  ///ПУБЛИКАЦИЯ ИСПОЛНИТЕЛЯ ЗАЯВКИ ДЛЯ ЗАКАЗЧИКА
  Widget getPublicationForClient() {
    return FutureBuilder(
      future: RestServices().getMyActivateRequestPub(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
              radius: 25,
              animating: true,
            ),
          );
        }
        if (snapshot.hasData) {
          List<ChatList> model = snapshot.data;
          final groupedPublication = groupBy(model, (task) => task.typeId);
          return buildPublicationView(groupedPublication);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildPublicationView(var groupedPublication) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: groupedPublication.length,
      itemBuilder: (context, index) {
        final typeId = groupedPublication.keys.elementAt(index);
        return FutureBuilder(
            future: RestServices().getPublicationById(typeId ?? 0),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                PublicationModel publicationModel = snapshot.data;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MessagePage(
                              modelPub: publicationModel,
                              categoryId: publicationModel.categoryId,
                              chatId: groupedPublication[typeId].first.id.toString(),
                              id: publicationModel.id,
                              index: 0,
                            ),
                          ),
                        ).then((value) => setState((){}));
                      },
                      child: PublicationCardView(
                        items: publicationModel,
                        onTap: null,
                        showStar: false,
                        isChat: true,
                      ),
                    ),
                    HBox(12.h)
                  ],
                );
              } else {
                return const SizedBox();
              }
            });
      },
    );
  }

  ///ПУБЛИКАЦИЯ ИСПОЛНИТЕЛЯ МОИ ОБЪЯВЛЕНИЕ ДЛЯ ИСПОЛНИТЕЛЯ
  Widget getMyPublication() {
    return FutureBuilder(
      future: RestServices().getMyActivatePublication(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
              radius: 25,
              animating: true,
            ),
          );
        }
        if (snapshot.hasData) {
          List<PublicationModel> model = snapshot.data;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                          builder: (_) => ShowPersonPublication(
                            competed: false,
                            publication: items,
                            isClients: profile.isClient!,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    child: PublicationCardView(
                      notShowDetail: true,
                      items: items,
                      showStar: false,
                      onTap: null,
                      isChat: true,
                    ),
                  ),
                  HBox(12.h)
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ///Отклики на задание ДЛЯ ИСПОЛНИТЕЛЯ
  Widget getTaskForWorker() {
    return FutureBuilder(
      future: RestServices().getActivateRequestTask(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
              radius: 25,
              animating: true,
            ),
          );
        }
        if (snapshot.hasData) {
          List<ChatList> model = snapshot.data;
          final groupedPublication = groupBy(model, (task) => task.typeId);
          return buildTaskView(groupedPublication);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildTaskView(var groupedTask) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: groupedTask.length,
      itemBuilder: (__, index) {
        final typeId = groupedTask.keys.elementAt(index);
        return FutureBuilder(
            future: RestServices().getTaskById(typeId ?? 0),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                TaskModel items = snapshot.data;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MessagePage(
                              modelTask: items,
                              chatId: groupedTask[typeId].first.id.toString(),
                              categoryId: items.categoryId,
                              index:  2,
                              id: items.id,
                            ),
                          ),
                        ).then((value) => setState((){}));
                      },
                      child: TaskCardView(
                        items: items,
                        notShowDescription: true,
                        isChat: true,
                      ),
                    ),
                    HBox(12.h),
                  ],
                );
              } else {
                return SizedBox();
              }
            });
      },
    );
  }

  ///Мои задания ДЛЯ ЗАКАЗЧИКА
  Widget getMyActiveTask() {
    return FutureBuilder(
        future: RestServices().getMyActivateTask(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.primary,
                radius: 25,
                animating: true,
              ),
            );
          }
          if (snapshot.hasData) {
            List<TaskModel> model = snapshot.data;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.length,
              itemBuilder: (context, index) {
                TaskModel items = model[index];
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShowPersonTask(
                                isClients: widget.isClient,
                                publication: items,
                              ),
                            ),
                          ).then((value) => setState(() {}));
                        },
                        child: TaskCardView(items: items, isChat: true, notShowDescription: true,),
                      ),
                      HBox(12.h)
                    ],
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        });
  }



 ///Завершенные чаты
  Widget buildCompleteView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                pages = 1;
                setState(() {});
              },
              child: Container(
                height: 35.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(width: 1.w, color: AppColors.primary),
                    color: pages == 1 ? AppColors.primary : AppColors.white),
                child: Text(
                  profile.isClient! ? 'Мои задания' : 'Отклики на задание',
                  style: AppTextStyles.body14W500.copyWith(
                      fontWeight: FontWeight.w400,
                      color: pages == 1
                          ? AppColors.white
                          : AppColors.blackGreyText),
                ),
              ),
            ),
            WBox(16.w),
            GestureDetector(
              onTap: () {
                pages = 2;
                setState(() {});
              },
              child: Container(
                height: 35.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(width: 1.w, color: AppColors.primary),
                    color: pages == 2 ? AppColors.primary : AppColors.white),
                child: Text(
                  profile.isClient! ? 'Заявки' : 'Мои объявления',
                  style: AppTextStyles.body14W500.copyWith(
                      fontWeight: FontWeight.w400,
                      color: pages == 2
                          ? AppColors.white
                          : AppColors.blackGreyText),
                ),
              ),
            ),
          ],
        ),
        HBox(12.h),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            !profile.isClient!
                ? pages == 1
                    ? buildCompleteTaskForWorker()
                    : buildPublication()
                : pages == 1
                    ? buildCompleteTaskForClient()
                    : buildCompetedPublicationForClient()
          ],
        ),
      ],
    );
  }

  ///Завершенные оклики на задание ДЛЯ ИСПОЛНИТЕЛЯ
  Widget buildCompleteTaskForWorker() {
    return FutureBuilder(
      future: RestServices().getCompleteTaskForWorker(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
              radius: 25,
              animating: true,
            ),
          );
        }
        if (snapshot.hasData) {
          List<ChatList> model = snapshot.data;
          final groupedPublication = groupBy(model, (task) => task.typeId);
          return buildTask(groupedPublication);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildTask(var groupedTask) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: groupedTask.length,
        itemBuilder: (_, index) {
          final typeId = groupedTask.keys.elementAt(index);
          return FutureBuilder(
              future: RestServices().getTaskById(typeId ?? 0),
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                } else if (snapshot.hasData) {
                  TaskModel items = snapshot.data;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async{
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MessagePage(
                                index:  4,
                                modelTask: items,
                                chatId: groupedTask[typeId].first.id.toString(),
                                categoryId: items.categoryId,
                                id: items.id,
                              ),
                            ),
                          ).then((value) => setState((){}));
                        },
                        child: TaskCardView(items: items,
                          notShowDescription: true,
                          isChat: true,
                        ),
                      ),
                      HBox(12.h),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              });
        });
  }

  ///Мои задания завершенные для Заказчика
  Widget buildCompleteTaskForClient() {
    return FutureBuilder(
      future: RestServices().getMyCompeteTask(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
              radius: 25,
              animating: true,
            ),
          );
        }
        if (snapshot.hasData) {
          return buildTaskForClient(snapshot.data);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildTaskForClient(List<TaskModel> taskList) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: taskList.length,
        itemBuilder: (_, index) {
          TaskModel items = taskList[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowPersonTaskSingle(
                        isClients: widget.isClient,
                        publication: items,
                      ),
                    ),
                  ).then((value) => setState(() {}));
                },
                child: TaskCardView(
                  items: items, isChat: true, notShowDescription: true,
                ),
              ),
              HBox(12.h)
            ],
          );
        });
  }


  ///Мои объявление завершенные для ИСПОЛНИТЕЛЯ
  Widget buildPublication() {
    return FutureBuilder(
      future: RestServices().getMyActivatePublication(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
              radius: 25,
              animating: true,
            ),
          );
        }
        if (snapshot.hasData) {
          List<PublicationModel> model = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                          builder: (_) => ShowPersonPublication(
                            competed: true,
                            publication: items,
                            isClients: profile.isClient!,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    child: PublicationCardView(
                      items: items,
                      isChat: true, showStar: false,
                      onTap: null,
                      notShowDetail: true,

                    ),
                  ),
                  HBox(12.h),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }


  ///Заявки завершенные для ЗАКАЗЧИКА
  Widget buildCompetedPublicationForClient() {
    return FutureBuilder(
      future: RestServices().getCompetedPublicationForClient(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
              radius: 25,
              animating: true,
            ),
          );
        }
        if (snapshot.hasData) {
          List<ChatList> model = snapshot.data;
          final groupedPublication = groupBy(model, (task) => task.typeId);
          return buildPublicationForClient(groupedPublication);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildPublicationForClient(var groupedPublication) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: groupedPublication.length,
      itemBuilder: (context, index) {
        final typeId = groupedPublication.keys.elementAt(index);
        return FutureBuilder(
            future: RestServices().getPublicationById(typeId ?? 0),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (snapshot.hasData) {
                PublicationModel publicationModel = snapshot.data;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MessagePage(
                              modelPub: publicationModel,
                              categoryId: publicationModel.categoryId,
                              chatId: groupedPublication[typeId].first.id.toString(),
                              id: publicationModel.id,
                              index:  6,
                            ),
                          ),
                        ).then((value) => setState((){}));
                      },
                      child: PublicationCardView(
                        items: publicationModel,
                        onTap: null,
                        showStar: false,
                      ),
                    ),
                    HBox(12.h),
                  ],
                );
              } else {
                return const SizedBox();
              }
            });
      },
    );
  }
}