import 'dart:io';

import 'package:cardapio/configs/routes/routes.dart';
import 'package:cardapio/controller/device_controller.dart';
import 'package:cardapio/model/devices_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY']!,
      authDomain: dotenv.env['AUTH_DOMAIN']!,
      projectId: dotenv.env['PROJECT_ID']!,
      storageBucket: dotenv.env['STORAGE_BUCKET']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      appId: dotenv.env['APP_ID']!,
    ),
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) {
      print(
          'Permissão concedida pelo usuário: ${settings.authorizationStatus}');
    }
    _startPushNotificationHandler(messaging);
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    if (kDebugMode) {
      print(
          'Permissão concedida previsoriamente pelo usuário: ${settings.authorizationStatus}');
    }
    _startPushNotificationHandler(messaging);
  } else {
    if (kDebugMode) {
      print('Permissão negada pelo usuário: ${settings.authorizationStatus}');
    }
  }

  runApp(
    const MyApp(),
  );
}

void _startPushNotificationHandler(FirebaseMessaging messaging) async {
  String? token = await messaging.getToken();
  if (kDebugMode) {
    print('TOKEN: $token');
  }
  setPushToken(token);

  //Firegroud
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Recebi uma mensagem enquanto estava com o App aberto');
    }
    if (kDebugMode) {
      print('Dados da mensagem: ${message.data}');
    }

    if (message.notification != null) {
      if (kDebugMode) {
        print(
            'A mensagem também continha uma notificação: ${message.notification!.title},${message.notification!.body}');
      }
    }
  });

  //Background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Terminated
  var notification = await FirebaseMessaging.instance.getInitialMessage();
  if (notification != null &&
      notification.data['message'] != null &&
      notification.data['message'].length > 0) {
    showMyDialog(notification.data[
        'message']); //exibe essa mensagem quado o usuário clica na notifacação
  }
}

void setPushToken(String? token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? prefsToken = prefs.getString('pushToken');
  bool? prefSent = prefs.getBool('tokenSent');
  if (kDebugMode) {
    print('Prefs Token: $prefsToken');
  }

  if (prefsToken != token || (prefsToken == token && prefSent == false)) {
    if (kDebugMode) {
      print('Salvando Token.');
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? brand;
    String? model;
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (kDebugMode) {
          print('Rodando no ${androidInfo.model}');
        }
        brand = androidInfo.brand;
        model = androidInfo.model;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        if (kDebugMode) {
          print('Rodando no ${iosInfo.utsname.machine}');
        }
        brand = iosInfo.utsname.machine;
        model = 'Apple';
      }

      Devices device = Devices(brand: brand, model: model, token: token);
      await postDevice(device);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao configurar o token de push: $e');
      }
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Mensagem recebida em background: ${message.notification}');
  }
}

//Tela de mensagem
void showMyDialog(String message) {
  Widget okButton = OutlinedButton(
    onPressed: () => Navigator.pop(navigatorKey.currentContext!),
    child: const Text('Ok!'),
  );
  AlertDialog alerta = AlertDialog(
    title: const Text('Mensagem'),
    content: Text(message),
    actions: [
      okButton,
    ],
  );
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return alerta;
      });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardápio',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: CustomColors.secondaryColor,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      routes: Routes.list,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
    );
  }
}
