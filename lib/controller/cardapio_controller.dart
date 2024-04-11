import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cardapio/model/cardapios_model.dart';

class CardapioController extends ChangeNotifier {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Uint8List? _imageData;

  Uint8List? get imageData => _imageData;

  set imageData(Uint8List? value) {
    _imageData = value;
    notifyListeners();
  }

  Future<Uint8List?> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _imageData = await pickedImage.readAsBytes();
      notifyListeners();
    }
    return _imageData;
  }

  Future<Uint8List> resizeImage(
      Uint8List imageData, int width, int height) async {
    Image image = decodeImage(imageData)!;
    Image resizedImage = copyResize(image, width: width, height: height);
    return Uint8List.fromList(encodePng(resizedImage));
  }

  Future<void> postCardapios({
    required String nome,
    required DateTime dataInicial,
    required DateTime dataFinal,
    required Uint8List imagemURL,
  }) async {
    if (_imageData != null) {
      try {
        // Redimensiona a imagem
        Uint8List resizedImage = await resizeImage(_imageData!, 200, 250);

        // Salva a imagem no Firebase Storage
        String refOriginal = 'cardapios/img-${DateTime.now().toString()}.png';
        await storage.ref(refOriginal).putData(_imageData!);
        String imagemURL = await storage.ref(refOriginal).getDownloadURL();

        // Salva a imagem redimensionada no Firebase Storage
        String refThumb = 'cardapios/thumb-${DateTime.now().toString()}.png';
        await storage.ref(refThumb).putData(resizedImage);
        String thumbURL = await storage.ref(refThumb).getDownloadURL();

        // Salva os dados no Firestore, incluindo a URL da imagem original e a base64 da imagem redimensionada
        await firestore.collection('Cardapios').add({
          'Nome': nome,
          'DataInicial': dataInicial,
          'DataFinal': dataFinal,
          'ImagemURL': imagemURL,
          'ThumbURL': thumbURL,
          'Data': DateTime.now(),
        });

        if (kDebugMode) {
          print('Imagens Salvas no Storage e Firestore');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erro no upload: $e');
        }
      }
    }
  }

  static Future<List<Cardapios>> getCardapios([HttpRequest? request]) async {
    List<Cardapios> cardapios = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Cardapios').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          cardapios.add(
            Cardapios(
              id: doc.id,
              nome: data['Nome'],
              dataInicial: (data['DataInicial'] as Timestamp).toDate(),
              dataFinal: (data['DataFinal'] as Timestamp).toDate(),
              imagemURL: data['ImagemURL'],
              thumbURL: data['ThumbURL'],
              data: (data['Data'] as Timestamp).toDate(),
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar cardápios: $e');
      }
    }

    return cardapios;
  }

  Future<void> deleteCardapio(String cardapioId) async {
    try {
      await firestore.collection('Cardapios').doc(cardapioId).delete();
      if (kDebugMode) {
        print('Cardápio excluído com sucesso.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao excluir o cardápio: $e');
      }
    }
  }
}
