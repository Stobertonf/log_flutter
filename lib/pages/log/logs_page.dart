import 'dart:io';
import 'package:flutter/material.dart';
import 'package:f_logs/f_logs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LogsPokemonPage extends StatefulWidget {
  const LogsPokemonPage({super.key});

  @override
  State<LogsPokemonPage> createState() => _LogsPokemonPageState();
}

class _LogsPokemonPageState extends State<LogsPokemonPage> {
  List<Log> todosLogs = [];
  List<Log> logsFiltrados = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarLogs();
  }

  Future<void> _carregarLogs() async {
    final logs = await FLog.getAllLogs();

    final apenasPokemonPage = logs
        .where((log) => log.className == 'PokemonPage')
        .toList()
        .reversed
        .toList();

    setState(() {
      todosLogs = apenasPokemonPage;
      logsFiltrados = apenasPokemonPage;
    });
  }

  void _filtrarLogs(String texto) {
    final query = texto.toLowerCase();

    final resultado = todosLogs.where((log) {
      final texto = log.text?.toLowerCase() ?? '';
      final metodo = log.methodName?.toLowerCase() ?? '';
      final classe = log.className?.toLowerCase() ?? '';
      return texto.contains(query) ||
          metodo.contains(query) ||
          classe.contains(query);
    }).toList();

    setState(() {
      logsFiltrados = resultado;
    });
  }

  Future<void> _exportarLogsComoTxt() async {
    final conteudo = logsFiltrados.map((log) {
      return '[${log.timestamp}] ${log.className}.${log.methodName}: ${log.text}';
    }).join('\n');

    final dir = await getApplicationDocumentsDirectory();
    final arquivo = File('${dir.path}/Log - PokemonPage.txt');
    await arquivo.writeAsString(conteudo);

    await Share.shareXFiles(
      [XFile(arquivo.path)],
      text: 'Logs da tela PokemonPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logs de Pokémon',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Exportar e compartilhar',
            onPressed: _exportarLogsComoTxt,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _filtrarLogs,
              decoration: const InputDecoration(
                labelText: 'Buscar log por palavra',
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
          Expanded(
            child: logsFiltrados.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum log registrado.',
                    ),
                  )
                : ListView.builder(
                    itemCount: logsFiltrados.length,
                    itemBuilder: (context, index) {
                      final log = logsFiltrados[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.bug_report_outlined,
                        ),
                        title: Text(
                          log.text ?? '',
                        ),
                        subtitle: Text(
                          '${log.methodName ?? ''} | ${log.timestamp ?? ''}',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
