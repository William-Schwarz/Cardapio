import 'package:flutter/material.dart';
import 'package:cardapio/view/avaliacao_view.dart';
import 'package:cardapio/view/cardapio_view.dart';
import 'package:cardapio/view/atualizar_view.dart';

class NewPage extends StatelessWidget {
  final int indice;

  const NewPage(this.indice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (indice == 0) {
      page = const Cardapio();
    } else if (indice == 1) {
      page = const Avaliacao();
    } else if (indice == 2) {
      page = const Atualizar();
    } else {
      page = Scaffold(
        appBar: AppBar(
          title: const Text('Erro!'),
        ),
        body: const Center(
          child: Text('Erro!'),
        ),
      );
    }

    return page;
  }
}
