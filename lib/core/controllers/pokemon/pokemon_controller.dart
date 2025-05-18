import 'package:flutter/material.dart';
import 'package:log_flutter/core/controllers/favoritos/favoritos_controller.dart';
import 'package:log_flutter/core/models/pokemon_model.dart';
import 'package:log_flutter/core/services/poke_api_service.dart';
import 'package:log_flutter/core/widgets/snackbar/custom_snackbar.dart';
import 'package:log_flutter/core/databases/favorites_database.dart';

class PokemonController {
  static Color getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.deepOrange;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.amber;
      case 'grass':
        return Colors.green;
      case 'bug':
        return Colors.lightGreen;
      case 'poison':
        return Colors.purple;
      case 'psychic':
        return Colors.pinkAccent;
      case 'normal':
        return Colors.grey;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey.shade700;
      case 'fighting':
        return Colors.redAccent;
      case 'ghost':
        return Colors.indigo;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigoAccent;
      case 'fairy':
        return Colors.pink;
      case 'dark':
        return Colors.black87;
      case 'steel':
        return Colors.blueGrey;
      case 'flying':
        return Colors.lightBlueAccent;
      default:
        return Colors.grey;
    }
  }

  Future<void> buscarPokemon({
    required BuildContext context,
    required TextEditingController controller,
    required Function(PokemonModel) onSuccess,
    required Function(String) onError,
    required Function(bool) onLoading,
  }) async {
    onLoading(true);
    final nome = controller.text.trim().toLowerCase();

    if (nome.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      CustomSnackBar.show(
        context: context,
        message: 'Por favor, digite o nome do Pokémon.',
        type: SnackBarType.warning,
      );
      onLoading(false);
      return;
    }

    try {
      final resultado = await PokeApiService.buscarPokemon(
        nome,
      );

      if (resultado != null) {
        final favorito = await FavoritesDatabase.isFavorited(
          resultado.id,
        );
        resultado.isFavorite = favorito;
        onSuccess(resultado);
        CustomSnackBar.show(
          context: context,
          message: '${resultado.name} encontrado com sucesso!',
          type: SnackBarType.success,
        );
      } else {
        onError('Pokémon não encontrado.');
        CustomSnackBar.show(
          context: context,
          message: 'Pokémon não encontrado.',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      onError(
        'Erro ao buscar Pokémon.',
      );
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao buscar Pokémon.',
        type: SnackBarType.error,
      );
    } finally {
      onLoading(false);
    }
  }

  Widget buildResultado({
    required bool isLoading,
    required String? mensagemErro,
    required PokemonModel? pokemon,
    required Color cardColor,
    required bool isDarkText,
    required VoidCallback? onUnfavorite,
    required VoidCallback? onSave,
    required bool favorito,
  }) {
    if (isLoading) return const CircularProgressIndicator();

    if (mensagemErro != null) {
      return Text(
        mensagemErro,
        style: const TextStyle(
          color: Colors.red,
        ),
      );
    }

    if (pokemon == null) {
      return const Text(
        'Nenhum resultado encontrado',
      );
    }

    return Card(
      margin: const EdgeInsets.only(
        top: 24,
      ),
      elevation: 4,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: isDarkText ? Colors.white : Colors.black87,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.network(
                      pokemon.imageUrl,
                      height: 100,
                    ),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${pokemon.id}',
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                'Altura: ${pokemon.height}',
              ),
              Text(
                'Peso: ${pokemon.weight}',
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Tipos: ${pokemon.types.join(', ')}',
              ),
              Text(
                'Habilidades: ${pokemon.abilities.join(', ')}',
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Status base:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...pokemon.stats.entries.map(
                (entry) => Text(
                  '${entry.key.toUpperCase()}: ${entry.value},',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StatefulBuilder(
                    builder: (context, setStateIcon) {
                      final favoritoController = FavoritoController();

                      return GestureDetector(
                        onTap: () async {
                          await favoritoController.alternarFavorito(
                            pokemon: pokemon,
                            onStateChanged: (favorito, _) {
                              pokemon.isFavorite = favorito;
                              favorito
                                  ? CustomSnackBar.show(
                                      context: context,
                                      message:
                                          '${pokemon.name} salvo como favorito!',
                                      type: SnackBarType.success,
                                    )
                                  : CustomSnackBar.show(
                                      context: context,
                                      message:
                                          '${pokemon.name} removido dos favoritos.',
                                      type: SnackBarType.warning,
                                    );
                              setStateIcon(
                                () {},
                              );
                            },
                          );
                        },
                        child: Icon(
                          pokemon.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 32,
                          color: pokemon.isFavorite
                              ? Colors.red
                              : (isDarkText ? Colors.white : Colors.black54),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
