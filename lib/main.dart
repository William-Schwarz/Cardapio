import 'dart:io';

import 'package:cardapio/controller/device_controller.dart';
import 'package:cardapio/model/devices_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/view/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBW0jWVb0d3V0IPPOB1ybd7Do83vj7ZLQo",
        authDomain: "cardapio-24614.firebaseapp.com",
        projectId: "cardapio-24614",
        storageBucket: "cardapio-24614.appspot.com",
        messagingSenderId: "144862329362",
        appId: "1:144862329362:web:3bd560f8694390961db6cb"),
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? token = await messaging.getToken();
  if (kDebugMode) {
    print('TOKEN: $token');
  }
  setPushToken(token);
  runApp(
    const MyApp(),
  );
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
      print('Salvando Toke.');
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
      home: const Navigation(),
    );
  }
}
