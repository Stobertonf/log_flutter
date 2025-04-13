import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:log_flutter/core/models/pokemon_model.dart';

class PokeApiService {
  static Future<PokemonModel?> buscarPokemon(String nome) async {
    try {
      final response =
          await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$nome'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PokemonModel.fromJson(json);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
