import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api.dart';

// Fonction pour récupérer les projets depuis le serveur
Future<void> getProject({required String token, required int id, required Function(Project project) onReceive}) async {
  try {
    final response = await tokenGet(view: '/project/$id', token: token);

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      onReceive(Project.fromJson(jsonData));
    } else {
      if (kDebugMode) {
        print('Échec de la requête GET : ${response.statusCode}');
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print('Erreur lors de la récupération des projets : $error');
    }
  }
}

class Project {
  final int id;
  final String name;
  final String title;
  final String description;
  final bool sent;

  Project({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.sent,
  });

  // Méthode pour créer une instance de Project à partir de données JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      sent: json['sent'] as bool,
    );
  }
}

Future<List<Clip>> getProjectClips({required String token, required int id}) async {
  try {
    final response = await tokenGet(view: '/project/clips/$id', token: token);

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      // Assurez-vous que le JSON renvoyé contient la liste des clips
      final List<dynamic> clipData = jsonData['clips'];

      // Convertissez les données JSON en une liste d'objets Clip
      return clipData.map((data) => Clip.fromJson(data)).toList();

    } else {
      if (kDebugMode) {
        print('Échec de la requête GET : ${response.statusCode}');
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print('Erreur lors de la récupération des projets : $error');
    }
  }
  return [];
}

class Clip {
  final int id;
  final int index;
  final String text;
  final String? audioUrl;
  final String? imageUrl;
  final String? videoUrl;

  Clip({
    required this.id,
    required this.index,
    required this.text,
    this.audioUrl,
    this.imageUrl,
    this.videoUrl,
  });

  // Méthode pour créer une instance de Clip à partir de données JSON
  factory Clip.fromJson(Map<String, dynamic> json) {
    return Clip(
      id: json['id'] as int,
      index: json['index'] as int,
      text: json['text'] as String,
      audioUrl: json['audio'] as String?, // Assurez-vous de correspondre au nom du champ dans les données JSON
      imageUrl: json['image'] as String?, // Assurez-vous de correspondre au nom du champ dans les données JSON
      videoUrl: json['video'] as String?, // Assurez-vous de correspondre au nom du champ dans les données JSON
    );
  }
}
