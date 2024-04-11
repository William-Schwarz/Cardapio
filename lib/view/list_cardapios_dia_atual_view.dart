import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cardapio/configs/helpers/formatting.dart';
import 'package:cardapio/configs/theme/snack_bar.dart';
import 'package:cardapio/controller/cardapio_controller.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/model/cardapios_model.dart';
import 'package:cardapio/configs/widgets/full_screen_image.dart';
import 'package:cardapio/view/navigation.dart';
import 'package:cardapio/configs/widgets/image_thumb.dart';

class ListCardapiosDiaAtual extends StatefulWidget {
  const ListCardapiosDiaAtual({Key? key}) : super(key: key);

  @override
  ListCardapiosDiaAtualState createState() => ListCardapiosDiaAtualState();
}

class ListCardapiosDiaAtualState extends State<ListCardapiosDiaAtual> {
  final CardapioController cardapioController = CardapioController();
  bool isListOpen = false;
  int? openItemIndex;

  @override
  void initState() {
    super.initState();
    isListOpen = false;
  }

  void toggleListVisibility() {
    super.initState();
    isListOpen = !isListOpen;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cardapios>>(
      future: CardapioController.getCardapios(),
      builder: (BuildContext context, AsyncSnapshot<List<Cardapios>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Cardapios> cardapios = snapshot.data!;
          cardapios.sort((a, b) => b.data.compareTo(a.data));
          List<Cardapios> filteredCardapios = cardapios.where((cardapio) {
            return cardapio.data.year == DateTime.now().year &&
                cardapio.data.month == DateTime.now().month &&
                cardapio.data.day == DateTime.now().day;
          }).toList();
          if (filteredCardapios.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum cardápio lançado hoje.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredCardapios.length,
            itemBuilder: (BuildContext context, int index) {
              final cardapio = filteredCardapios[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          imagePath: cardapio.imagemURL,
                        ),
                      ),
                    );
                  },
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.25,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmar Exclusão!'),
                                  content: const Text(
                                    'Tem certeza de que deseja excluir este cardápio?',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cardapioController
                                            .deleteCardapio(cardapio.id);
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Navigation(
                                              selectedTabIndex: 2,
                                            ),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        CustomSnackBar.showDefault(context,
                                            'Cardápio excluído com sucesso!');
                                        setState(() {
                                          filteredCardapios.removeAt(index);
                                        });
                                      },
                                      child: const Text('Confirmar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: CustomColors.tertiaryColor,
                          foregroundColor: CustomColors.primaryColor,
                          icon: Icons.delete,
                          label: 'Excluir',
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.boxShadowColor,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: ImageThumb(imageURL: cardapio.thumbURL),
                            title: Text(
                              cardapio.nome,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.fontSecundaryColor,
                              ),
                            ),
                            trailing: Text(
                              '${Formatter.formatDate(cardapio.dataInicial)} até ${Formatter.formatDate(cardapio.dataFinal)}',
                              style: const TextStyle(
                                color: CustomColors.fontSecundaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
