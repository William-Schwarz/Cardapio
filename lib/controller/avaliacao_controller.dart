import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cardapio/model/avaliacoes_model.dart';

class AvaliacaoController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<Avaliacoes>> getAvaliacao([HttpRequest? request]) async {
    List<Avaliacoes> avaliacoes = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Cardapios').get();

      for (QueryDocumentSnapshot cardapioDoc in querySnapshot.docs) {
        QuerySnapshot avaliacaoQuerySnapshot =
            await cardapioDoc.reference.collection('Avaliacao').get();

        for (QueryDocumentSnapshot avaliacaoDoc
            in avaliacaoQuerySnapshot.docs) {
          Map<String, dynamic>? data =
              avaliacaoDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            avaliacoes.add(
              Avaliacoes(
                id: avaliacaoDoc.id,
                nota: data['Nota'] as int,
                comentario: data['Comentario'],
                data: (data['Data'] as Timestamp).toDate(),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar avaliações: $e');
      }
    }
    return avaliacoes;
  }

  Future<void> postAvaliacoes({
    required String idCardapio,
    required int nota,
    required String comentario,
  }) async {
    try {
      DocumentReference cardapioRef =
          firestore.collection('Cardapios').doc(idCardapio);

      await cardapioRef.collection('Avaliacao').add({
        'Nota': nota,
        'Comentario': comentario,
        'Data': DateTime.now(),
      });

      if (kDebugMode) {
        print('Dados Salvos no Firestore');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Erro no upload: ${e.code}');
      }
    }
  }
}
