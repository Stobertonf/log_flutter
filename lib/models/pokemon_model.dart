class PokemonModel {
  final String name;
  final int height;
  final int weight;

  PokemonModel({
    required this.name,
    required this.height,
    required this.weight,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
    );
  }

  @override
  String toString() {
    return 'PokemonModel: $name, Altura: $height, Peso: $weight';
  }
}
