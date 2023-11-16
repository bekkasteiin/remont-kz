import 'dart:convert';
import 'dart:io';

import 'package:dependencies/dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/entities/error_message.dart';
import 'package:remont_kz/domain/entities/token_model.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/category/category_model.dart';
import 'package:remont_kz/model/chat/chat_list_model.dart';
import 'package:remont_kz/model/cities/cities_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:remont_kz/model/file_discriptor/file_discriptor_model.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/publication/publication_model.dart';
import 'package:remont_kz/model/publication/publication_review.dart';
import 'package:remont_kz/model/publication/upload_publication_model.dart';
import 'package:remont_kz/model/task/create_task_model.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/model/task/update_task_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:http/http.dart' as http;

class RestServices{

  showToasts(result) {
    return Fluttertoast.showToast(
        msg: result,
        textColor: AppColors.white,
        backgroundColor: AppColors.primary,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2);
  }

  showToastsError(result) {
    return Fluttertoast.showToast(
        msg: result,
        textColor: AppColors.blackGreyText,
        backgroundColor: AppColors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2);
  }


  late Response response;
  Dio dio = Dio(options);
  Dio dios = Dio();
  Dio dioProfile = Dio(optionProfile);
  Dio dioService = Dio(optionServices);
  Dio dioFiles = Dio(optionsFile);
  Dio dioAuth = Dio(optionAuth);
  static int tenSeconds = 10000;
  static int fiveSeconds = 5000;
  static int threeSeconds = 3000;
  String noResponse = 'No response';
  int code408 = 408;
  int code200 = 200;
  int code400 = 400;
  int code404 = 404;
  int code500 = 500;
  int code422 = 422;
  int code429 = 429;
  List translates = [];

  static BaseOptions options = BaseOptions(
    baseUrl: "https://remontor.kz/publication/v1/",
    connectTimeout: tenSeconds,
    receiveTimeout: fiveSeconds,
    headers: {'X-Requested-With': 'XMLHttpRequest', 'Accept-Language': 'ru'},
    responseType: ResponseType.json,
  );

  static BaseOptions optionsFile = BaseOptions(
    baseUrl: "https://remontor.kz/publication/v1/",
    connectTimeout: tenSeconds,
    receiveTimeout: fiveSeconds,
    headers: {'X-Requested-With': 'XMLHttpRequest',

    },
  );

  static BaseOptions optionAuth = BaseOptions(
    baseUrl: "https://remontor.kz/authentication",
    connectTimeout: tenSeconds,
    receiveTimeout: fiveSeconds,
    headers: {'X-Requested-With': 'XMLHttpRequest'
    },
  );

  static BaseOptions optionProfile = BaseOptions(
    baseUrl: "https://remontor.kz/user/",
    connectTimeout: tenSeconds,
    receiveTimeout: fiveSeconds,
    headers: {'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json'
    },
  );

  static BaseOptions optionServices = BaseOptions(
    baseUrl: "https://remontor.kz/service/",
    connectTimeout: tenSeconds,
    receiveTimeout: fiveSeconds,
    headers: {'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json'
    },
  );


  dioError(DioError e) {
    if (e.response != null) {
      dio.options.receiveTimeout = 5000;
      dio.options.connectTimeout = 3000;
      return {'data': e.response?.data, 'statusCode': e.response?.statusCode};
    } else {
      dio.options.receiveTimeout = 5000;
      dio.options.connectTimeout = 3000;
      showToasts('INTERNET NOT CONNECTED');
      return {'data': noResponse, 'statusCode': code400};
    }
  }

  auth({required String login, required String password})async{
    try{
      var body = json.encode({
        "login": login,
        "password": password
      });
      var request = await dioAuth.post("/api/auth", data: body);
      if(request.statusCode == 200){
        final value = TokenModel.fromJson(request.data);
        await getIt<TokenStoreService>().saveToken(value);
        return request.statusCode;
      }
      return request.statusCode;
    }on DioError catch (e){
      if(e.response?.data!=null){

        final value = ErrorMessage.fromJson(e.response?.data);
        print(e.response?.data);
        showToastsError(value.message ?? '');
      }
      return dioError(e);
    }
  }

