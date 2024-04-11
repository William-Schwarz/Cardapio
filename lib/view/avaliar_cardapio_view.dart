import 'package:flutter/material.dart';
import 'package:cardapio/configs/theme/snack_bar.dart';
import 'package:cardapio/controller/avaliacao_controller.dart';
import 'package:cardapio/configs/theme/colors.dart';

class AvaliarCardapio extends StatefulWidget {
  final String idCardapio;
  final String nomeCardapio;

  const AvaliarCardapio(
      {Key? key, required this.nomeCardapio, required this.idCardapio})
      : super(key: key);

  @override
  AvaliarCardapioState createState() => AvaliarCardapioState();
}

class AvaliarCardapioState extends State<AvaliarCardapio> {
  final AvaliacaoController avaliacaoController = AvaliacaoController();
  late int _rating = 1;
  late String _comment = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Avaliação do Cardápio',
          style: TextStyle(
            color: CustomColors.fontSecundaryColor,
            fontSize: 20,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.nomeCardapio,
            style: const TextStyle(
              color: CustomColors.fontSecundaryColor,
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.star,
                  color: _rating >= 1 ? Colors.orange : Colors.grey,
                ),
                onPressed: () => setState(() => _rating = 1),
              ),
              IconButton(
                icon: Icon(
                  Icons.star,
                  color: _rating >= 2 ? Colors.orange : Colors.grey,
                ),
                onPressed: () => setState(() => _rating = 2),
              ),
              IconButton(
                icon: Icon(
                  Icons.star,
                  color: _rating >= 3 ? Colors.orange : Colors.grey,
                ),
                onPressed: () => setState(() => _rating = 3),
              ),
              IconButton(
                icon: Icon(
                  Icons.star,
                  color: _rating >= 4 ? Colors.orange : Colors.grey,
                ),
                onPressed: () => setState(() => _rating = 4),
              ),
              IconButton(
                icon: Icon(
                  Icons.star,
                  color: _rating >= 5 ? Colors.orange : Colors.grey,
                ),
                onPressed: () => setState(() => _rating = 5),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Deixe um comentário (opcional)',
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: CustomColors.secondaryColor,
                ),
              ),
            ),
            style: const TextStyle(
              color: CustomColors.fontSecundaryColor,
              fontSize: 16,
            ),
            onChanged: (value) => _comment = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: CustomColors.primaryColor,
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(),
          ),
        ),
        TextButton(
          onPressed: () {
            avaliacaoController.postAvaliacoes(
              idCardapio: widget.idCardapio,
              nota: _rating,
              comentario: _comment,
            );
            ScaffoldMessenger.of(context).clearSnackBars();
            CustomSnackBar.showDefault(
              context,
              'Avaliação enviada com sucesso!',
            );
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: CustomColors.fontSecundaryColor,
          ),
          child: const Text(
            'Enviar',
            style: TextStyle(),
          ),
        ),
      ],
    );
  }
}
