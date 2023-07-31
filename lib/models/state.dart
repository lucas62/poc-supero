class StateData {
  final int id;
  final String sigla;
  final String nome;
  final Map<String, dynamic> regiao;

  StateData({
    required this.id,
    required this.sigla,
    required this.nome,
    required this.regiao,
  });

  const StateData.empty({
    this.id = 0,
    this.sigla = '',
    this.nome = '',
    this.regiao = const {},
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      id: json['id'],
      sigla: json['sigla'],
      nome: json['nome'],
      regiao: json['regiao'],
    );
  }
}