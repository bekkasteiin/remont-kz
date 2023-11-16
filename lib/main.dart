import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dependencies/dependencies.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';
import 'package:remont_kz/generated/l10n.dart';
import 'package:remont_kz/model/chat/chat_room.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/model/task/task_model.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/core_config.dart';
import 'package:remont_kz/utils/keyboard_util.dart';
import 'package:remont_kz/utils/lang/lang_provider.dart';
import 'package:remont_kz/utils/main_list.dart';
import 'package:remont_kz/utils/routes.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

///flutter pub run build_runner build --delete-conflicting-outputs
///команда для генерация file_name.g.dart или других
///
List<MainList> createTaskList = [];
TaskModel? modelTaskChat;
List<ChatRoom> messagesList = [];
bool? newMessage;
final tokenStore = getIt.get<TokenStoreService>();
String formatMonthNamedDate(DateTime dateTime) {
  if (dateTime == null) {
    return ' ';
  }
  return DateFormat('dd MMM yyyy г').format(dateTime);
}

 String dateFormatForChat(final dateTimeString){
DateTime parsedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse('$dateTimeString');
var dateOnline = DateFormat('HH:mm').format(parsedDateTime);
return dateOnline.toString();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClients(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void onConnect(StompFrame frame) async {
  print(frame.headers);
  print(frame.body);
  GetProfile profile = GetProfile();
  profile = await RestServices().getMyProfile();
  stompClient.subscribe(
      destination: '/user/${profile.username}/queue/messages',
      callback: (frame) async {
        print(frame.body);
        print(frame.command);
        Map<String, dynamic> jsonData = json.decode(frame.body.toString());
        String id = jsonData['id'].toString();
        var headers = {
          'Accept-Language': 'ru',
          'Authorization': 'Bearer ${tokenStore.accessToken}'
        };
        var request = http.Request(
            'GET', Uri.parse('https://remontor.kz/service/message/$id'));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          final responseChat = await response.stream.bytesToString();
          var add = ChatRoom.fromJson(jsonDecode(responseChat));
          messagesList.add(add);
        }
      });
}

final stompClient = StompClient(
  config: StompConfig.SockJS(
    url: 'http://195.49.213.138:8085/service/ws',
    onConnect: onConnect,
    beforeConnect: () async {
      print('waiting to connect...');
      await Future.delayed(Duration(milliseconds: 200));
      print('connecting...');
    },
    onWebSocketError: (dynamic error) {
      print(error.toString());
    },
    stompConnectHeaders: {
      'Authorization': 'Bearer ${tokenStore.accessToken}',
      'Upgrade': 'websocket',
      'Connection': 'Upgrade'
    },
    webSocketConnectHeaders: {
      'Authorization': 'Bearer ${tokenStore.accessToken}',
      'Upgrade': 'websocket',
      'Connection': 'Upgrade'
    },
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  return CoreConfig().initDI(() => init()).setApp(const RepairApp()).build();
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RepairApp extends StatelessWidget {
  const RepairApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      builder: (_, __) {
        return ChangeNotifierProvider(
          create: (context) => AppSettingsModel(),
          builder: (context, child) {
            return GestureDetector(
              onTap: () => KeyboardUtil.hideKeyboard(context),
              child: MaterialApp(
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: child!,
                  );
                },
                navigatorKey: rootNavigatorKey,
                scaffoldMessengerKey: rootScaffoldMessengerKey,
                debugShowCheckedModeBanner: false,
                title: 'REMONT.KZ',
                theme: appTheme,
                onGenerateTitle: (context) {
                  var t = S.of(context);
                  return t.auth;
                },
                initialRoute: AppRoutes.root,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: context.read<AppSettingsModel>().locale,
                supportedLocales: S.delegate.supportedLocales,
                routes: appRoutes,
              ),
            );
          },
        );
      },
    );
  }
}
