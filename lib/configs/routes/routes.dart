import 'package:cardapio/view/navigation.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/cardapios': (_) => const Navigation(index: 0),
    '/avaliacoes': (_) => const Navigation(index: 1),
  };

  static String initial = '/cardapios';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
