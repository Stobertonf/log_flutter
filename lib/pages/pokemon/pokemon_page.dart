import 'package:flutter/material.dart';
import 'package:f_logs/f_logs.dart';
import 'package:log_flutter/core/models/pokemon_model.dart';
import 'package:log_flutter/core/services/poke_api_service.dart';

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

  Future<void> _buscarPokemon() async {
    final nome = _controller.text.trim().toLowerCase();
    if (nome.isEmpty) return;

    setState(() {
      _isLoading = true;
      _mensagemErro = null;
      _pokemon = null;
    });

    FLog.info(
      className: 'PokemonPage',
      methodName: '_buscarPokemon',
      text: 'Buscando Pokémon: $nome',
    );

    try {
      final resultado = await PokeApiService.buscarPokemon(nome);

      if (resultado != null) {
        setState(() {
          _pokemon = resultado;
        });

        FLog.info(
          className: 'PokemonPage',
          methodName: '_buscarPokemon',
          text: 'Resultado: ${resultado.toString()}',
        );
      } else {
        setState(() {
          _mensagemErro = 'Pokémon não encontrado.';
        });

        FLog.warning(
          className: 'PokemonPage',
          methodName: '_buscarPokemon',
          text: 'Nenhum resultado para: $nome',
        );
      }
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao buscar Pokémon.';
      });

      FLog.error(
        className: 'PokemonPage',
        methodName: '_buscarPokemon',
        text: 'Exceção ao buscar Pokémon',
        exception: e.toString(),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildResultado() {
    if (_isLoading) return const CircularProgressIndicator();

    if (_mensagemErro != null) {
      return Text(_mensagemErro!, style: const TextStyle(color: Colors.red));
    }

    if (_pokemon == null) {
      return const Text(
        'Nenhum resultado encontrado',
      );
    }

    return Card(
      margin: const EdgeInsets.only(top: 24),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.network(
                    _pokemon!.imageUrl,
                    height: 100,
                  ),
                  Text(
                    _pokemon!.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: ${_pokemon!.id}',
                  ),
                ],
              ),
            ),
            const Divider(),
            Text(
              'Altura: ${_pokemon!.height}',
            ),
            Text(
              'Peso: ${_pokemon!.weight}',
            ),
            const SizedBox(
              height: 8,
            ),
            Text('Tipos: ${_pokemon!.types.join(', ')},'),
            Text('Habilidades: ${_pokemon!.abilities.join(', ')},'),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Status base:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ..._pokemon!.stats.entries.map(
              (entry) => Text(
                '${entry.key.toUpperCase()}: ${entry.value}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar Pokémon',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Nome do Pokémon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _buscarPokemon,
                icon: const Icon(
                  Icons.search,
                ),
                label: const Text(
                  'Buscar',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildResultado(),
            ],
          ),
        ),
      ),
    );
  }
}
