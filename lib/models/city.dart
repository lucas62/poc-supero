class CityData {
  final int id;
  final String nome;
  final Map<String, dynamic> microrregiao;

  CityData({
    required this.id,
    required this.nome,
    required this.microrregiao,
  });

  const CityData.empty({
    this.id = 0,
    this.nome = '',
    this.microrregiao = const {},
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      id: json['id'],
      nome: json['nome'],
      microrregiao: json['microrregiao'],
    );
  }
}