import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cardapio/configs/helpers/formatting.dart';
import 'package:cardapio/controller/cardapio_controller.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/model/cardapios_model.dart';
import 'package:cardapio/configs/widgets/full_screen_image.dart';
import 'package:cardapio/view/avaliar_cardapio_view.dart';
import 'package:cardapio/configs/widgets/image_thumb.dart';

class ListCardapios extends StatefulWidget {
  const ListCardapios({Key? key}) : super(key: key);

  @override
  ListCardapiosState createState() => ListCardapiosState();
}

class ListCardapiosState extends State<ListCardapios> {
  bool isListOpen = false;
  int? openItemIndex;

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
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cardapios.length,
            itemBuilder: (BuildContext context, int index) {
              final cardapio = cardapios[index];
              final bool isImagemRecente = imagemRecente(cardapio);
              if (!isImagemRecente) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
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
                                  return AvaliarCardapio(
                                    idCardapio: cardapio.id,
                                    nomeCardapio: cardapio.nome,
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: CustomColors.tertiaryColor,
                            foregroundColor: CustomColors.fontSecundaryColor,
                            icon: Icons.addchart,
                            label: 'Avaliar',
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
              } else {
                return const SizedBox();
              }
            },
          );
        }
      },
    );
  }

  bool imagemRecente(Cardapios cardapio) {
    DateTime now = DateTime.now();
    DateTime dataAtualSemHora = DateTime(now.year, now.month, now.day);

    if (cardapio.dataInicial.isAfter(dataAtualSemHora)) {
      return true;
    } else {
      return (dataAtualSemHora.isAfter(cardapio.dataInicial) ||
              dataAtualSemHora.isAtSameMomentAs(cardapio.dataInicial)) &&
          (dataAtualSemHora.isBefore(cardapio.dataFinal) ||
              dataAtualSemHora.isAtSameMomentAs(cardapio.dataFinal));
    }
  }
}
