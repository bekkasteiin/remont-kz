import 'package:bottom_nav_layout/bottom_nav_layout.dart';import 'package:flutter/material.dart';import 'package:remont_kz/screens/create/create_task_screen.dart';import 'package:remont_kz/screens/task/category/category_screen.dart';import 'package:remont_kz/screens/task/main_screen/main_view_screen.dart';import 'package:remont_kz/screens/task/profile/my_profile_screen.dart';import 'package:remont_kz/screens/work_for_worker/chat/chat_screens.dart';import 'package:remont_kz/utils/app_colors.dart';class MainNavbar extends StatelessWidget {  const MainNavbar({Key? key}) : super(key: key);  @override  Widget build(BuildContext context) {    return BottomNavLayout(      pages: [        (_) => const MainScreen(),        (_) => CategoriesScreen(showLeading: false, isClient:true),        (_) => const CreateTaskScreen(),            (_) =>  ChatScreens(isClient: true,),        (_) => const MyProfileScreen(),      ],      bottomNavigationBar: (currentIndex, onTap) => Theme(          data: Theme.of(context).copyWith(            splashColor: Colors.transparent,            highlightColor: Colors.transparent,          ),          child: BottomNavigationBar(        type: BottomNavigationBarType.fixed,        currentIndex: currentIndex,        onTap: (index) => onTap(index),        items: const [          BottomNavigationBarItem(            icon: ImageIcon(AssetImage('assets/images/main.png')),            label: 'Главная',          ),          BottomNavigationBarItem(            icon: ImageIcon(AssetImage('assets/images/category.png')),            label: 'Категории',          ),          BottomNavigationBarItem(            icon: ImageIcon(AssetImage('assets/images/create.png')),            label: 'Создать',          ),          BottomNavigationBarItem(            icon: ImageIcon(AssetImage('assets/icons/send_message.png'),),            label: 'Сообщения',          ),          BottomNavigationBarItem(            icon: ImageIcon(AssetImage('assets/images/profile.png')),            label: 'Профиль',          ),        ],        selectedItemColor: AppColors.primary,        unselectedItemColor: AppColors.primaryGray,        backgroundColor: AppColors.white,        selectedFontSize: 10,        showUnselectedLabels: true,        unselectedFontSize: 10,      )),    );  }}