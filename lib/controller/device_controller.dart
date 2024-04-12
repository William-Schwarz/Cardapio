import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cardapio/model/devices_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> postDevice(Devices device) async {
  try {
    await Firebase.initializeApp();

    CollectionReference devices =
        FirebaseFirestore.instance.collection('Devices');

    DocumentReference deviceRef = await devices.add({
      'Brand': device.brand,
      'Model': device.model,
      'Token': device.token,
    });

    if (kDebugMode) {
      print('Device salvo no Firestore');
    }

    // ignore: unnecessary_null_comparison, unrelated_type_equality_checks
    if (deviceRef != null || deviceRef == '') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('pushToken', device.token!);
      prefs.setBool('tokenSent', true);
    } else {
      throw Exception('Falha ao criar o dispositivo.');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao salvar Device: $e');
    }
  }
}
