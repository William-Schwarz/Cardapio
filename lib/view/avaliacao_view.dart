import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cardapio/controller/cardapio_avaliacao_controller.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/model/cardapio_avaliacao_model.dart';
import 'package:cardapio/configs/widgets/full_screen_image.dart';
import 'package:cardapio/configs/widgets/image_thumb.dart';

class Avaliacao extends StatefulWidget {
  const Avaliacao({Key? key}) : super(key: key);

  @override
  State<Avaliacao> createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<Avaliacao> {
  late Future<List<AvaliacaoCardapio>> _avaliacao;

  @override
  void initState() {
    super.initState();
    _avaliacao = CardapioAvaliacaoController.getCardapioAvaliacao();
  }

  Map<String, List<AvaliacaoCardapio>> agruparAvaliacoesPorCardapio(
      List<AvaliacaoCardapio> avaliacoes) {
    return CardapioAvaliacaoController()
        .agruparAvaliacoesPorCardapio(avaliacoes);
  }

  Map<Object, double> calcularMediaPorCardapio(
      List<AvaliacaoCardapio> avaliacoes) {
    return CardapioAvaliacaoController().calcularMediaPorCardapio(avaliacoes);
  }

  Future<void> _refreshData() async {
    setState(() {
      _avaliacao = CardapioAvaliacaoController.getCardapioAvaliacao();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<AvaliacaoCardapio>>(
          future: _avaliacao,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else {
              List<AvaliacaoCardapio> avaliacoes = snapshot.data ?? [];
              if (avaliacoes.isEmpty) {
                return const Center(
                  child: Text('Nenhuma avaliação encontrada.'),
                );
              }
              double media = calcularMediaGeral(avaliacoes);
              avaliacoes
                  .sort((a, b) => b.dataCardapio.compareTo(a.dataCardapio));
              Map<Object, double> mediaPorCardapio =
                  calcularMediaPorCardapio(avaliacoes);
              Map<String, List<AvaliacaoCardapio>> avaliacoesAgrupadas =
                  agruparAvaliacoesPorCardapio(avaliacoes);
              return SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: _buildStarRating(media),
                      ),
                      SizedBox(
                        width: kIsWeb ? 700 : null,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: avaliacoesAgrupadas.length,
                            itemBuilder: (context, index) {
                              String cardapioId =
                                  avaliacoesAgrupadas.keys.elementAt(index);
                              List<AvaliacaoCardapio> avaliacoesDoCardapio =
                                  avaliacoesAgrupadas[cardapioId] ?? [];
                              calcularMediaGeral(avaliacoesDoCardapio);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                                  child: ExpansionTile(
                                    childrenPadding: const EdgeInsets.only(
                                      right: 24,
                                      left: 24,
                                      bottom: 8,
                                    ),
                                    leading: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenImage(
                                              imagePath: avaliacoesDoCardapio
                                                  .first.imagemURLCardapio,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ImageThumb(
                                        imageURL: avaliacoesDoCardapio
                                            .first.thumbURLCardapio,
                                      ),
                                    ),
                                    title: Text(
                                      avaliacoesDoCardapio.first.nomeCardapio,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.fontSecundaryColor,
                                      ),
                                    ),
                                    trailing: Text(
                                      'Média: ${mediaPorCardapio[cardapioId]?.toStringAsFixed(1) ?? 'N/A'}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              CustomColors.fontSecundaryColor),
                                    ),
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Text(
                                          'Comentários:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                CustomColors.fontSecundaryColor,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: avaliacoesDoCardapio
                                            .where((avaliacao) =>
                                                avaliacao.comentario.isNotEmpty)
                                            .map((avaliacao) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: Card(
                                              color:
                                                  CustomColors.secondaryColor,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: BorderSide.none,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                          Icons.chat_sharp,
                                                          color: CustomColors
                                                              .fontPrimaryColor,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            '- ${avaliacao.comentario}',
                                                            style:
                                                                const TextStyle(
                                                              color: CustomColors
                                                                  .fontPrimaryColor,
                                                              fontSize: 14,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.star,
                                                          color: CustomColors
                                                              .fontPrimaryColor,
                                                          size: 18,
                                                        ),
                                                        Text(
                                                          ' - ${avaliacao.nota.toString()}',
                                                          style:
                                                              const TextStyle(
                                                            color: CustomColors
                                                                .fontPrimaryColor,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int numberOfStars = rating.round();
    List<Widget> stars = List.generate(
      5,
      (index) => Icon(
        index < numberOfStars ? Icons.star : Icons.star_border,
        size: 30,
        color: CustomColors.secondaryColor,
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              children: stars,
            ),
            Text(
              'Média Geral: ${rating.toStringAsFixed(1)}',
              style: const TextStyle(
                  fontSize: 20, color: CustomColors.fontSecundaryColor),
            ),
          ],
        ),
      ],
    );
  }

  double calcularMediaGeral(List<AvaliacaoCardapio> avaliacoes) {
    return CardapioAvaliacaoController().calcularMediaGeral(avaliacoes);
  }
}
