import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/configs/widgets/relative_size_image.dart';
import 'package:cardapio/controller/cardapio_controller.dart';
import 'package:cardapio/model/cardapios_model.dart';
import 'package:cardapio/configs/widgets/full_screen_image.dart';
import 'package:cardapio/view/list_cardapios_view.dart';

class Cardapio extends StatefulWidget {
  const Cardapio({Key? key}) : super(key: key);

  @override
  State<Cardapio> createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> {
  late ListCardapiosState _listMenuController;
  String? _imagemUrl;
  DateTime? _dataInicial;
  DateTime? _dataFinal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listMenuController = ListCardapiosState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _imagemUrl = null;
      _dataInicial = null;
      _dataFinal = null;
    });

    List<Cardapios> cardapios = await CardapioController.getCardapios();
    if (cardapios.isNotEmpty) {
      cardapios.sort((a, b) => b.data.compareTo(a.data));

      setState(() {
        _dataInicial = DateTime(
          cardapios.first.dataInicial.year,
          cardapios.first.dataInicial.month,
          cardapios.first.dataInicial.day,
        );

        _dataFinal = DateTime(
          cardapios.first.dataFinal.year,
          cardapios.first.dataFinal.month,
          cardapios.first.dataFinal.day,
        );

        DateTime dataAtual = DateTime.now();
        DateTime dataAtualSemHora =
            DateTime(dataAtual.year, dataAtual.month, dataAtual.day);
        _isLoading = false;
        if ((dataAtualSemHora.isAfter(_dataInicial!) ||
                dataAtualSemHora.isAtSameMomentAs(_dataInicial!)) &&
            (dataAtualSemHora.isBefore(_dataFinal!) ||
                dataAtualSemHora.isAtSameMomentAs(_dataFinal!))) {
          _imagemUrl = cardapios.first.imagemURL;
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: kIsWeb ? 700 : null,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imagePath: _imagemUrl!,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        if (_isLoading) const LinearProgressIndicator(),
                        if (!_isLoading && _imagemUrl != null)
                          RelativeSizeImage(imageURL: _imagemUrl!)
                        else
                          const Center(
                            child: Text(
                              'Nenhum cardápio disponível.',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: CustomColors.secondaryColor,
                            padding: const EdgeInsets.all(
                              25.0,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _listMenuController.toggleListVisibility();
                            });
                          },
                          child: Text(
                            _listMenuController.isListOpen
                                ? 'Fechar Cardápios Anteriores'
                                : 'Visualizar Cardápios Anteriores',
                            style: const TextStyle(
                              color: CustomColors.fontPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_listMenuController.isListOpen)
                          _listMenuController.build(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
