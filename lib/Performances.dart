import 'package:flutter/material.dart';

import 'drawer.dart';

class PerformancePage extends StatelessWidget {
  final String token;

  const PerformancePage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance'),
      ),
      drawer: CustomDrawer(token: token,),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Informations sur les Performances',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Ici, vous pouvez ajouter des éléments pour afficher des informations sur les performances.
          // Utilisez le token pour récupérer les données correspondantes.
        ],
      ),
    );
  }
}
