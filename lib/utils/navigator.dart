import 'package:flutter/material.dart';

Future<T?> navigatorPush<T extends Object>(BuildContext context, Widget screen, {bool root = false}) =>
    Navigator.of(context, rootNavigator: root).push<T>(MaterialPageRoute(builder: (context) => screen));

Future<T?> navigatorRemoveUntil<T extends Object, S>(BuildContext context, Widget screen, {bool root = false}) =>
    Navigator.of(context, rootNavigator: root)
        .pushAndRemoveUntil<T>(MaterialPageRoute(builder: (context) => screen), (Route<dynamic> route) => false);

Future navigatorPop<T>(BuildContext context, [T? result]) => Navigator.of(context).maybePop<T>(result);

Future<T?> navigatorPushNamed<T extends Object>(BuildContext context, String routeName, {bool root = false}) =>
    Navigator.of(context, rootNavigator: root).pushNamed(routeName);

