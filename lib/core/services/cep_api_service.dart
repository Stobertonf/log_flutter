import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:log_flutter/core/models/cep_model.dart';

class CepApiService {
  static Future<CepModel?> buscarCep(String cep) async {
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CepModel.fromJson(json);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
