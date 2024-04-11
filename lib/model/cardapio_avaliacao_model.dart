class AvaliacaoCardapio {
  final String id;
  final String idCardapios;
  final int nota;
  final String comentario;
  final DateTime data;
  final String nomeCardapio;
  final DateTime dataCardapio;
  final DateTime dataInicialCardapio;
  final DateTime dataFinalCardapio;
  final String imagemURLCardapio;
  final String thumbURLCardapio;
  AvaliacaoCardapio({
    required this.id,
    required this.idCardapios,
    required this.nota,
    required this.comentario,
    required this.data,
    required this.nomeCardapio,
    required this.dataCardapio,
    required this.dataInicialCardapio,
    required this.dataFinalCardapio,
    required this.imagemURLCardapio,
    required this.thumbURLCardapio,
  });
}
