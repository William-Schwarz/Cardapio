// ignore: unnecessary_import
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cardapio/configs/helpers/formatting.dart';
import 'package:cardapio/configs/theme/colors.dart';
import 'package:cardapio/configs/theme/snack_bar.dart';
import 'package:cardapio/controller/cardapio_controller.dart';
import 'package:cardapio/view/list_cardapios_dia_atual_view.dart';
import 'package:cardapio/view/navigation.dart';

class Atualizar extends StatefulWidget {
  const Atualizar({Key? key}) : super(key: key);

  @override
  State<Atualizar> createState() => _AtualizarState();
}

class _AtualizarState extends State<Atualizar> {
  final CardapioController uploadController = CardapioController();
  late ListCardapiosDiaAtualState _listMenuController;
  late DateTime _startDate;
  late DateTime _endDate;
  late String _descricao = '';
  bool _isLoading = false;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(
        const Duration(
          days: 365,
        ),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    if (picked != null &&
        picked != _startDate &&
        picked.isBefore(_endDate) &&
        mounted) {
      setState(() {
        _startDate = picked;
      });
    } else if (picked != null && mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Inicial Inválida!'),
            content: const Text(
              'Por favor, selecione uma data inicial válida antes da data final.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now().subtract(
        const Duration(
          days: 365,
        ),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    if (picked != null &&
        picked != _endDate &&
        picked.isAfter(_startDate) &&
        mounted) {
      setState(() {
        _endDate = picked;
      });
    } else if (picked != null && mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Final Inválida!'),
            content: const Text(
              'Por favor, selecione uma data final válida após a data inicial.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _saveCardapio(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (_descricao.isNotEmpty && mounted) {
      await uploadController.postCardapios(
        nome: _descricao,
        dataInicial:
            DateTime(_startDate.year, _startDate.month, _startDate.day),
        dataFinal: DateTime(_endDate.year, _endDate.month, _endDate.day),
        imagemURL: uploadController.imageData!,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Navigation(),
        ),
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      CustomSnackBar.showDefault(context, 'Cardápio atualizado com sucesso!');
    } else if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao Salvar!'),
            content: const Text(
              'Por favor, preencha o campo de Descrição do Cardápio.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _listMenuController = ListCardapiosDiaAtualState();
    _startDate = DateTime.now();
    _endDate = _startDate.add(
      const Duration(days: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: kIsWeb ? 600 : null,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _descricao = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Descrição do Cardápio',
                              labelStyle: TextStyle(
                                color: CustomColors.fontSecundaryColor,
                              ),
                              hintText: 'Ex: Cardápio Especial',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.secondaryColor,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: CustomColors.fontSecundaryColor,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await _selectStartDate(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.tertiaryColor,
                                ),
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: CustomColors.secondaryColor,
                                ),
                                label: Text(
                                  'Início: ${Formatter.formatDate(_startDate)}',
                                  style: const TextStyle(
                                    color: CustomColors.fontSecundaryColor,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await _selectEndDate(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.tertiaryColor,
                                ),
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: CustomColors.secondaryColor,
                                ),
                                label: Text(
                                  'Fim: ${Formatter.formatDate(_endDate)}',
                                  style: const TextStyle(
                                    color: CustomColors.fontSecundaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (uploadController.imageData != null)
                            Image.memory(
                              uploadController.imageData!,
                              fit: BoxFit.contain,
                            ),
                          if (uploadController.imageData != null)
                            const SizedBox(
                              height: 5,
                            ),
                          (uploadController.imageData != null)
                              ? ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      uploadController.imageData = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.tertiaryColor,
                                  ),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: CustomColors.secondaryColor,
                                  ),
                                  label: const Text(
                                    'Remover',
                                    style: TextStyle(
                                      color: CustomColors.fontSecundaryColor,
                                    ),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await uploadController.pickImage();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.tertiaryColor,
                                  ),
                                  icon: const Icon(
                                    Icons.upload,
                                    color: CustomColors.secondaryColor,
                                  ),
                                  label: const Text(
                                    'Carregar Cardápio',
                                    style: TextStyle(
                                      color: CustomColors.fontSecundaryColor,
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (uploadController.imageData != null)
                            ElevatedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      await _saveCardapio(context);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.tertiaryColor,
                              ),
                              icon: const Icon(
                                Icons.save,
                                color: CustomColors.secondaryColor,
                              ),
                              label: const Text(
                                'Salvar',
                                style: TextStyle(
                                  color: CustomColors.fontSecundaryColor,
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: CustomColors.secondaryColor,
                              padding: const EdgeInsets.all(25.0),
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
                                  ? 'Fechar Cardápios Lançados Hoje'
                                  : 'Visualizar Cardápios Lançados Hoje',
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
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
