import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/view/navigation.dart';

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
  runApp(
    const MyApp(),
  );
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
