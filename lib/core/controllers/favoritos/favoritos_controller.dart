import 'package:log_flutter/core/models/pokemon_model.dart';
import 'package:log_flutter/core/databases/favorites_database.dart';

class FavoritoController {
  Future<bool> isFavorito(int id) async {
    return await FavoritesDatabase.isFavorited(id);
  }

  Future<void> adicionar(PokemonModel pokemon) async {
    await FavoritesDatabase.insert(pokemon);
  }

  Future<void> remover(int id) async {
    await FavoritesDatabase.delete(id);
  }

  Future<void> alternarFavorito({
    required PokemonModel pokemon,
    required Function(bool favorito, bool exibirBotaoSalvar) onStateChanged,
  }) async {
    final jaFavorito = await isFavorito(pokemon.id);

    if (jaFavorito) {
      await remover(pokemon.id);
      onStateChanged(false, false);
    } else {
      await adicionar(pokemon);
      onStateChanged(true, false);
    }
  }

  Future<void> salvarFavorito({
    required PokemonModel pokemon,
    required Function(bool exibirBotaoSalvar) onStateChanged,
  }) async {
    await adicionar(pokemon);
    onStateChanged(false);
  }
}
