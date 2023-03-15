import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:remont_kz/di.dart';
import 'package:remont_kz/generated/l10n.dart';
import 'package:remont_kz/utils/core_config.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/keyboard_util.dart';
import 'package:remont_kz/utils/lang/lang_provider.dart';
import 'package:remont_kz/utils/main_list.dart';
import 'package:remont_kz/utils/routes.dart';



///flutter pub run build_runner build --delete-conflicting-outputs
///команда для генерация file_name.g.dart или других
List<MainList> createTaskList = [];
void main() {

  return CoreConfig().initDI(() => init()).setApp(
      const RepairApp()).build();
}
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RepairApp extends StatelessWidget {
  const RepairApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
      designSize: const Size(360, 760),
      builder: (_, __) {
        return ChangeNotifierProvider(
          create: (context) => AppSettingsModel(),
          builder: (context, child) {
            // локализация пока уберем
            // context.read<AppSettingsModel>().setLang(getIt.get<TokenStoreService>().locale.languageCode);
            return GestureDetector(
              onTap: () => KeyboardUtil.hideKeyboard(context),
              child: MaterialApp(
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
