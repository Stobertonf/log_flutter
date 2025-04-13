import 'package:flutter/material.dart';
import 'package:log_flutter/core/models/pokemon_model.dart';
import 'package:log_flutter/core/services/favorites_database.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<PokemonModel> favoritos = [];

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
  }

  Future<void> _carregarFavoritos() async {
    final lista = await FavoritesDatabase.getAll();
    setState(() {
      favoritos = lista;
    });
  }

  Future<void> _removerFavorito(int id) async {
    await FavoritesDatabase.delete(id);
    _carregarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Favoritos')),
      body: favoritos.isEmpty
          ? const Center(child: Text('Nenhum Pokémon favoritado.'))
          : ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final p = favoritos[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(p.imageUrl, height: 50),
                    title: Text(p.name.toUpperCase()),
                    subtitle: Text('ID: ${p.id}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removerFavorito(p.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
