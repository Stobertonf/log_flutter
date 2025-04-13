import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: Create API screens
    final apis = [
      {'nome': 'Pokédex', 'page': const HomePage()},
      {'nome': 'CEP (ViaCEP)', 'page': const HomePage()},
      {'nome': 'Clima (Open-Meteo)', 'page': const HomePage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logs Com Flutter',
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: apis.length,
        itemBuilder: (_, index) {
          final api = apis[index];
          return ListTile(
            title: Text(api['nome'] as String),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => api['page'] as Widget),
              );
            },
          );
        },
      ),
    );
  }
}
