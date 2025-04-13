class PokemonModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final String imageUrl;
  final Map<String, int> stats;

  PokemonModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.imageUrl,
    required this.stats,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List?)
            ?.map((t) => t['type']['name'] as String)
            .toList() ??
        [];

    final abilities = (json['abilities'] as List?)
            ?.map((a) => a['ability']['name'] as String)
            .toList() ??
        [];

    final stats = <String, int>{};
    if (json['stats'] != null) {
      for (var s in json['stats']) {
        stats[s['stat']['name']] = s['base_stat'];
      }
    }

    return PokemonModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      types: types,
      abilities: abilities,
      imageUrl: json['sprites']['front_default'] ?? '',
      stats: stats,
    );
  }

  @override
  String toString() {
    return 'ID: $id, Nome: $name, Tipos: $types';
  }
}