  getMyProfile()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      dioProfile.options.headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      response = await dioProfile.get('/v1/users/get-my-profile',
      );
      if(response.statusCode ==200){
        var jsonData = json.encode(response.data);
        return GetProfile.fromJson(jsonDecode(jsonData));
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }


  changeModeClient()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      dioProfile.options.headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      response = await dioProfile.put('v1/users/change-user-mode',
      );
      if(response.statusCode ==200){
        return response.statusCode;
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  getProfileByUsername({required String userName})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      dioProfile.options.headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      response = await dioProfile.get('/v1/users/username/$userName',
      );
      if(response.statusCode ==200){
        var jsonData = json.encode(response.data);
        return GetProfile.fromJson(jsonDecode(jsonData));
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  getProfileSession({required String userName})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      dioAuth.options.headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      response = await dioAuth.get('/users/last-session/$userName',
      );

      if(response.statusCode ==200){
        var jsonData = json.encode(response.data);
        final jsonMap = json.decode(jsonData);


        final dateTimeString = jsonMap['dateTime'];
        DateTime parsedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(dateTimeString);
        var dateOnline = DateFormat('HH:mm').format(parsedDateTime);

        return dateOnline;
      }

    }on DioError catch (e) {
      print(response.statusCode);
      return dioError(e);
    }
  }

