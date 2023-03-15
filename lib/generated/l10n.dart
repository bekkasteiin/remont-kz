// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Authontication`
  String get auth {
    return Intl.message(
      'Authontication',
      name: 'auth',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get currentLang {
    return Intl.message(
      'English',
      name: 'currentLang',
      desc: '',
      args: [],
    );
  }

  /// `Қазақша`
  String get kk {
    return Intl.message(
      'Қазақша',
      name: 'kk',
      desc: '',
      args: [],
    );
  }

  /// `Русский`
  String get ru {
    return Intl.message(
      'Русский',
      name: 'ru',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get en {
    return Intl.message(
      'English',
      name: 'en',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Встретьте свою праведную вторую половину`
  String get logoSubtitle {
    return Intl.message(
      'Встретьте свою праведную вторую половину',
      name: 'logoSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Hobby`
  String get interests {
    return Intl.message(
      'Hobby',
      name: 'interests',
      desc: '',
      args: [],
    );
  }

  /// `Изменить`
  String get change {
    return Intl.message(
      'Изменить',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Имею религиозное образование, окончил медресе. В свободное время стараюсь проводить в мечети`
  String get about {
    return Intl.message(
      'Имею религиозное образование, окончил медресе. В свободное время стараюсь проводить в мечети',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `General information`
  String get generalInfo {
    return Intl.message(
      'General information',
      name: 'generalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Religiosity`
  String get religiosity {
    return Intl.message(
      'Religiosity',
      name: 'religiosity',
      desc: '',
      args: [],
    );
  }

  /// `Финансовая обеспеченность`
  String get financial {
    return Intl.message(
      'Финансовая обеспеченность',
      name: 'financial',
      desc: '',
      args: [],
    );
  }

  /// `Красота и здоровье`
  String get beauty {
    return Intl.message(
      'Красота и здоровье',
      name: 'beauty',
      desc: '',
      args: [],
    );
  }

  /// `Нравственность`
  String get moral {
    return Intl.message(
      'Нравственность',
      name: 'moral',
      desc: '',
      args: [],
    );
  }

  /// `About myself`
  String get aboutMe {
    return Intl.message(
      'About myself',
      name: 'aboutMe',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Attention`
  String get attention {
    return Intl.message(
      'Attention',
      name: 'attention',
      desc: '',
      args: [],
    );
  }

  /// `Choose at least one hobby`
  String get chooseHobby {
    return Intl.message(
      'Choose at least one hobby',
      name: 'chooseHobby',
      desc: '',
      args: [],
    );
  }

  /// `Apply blur on photo`
  String get applyBlur {
    return Intl.message(
      'Apply blur on photo',
      name: 'applyBlur',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get proceed {
    return Intl.message(
      'Continue',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `Add your \nphotos`
  String get addPhoto {
    return Intl.message(
      'Add your \nphotos',
      name: 'addPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Add photos of your face to increase your chances of finding your other half.`
  String get addYourPhotos {
    return Intl.message(
      'Add photos of your face to increase your chances of finding your other half.',
      name: 'addYourPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Обновить`
  String get refresh {
    return Intl.message(
      'Обновить',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Нет интернет соеденения`
  String get noInternet {
    return Intl.message(
      'Нет интернет соеденения',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `REMONT.KZ - твой самый лучший помошник в ремонте`
  String get repairText {
    return Intl.message(
      'REMONT.KZ - твой самый лучший помошник в ремонте',
      name: 'repairText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
