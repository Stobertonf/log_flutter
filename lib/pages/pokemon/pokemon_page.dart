import 'package:flutter/material.dart';
import 'package:log_flutter/core/controllers/pokemon/pokemon_controller.dart';
import 'package:log_flutter/pages/log/logs_page.dart';
import 'package:log_flutter/core/models/pokemon_model.dart';
import 'package:log_flutter/core/widgets/snackbar/custom_snackbar.dart';
import 'package:log_flutter/core/services/poke_api_service.dart';
import 'package:log_flutter/pages/favoritos/favoritos_page.dart';
import 'package:log_flutter/core/databases/favorites_database.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final TextEditingController _controller = TextEditingController();
  PokemonModel? _pokemon;
  bool _isLoading = false;
  String? _mensagemErro;
  bool _favorito = false;
  bool _exibirBotaoSalvar = false;

  Future<void> _buscarPokemon(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _mensagemErro = null;
      _pokemon = null;
    });

    final nome = _controller.text.trim().toLowerCase();

    if (nome.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      CustomSnackBar.show(
        context: context,
        message: 'Por favor, digite o nome do Pokémon.',
        type: SnackBarType.warning,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final resultado = await PokeApiService.buscarPokemon(nome);

      if (resultado != null) {
        final jaFavorito = await FavoritesDatabase.isFavorited(resultado.id);
        resultado.isFavorite = jaFavorito;

        setState(() {
          _pokemon = resultado;
          _favorito = jaFavorito;
          _exibirBotaoSalvar = !jaFavorito;
        });

        CustomSnackBar.show(
          context: context,
          message: '${resultado.name} encontrado com sucesso!',
          type: SnackBarType.success,
        );
      } else {
        setState(() {
          _mensagemErro = 'Pokémon não encontrado.';
        });

        CustomSnackBar.show(
          context: context,
          message: 'Pokémon não encontrado.',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      setState(
        () {
          _mensagemErro = 'Erro ao buscar Pokémon.';
        },
      );

      CustomSnackBar.show(
        context: context,
        message: 'Erro ao buscar Pokémon.',
        type: SnackBarType.error,
      );
    } finally {
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar Pokémon',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
            ),
            tooltip: 'Ver favoritos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritosPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.article),
            tooltip: 'Ver logs',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LogsPokemonPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (scaffoldContext) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  onSubmitted: (_) => _isLoading
                      ? null
                      : _buscarPokemon(
                          scaffoldContext,
                        ),
                  decoration: InputDecoration(
                    labelText: 'Nome do Pokémon',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _isLoading
                          ? null
                          : () => _buscarPokemon(
                                scaffoldContext,
                              ),
                      tooltip: 'Buscar Pokémon',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                PokemonController().buildResultado(
                  isLoading: _isLoading,
                  mensagemErro: _mensagemErro,
                  pokemon: _pokemon,
                  cardColor: _pokemon != null
                      ? PokemonController.getColorByType(_pokemon!.types.first)
                      : Colors.white,
                  isDarkText: ThemeData.estimateBrightnessForColor(
                        _pokemon != null
                            ? PokemonController.getColorByType(
                                _pokemon!.types.first)
                            : Colors.white,
                      ) ==
                      Brightness.dark,
                  onUnfavorite: () async {
                    if (_pokemon != null && _favorito) {
                      await FavoritesDatabase.delete(_pokemon!.id);
                      _pokemon!.isFavorite = false;
                      setState(() {
                        _favorito = false;
                        _exibirBotaoSalvar = false;
                      });
                      CustomSnackBar.show(
                        context: context,
                        message: '${_pokemon!.name} removido dos favoritos.',
                        type: SnackBarType.warning,
                      );
                    } else if (_pokemon != null && !_favorito) {
                      await FavoritesDatabase.insert(_pokemon!);
                      _pokemon!.isFavorite = true;
                      setState(() {
                        _favorito = true;
                        _exibirBotaoSalvar = false;
                      });
                      CustomSnackBar.show(
                        context: context,
                        message: '${_pokemon!.name} salvo como favorito!',
                        type: SnackBarType.success,
                      );
                    }
                  },
                  onSave: () async {
                    if (_pokemon != null) {
                      await FavoritesDatabase.insert(_pokemon!);
                      setState(() {
                        _exibirBotaoSalvar = false;
                      });
                      CustomSnackBar.show(
                        context: context,
                        message: '${_pokemon!.name} salvo como favorito!',
                        type: SnackBarType.success,
                      );
                    }
                  },
                  favorito: _favorito,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