  getIsOpenRequest({required int taskID})async{
    try{
      final response = await dio.get('tasks/is-active?taskId=$taskID',
      );
      if(response.statusCode ==200){
        return response.data;

      }else{
        false;
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  postOpenClosedRequest({required int taskID})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      dio.options.headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      response = await dio.patch('tasks/open-for-request/$taskID',
      );
      if(response.statusCode ==200){
        return response.statusCode;
      }else{
        return response.statusCode;
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  postClosedRequest({required int taskID})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      dio.options.headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      response = await dio.patch('tasks/close-for-request/$taskID',
      );
      if(response.statusCode ==200){
        return response.statusCode;
      }else{
        return response.statusCode;
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  isHaveResponse({required String clientUsername, required String executorUsername,
  required String type, required int typeId
  })async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Authorization': 'Bearer ${tokenStore.accessToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/is-have-response'));
      request.body = json.encode({
        "clientUsername": clientUsername,
        "executorUsername": executorUsername,
        "type": type,
        "typeId": typeId
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var myList = jsonDecode(await response.stream.bytesToString());
        return myList;
      }
      else {
        print('error isHaveResponse');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  isHaveWithSame({required int categoryId})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Authorization': 'Bearer ${tokenStore.accessToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications/is-have-with-same-category?categoryId=$categoryId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true;
      }
      else {
        return false;
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  approveSpecialist(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/approve-task?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.success(
          description: const Text(
            'Вы успешно выбрали спицалиста',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);


      }else if(response.statusCode == 500){
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.error(
          description: const Text(
            'Для того что бы выбрать этого специалиста, отмените предыдущую сделку',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }


  selectSpecialist(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/approve-specialist?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.success(
          description: const Text(
            'Вы выбрали специалиста! Теперь ждем его подтверждения о начале работы',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        //
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  cancelSpecialist(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/reject-task?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.error(
          description: const Text(
            'Вы отклонили спицалиста',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }


  cancelSpecialistAfterTask(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/cancel-task?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.error(
          description: const Text(
            'Вы отклонили работу',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }


  approveSpecialistAfterTask(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/complete-task?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.success(
          description: const Text(
            'Работа завершена',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }



  approveSpecialistTask(chatRoomId)async{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/complete-task?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.success(
          description: const Text(
            'Работа успешно завершена, не забудьте оставить отзыв о специалисте',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        //
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }
  }


  completeWork(chatRoomId)async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
    var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/complete-work?chatRoomId=$chatRoomId'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(rootNavigatorKey.currentContext!);
      MotionToast.success(
        description: const Text(
          'Вы успешно завершили работу',
          style: TextStyle(fontSize: 12),
        ),
        position: MotionToastPosition.top,
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromTop,
        dismissable: true,
      ).show(rootNavigatorKey.currentContext!);
      //
      // Navigator.pop(rootNavigatorKey.currentContext!);

    }
    else {
      print(response.reasonPhrase);
    }
  }

  rejectWork(chatRoomId)async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
    var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/reject-work?chatRoomId=$chatRoomId'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(rootNavigatorKey.currentContext!);
      MotionToast.success(
        description: const Text(
          'Вы отклонили задание',
          style: TextStyle(fontSize: 12),
        ),
        position: MotionToastPosition.top,
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromTop,
        dismissable: true,
      ).show(rootNavigatorKey.currentContext!);
      //
      // Navigator.pop(rootNavigatorKey.currentContext!);

    }
    else {
      print(response.reasonPhrase);
    }
  }



  confirmWork(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/confirm-work?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.success(
          description: const Text(
            'Вы выполняете работу. Выполните свою работу хорошо, что бы получить отзыв.',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }


  completeWorkWorker(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/complete-work?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.success(
          description: const Text(
            'Поздравляем! Вы завершили работу! Можете попросить заказчика оставить вам отзыв!',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  rejectWorkWorker(chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('POST', Uri.parse('https://remontor.kz/service/status/reject-work?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(rootNavigatorKey.currentContext!);
        MotionToast.error(
          description: const Text(
            'Вы отклонили работу',
            style: TextStyle(fontSize: 12),
          ),
          position: MotionToastPosition.top,
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromTop,
          dismissable: true,
        ).show(rootNavigatorKey.currentContext!);
        // Navigator.pop(rootNavigatorKey.currentContext!);

      }
      else {
        print(response.reasonPhrase);
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }


  getMyAllMessage()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Authorization': 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/get-my-chats'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getCompletedAllMessage()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Authorization': 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/get-completed-chats'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getCompletedAllPublicationClient()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Authorization': 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-completed-requests'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  registration({required String email, required String firstName,
    required String lastName, required String password, required String username,
    required bool isClients
  })async{
    try{
      var body = json.encode({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "password": password,
        "username": username,
        "isClient": isClients
      });
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://remontor.kz/authentication/api/registration'));
      request.body = body;
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return response.statusCode;
      }
      else {
        showToastsError('Пользователь с таким уже зарегистрирован');
      }

    }on DioError catch (e){
      print(e);
      return dioError(e);
    }
  }

  checkSmsCode({required int code, required String userName})async{
    try{
      var body = json.encode({
        "code": code,
        "username": userName
      });
      var request = await dioAuth.post("/users/verify-sms", data: body);

      if(request.statusCode == 200){


      }
      return request.statusCode;


    }on DioError catch (e){
      print(e.response?.data);
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        showToasts(value.message ?? '');
      }

      return dioError(e);
    }
  }

  getPublication()async{
    try{
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications'));
      request.body = json.encode({
        "page": 0,
        "pageSize": 10,
        "sorting": "NEW",
        "status": "ACTIVATED"
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
       print('error getPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getPublicationAccessToken()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications'));
      request.body = json.encode({
        "page": 0,
        "pageSize": 10,
        "sorting": "NEW",
        "status": "ACTIVATED"
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
        print('error getPublicationAccessToken');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getMyTasks({required String userName})async{
    try{

      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/tasks/user/$userName'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => TaskModel.fromJson(e)).toList();
      }
      else {
        print('error getMyTasks');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getMyPublication({required String userName})async{
    try{
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications/user/$userName'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  isHaveNewMessage()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/is-have-new-messages'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var myList = jsonDecode(await response.stream.bytesToString());
        return  myList;
      }
      else {
        print('error isHaveNewMessage');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getMyPublicationWithToken({required String userName})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications/user/$userName'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getMyActivateTask()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/tasks/get-my-active-tasks'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => TaskModel.fromJson(e)).toList();
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getMyDeActivateTask()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/tasks/get-my-not-active-tasks'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => TaskModel.fromJson(e)).toList();
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getMyActivatePublication()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications/get-my-active-pub'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getCompetedPublicationForClient()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-completed-requests'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getMyActivateRequestPub()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-active-requests'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getCompleteTaskForWorker()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-completed-responses'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getCompleteTaskForClient(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-completed-task/$id'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getActivateRequestTask()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-active-responses'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getActivateRequestTaskId(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-active-task/$id'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getMyChatByPubId(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-active-publication/$id'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getMyCompeteByPubId(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-completed-publication/$id'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        var list = myList.map((e) => ChatList.fromJson(e)).toList();
        return  list;
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getMyDeActivatePublication()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();


      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications/get-my-not-active-pub'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
        print('error getMyPublication');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }



  getPublicationById(int id)async{
    try{
      var response = await dio.get('publications/$id');

      if(response.statusCode ==200){
        var jsonData = json.encode(response.data);
        return PublicationModel.fromJson(jsonDecode(jsonData));
      }
    }on DioError catch (e) {
      return dioError(e);
    }
  }

  getPublicationByIdAccessToken(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      response = await dio.get('publications/$id', options: Options(
        headers: headers
      ));
      if(response.statusCode ==200){
        var jsonData = json.encode(response.data);
        return PublicationModel.fromJson(jsonDecode(jsonData));
      }
    }on DioError catch (e) {
      return dioError(e);
    }
  }

  getAllReviewByPublication({required String userName, required int categoryId, required int rating})async{
    try{
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/comments/executor/$userName'));
      request.body = json.encode({
        "categoryId": categoryId==0 ? null : categoryId,
        "rating": rating==0 ? null : rating
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var myList = jsonDecode(await response.stream.bytesToString());
        PublicationReview publicationReview = PublicationReview.fromJson(myList);
        return publicationReview;
      }
      else {
        print(await response.stream.bytesToString());
        print('error getAllReviewByPublication');
      }
    }on DioError catch (e) {
      return dioError(e);
    }
  }

  getCompletedWorkProfile(String userName)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json',
        "Authorization" : 'Bearer ${tokenStore.accessToken}'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/comments/get-completed-works/$userName'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var myList = jsonDecode(await response.stream.bytesToString());
       return myList;
      }
      else {
        print('error getCompletedWork');
      }
    }on DioError catch (e) {
      return dioError(e);
    }
  }

  getReviewExists(String chatRoomId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {"Authorization" : 'Bearer ${tokenStore.accessToken}'};
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/comments/exists?chatRoomId=$chatRoomId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        bool list = jsonDecode(await response.stream.bytesToString());
        return  list;
      }
      else {
        print('error getReviewExists');
      }

    }on DioError catch (e) {
      return dioError(e);
    }

  }

  getAllTask()async{
    try{
      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/tasks'));
      request.body = json.encode({
        "page": 0,
        "pageSize": 10,
        "sorting": "NEW",
        "status": "ACTIVATED"
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => TaskModel.fromJson(e)).toList();
      }
      else {
        print('error getAllTask');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getMyCompeteTask()async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}",
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/tasks/get-my-completed-tasks'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => TaskModel.fromJson(e)).toList();
      }
      else {
        print('error getAllTask');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getCountMessageByID({required String type, required List<int> id})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}",
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/service/chat/get-count-of-new-messages'));
      request.body = json.encode({
        "type": type,
        "ids": id,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var myList = jsonDecode(await response.stream.bytesToString());
       return myList;
      }
      else {
        print('error getAllTask');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getAllPublicationByCategory(int categoryId)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}",
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var headers2 = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications'));
      request.body = json.encode({
        "categoryId": categoryId,
        "page": 0,
        "pageSize": 10,
        "sorting": "NEW",
        "status": "ACTIVATED"
      });
      request.headers.addAll(tokenStore.accessToken!=null ? headers : headers2);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
        print('error getAllPublicationByCategory');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getAllPublicationByCategoryFilter(
      {required int categoryId,
      required int cityId,
      required int fromPrice,
      required int toPrice,
      required bool isContractual,
      required String sorting})async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}",
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var headers2 = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/publications'));
      request.body = fromPrice==0 || isContractual==false ?
      json.encode({
        "categoryId": categoryId,
        "page": 0,
        "pageSize": 10,
        "sorting": sorting,
        "status": "ACTIVATED",
        "cityId": cityId
      }) : json.encode({
        "categoryId": categoryId,
        "page": 0,
        "pageSize": 10,
        "sorting": sorting,
        "status": "ACTIVATED",
        "cityId": cityId,
        "fromPrice": fromPrice,
        "toPrice": toPrice,
        "isContractual": isContractual
      });
      request.headers.addAll(tokenStore.accessToken!=null ? headers : headers2);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => PublicationModel.fromJson(e)).toList();
      }
      else {
        print('error getAllPublicationByCategoryFilter');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }


  getAllTaskByCategory(int categoryId)async{
    try{

      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/tasks'));
      request.body = json.encode({
        "categoryId": categoryId,
        "page": 0,
        "pageSize": 10,
        "sorting": "NEW",
        "status": "ACTIVATED"
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => TaskModel.fromJson(e)).toList();
      }
      else {
        print('error getAllTaskByCategory');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getAllTaskByCategoryFilter(
      {required int categoryId,
      required int cityId,
      required int fromPrice,
      required int toPrice,
      required bool isContractual,
      required String sorting})async{
    try{

      var headers = {
        'Accept-Language': 'ru',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('https://remontor.kz/publication/v1/tasks'));
      request.body =  request.body = fromPrice==0 || isContractual==false ?
      json.encode({
        "categoryId": categoryId,
        "page": 0,
        "pageSize": 10,
        "sorting": sorting,
        "status": "ACTIVATED",
        "cityId": cityId
      }) : json.encode({
        "categoryId": categoryId,
        "page": 0,
        "pageSize": 10,
        "sorting": sorting,
        "status": "ACTIVATED",
        "cityId": cityId,
        "fromPrice": fromPrice,
        "toPrice": toPrice,
        "isContractual": isContractual
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        List myList = jsonDecode(await response.stream.bytesToString());
        return  myList.map((e) => TaskModel.fromJson(e)).toList();
      }
      else {
        print('error getAllTaskByCategoryFilter');
      }
    }on DioError catch (e){
      return dioError(e);
    }
  }

  getTaskById(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };

      response = await dio.get('tasks/$id', options: Options(headers: headers));
      if(response.statusCode ==200){

        var jsonData = json.encode(response.data);

        return TaskModel.fromJson(jsonDecode(jsonData));
      }

    }on DioError catch (e) {
      return dioError(e);
    }

  }

  postRequest({required String path, required dynamic data}) async {
    try {
      response = await dio.post(
        path,
        data: data,);
      return {'data': response.data, 'statusCode': response.statusCode};
    } on DioError catch (e) {
      return dioError(e);
    }
  }

   getCategory()async{
    try{
      var response = await dio.get('categories');
      if(response.statusCode ==200){
        var categoryList =(response.data as List)
            .map((x) => CategoryModel.fromMap(x))
            .toList();
       return categoryList;
      }

    }on DioError catch(e){
      return e.response?.data;
    }
  }

  getAllCities()async{
    try{
      var response = await dio.get('cities');
      if(response.statusCode ==200){
        var citiesList =(response.data as List)
            .map((x) => CitiesModel.fromMap(x))
            .toList();
        return citiesList;
      }

    }on DioError catch(e){
      return e.response?.data;
    }
  }


  createNewPublication(UploadPublication entity)async{
    try{
      var jsonBody = entity.toMapCreate();
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var body = json.encode(jsonBody);
      var response = await dio.post('publications', data: body, options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
      }

      return dioError(e);
    }
  }

  deactivatePublication(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var response = await dio.post('publications/deactivate-pub/$id', options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        print(value);
      }

      return dioError(e);
    }
  }

  activatePublication(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var response = await dio.post('publications/activate-pub/$id', options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        return value;
      }

      return dioError(e);
    }
  }

  deletePublication(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var response = await dio.post('publications/delete-pub/$id', options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      print(e.response?.realUri.toString());
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        print(value);
      }

      return dioError(e);
    }
  }



  deactivateTask(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var response = await dio.post('tasks/deactivate-task/$id', options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        print(value);
      }

      return dioError(e);
    }
  }

  activateTask(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var response = await dio.post('tasks/activate-task/$id', options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        print(value);
      }

      return dioError(e);
    }
  }

  deleteTask(int id)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var response = await dio.post('tasks/delete-task?taskId=$id', options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      print(e.response!.statusCode);
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        print(value.toJson());
      }

      return dioError(e);
    }
  }

  editPublication(EditPublication entity)async{
    try{
      var jsonBody = entity.toMapCreate();
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var body = json.encode(jsonBody);

      var response = await dio.patch('publications', data: body, options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        print(value.message);
      }
      return dioError(e);
    }
  }

  editTask(EditTask entity)async{
    try{
      var jsonBody = entity.toMapCreate();
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var body = json.encode(jsonBody);

      var response = await dio.patch('tasks', data: body, options: Options(
          headers: headers
      ));

      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        print(e.response?.data);
        final value = ErrorMessage.fromJson(e.response?.data);
      }
      return dioError(e);
    }
  }


  addFavourite(String id)async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    var response = await dio.post('publications/add-to-my-favourite?pubId=$id', options: Options(
        headers: headers
    ));
    return response.data;
  }

  deleteFavouritePublication(String id)async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    var response = await dio.post('publications/delete-from-my-favourite?pubId=$id', options: Options(
        headers: headers
    ));
    return response.data;
  }

  addFavouriteTask(String id)async{

    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    var response = await dio.post('tasks/add-to-my-favourite?taskId=$id', options: Options(
        headers: headers
    ));

    return response.data;
  }

  deleteFavouriteTask(String id)async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    var response = await dio.post('tasks/delete-from-my-favourite?taskId=$id', options: Options(
        headers: headers
    ));
    return response.data;
  }

  getFavoritePublication()async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    var response = await dio.get('publications/get-my-favourite', options: Options(
        headers: headers
    ));
    if(response.statusCode ==200){
      var categoryList =(response.data as List)
          .map((x) => PublicationModel.fromJson(x))
          .toList();
      return categoryList;
    }
  }

  getFavoriteTask()async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    var response = await dio.get('tasks/get-my-favourite', options: Options(
        headers: headers
    ));
    if(response.statusCode ==200){
      var categoryList =(response.data as List)
          .map((x) => TaskModel.fromJson(x))
          .toList();
      return categoryList;
    }
  }

  createNewTask(TaskPublication entity)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();
      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var jsonBody = entity.toMapCreate();
      var body = json.encode(jsonBody);
      var response = await dio.post('tasks', data: body, options: Options(
          headers: headers
      ));
      return response.statusCode;
    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        if(value.message == 'PUBLICATION_LIMIT_MAX'){
          MotionToast.error(
            description: const Text(
              'Вы превысили лимит создание задание',
              style: TextStyle(fontSize: 12),
            ),
            position: MotionToastPosition.top,
            layoutOrientation: ToastOrientation.ltr,
            animationType: AnimationType.fromTop,
            dismissable: true,
          ).show(rootNavigatorKey.currentContext!);
        }
      }
      return dioError(e);
    }

  }

  createNewComment(TaskComment entity)async{
    try{
      final tokenStore = getIt.get<TokenStoreService>();

      var headers = {
        HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
      };
      var jsonBody = entity.toMapCreate();
      var body = json.encode(jsonBody);
      var response = await dio.post('comments', data: body, options: Options(
          headers: headers
      ));
      if(response.statusCode == 200){
        return response.statusCode;
      }else{
        return null;
      }
    }on DioError catch (e) {
      print(e.response!.data);
      return dioError(e);
    }


  }


  editProfile(GetProfile profile)async{
    final tokenStore = getIt.get<TokenStoreService>();
    var headers = {
      'Authorization': "Bearer ${tokenStore.accessToken}",
      'Content-Type': "application/json"
    };
    var body = json.encode(profile);
    var request = http.Request('PUT', Uri.parse('https://remontor.kz/user/v1/users/edit-my-profile'));
    request.headers.addAll(headers);
    request.body = body;
    http.StreamedResponse response = await request.send();

    return response.statusCode;
  }

   uploadImage(File file) async {
     final tokenStore = getIt.get<TokenStoreService>();
    var url = 'https://remontor.kz/publication/v1/files';
     final http.MultipartRequest request =
     http.MultipartRequest('POST', Uri.parse(url))
       ..fields['path'] = "publication";

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
     request.files.add(await http.MultipartFile.fromPath('file', file.path,
     contentType: MediaType.parse('image/png')));
     request.headers.addAll(headers);
     final  response = await request.send();
    var responseBody = await http.Response.fromStream(response);
     if(responseBody.statusCode ==200){
       Map<String, dynamic> jsonMap = json.decode(responseBody.body);
       var filesBody = FileDescriptor.fromJson(jsonMap);
       return filesBody;
     }else{
       return null;
     }
  }

  uploadImageComment(File file) async {
    final tokenStore = getIt.get<TokenStoreService>();
    var url = 'https://remontor.kz/publication/v1/files';
    final http.MultipartRequest request =
    http.MultipartRequest('POST', Uri.parse(url))
      ..fields['path'] = "comment";

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType.parse('image/png')));
    request.headers.addAll(headers);
    final  response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    if(responseBody.statusCode ==200){
      Map<String, dynamic> jsonMap = json.decode(responseBody.body);
      var filesBody = FileDescriptor.fromJson(jsonMap);
      return filesBody;
    }else{
      return null;
    }
  }

  uploadImageProfile(File file) async {
    final tokenStore = getIt.get<TokenStoreService>();
    var url = 'https://remontor.kz/publication/v1/files';
    final http.MultipartRequest request =
    http.MultipartRequest('POST', Uri.parse(url))
      ..fields['path'] = "user";

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer ${tokenStore.accessToken}"
    };
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType.parse('image/png')));
    request.headers.addAll(headers);
    final  response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    if(responseBody.statusCode ==200){
      Map<String, dynamic> jsonMap = json.decode(responseBody.body);
      var filesBody = FileDescriptor.fromJson(jsonMap);
      return filesBody;
    }else{
      return null;
    }
  }


  uploadImageTask(File file) async {
    final tokenStore = getIt.get<TokenStoreService>();
    var url = 'https://remontor.kz/publication/v1/files';
    var headers = {
      'Authorization': "Bearer ${tokenStore.accessToken}"
    };
    final http.MultipartRequest request =
    http.MultipartRequest('POST', Uri.parse(url))
      ..fields['path'] = "task";
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType.parse('image/png')));
    request.headers.addAll(headers);
    final  response = await request.send();
    var responseBody = await http.Response.fromStream(response);
    if(responseBody.statusCode ==200){
      Map<String, dynamic> jsonMap = json.decode(responseBody.body);
      var filesBody = FileDescriptor.fromJson(jsonMap);
      return filesBody;
    }else{
      return null;
    }
  }

  sendSmsForResetPassword({required String userName})async{
    try{
      response = await dioAuth.post('/users/send-sms-for-reset-pass?username=$userName',
      );
      if(response.statusCode ==200){
        return response.statusCode;
      }

    }on DioError catch (e) {
      return dioError(e);
    }
  }

  sendNewResetPassword({required String userName, required int code,
    required String firstNewPassword, required String secondNewPassword,})async{
    try{
      var body = json.encode({
        "firstNewPassword": firstNewPassword,
        "secondNewPassword": secondNewPassword,
        "code": code,
        "username": userName
      });

      response = await dioAuth.post('/users/reset-pass',
          data: body

      );
      if(response.statusCode ==200){
        return response.statusCode;
      }

    }on DioError catch (e) {
      if(e.response?.data!=null){
        final value = ErrorMessage.fromJson(e.response?.data);
        showToastsError(value.message ?? '');
      }

      return dioError(e);
    }
  }
}