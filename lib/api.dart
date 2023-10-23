import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String address = 'http://127.0.0.1:8000/';

//############################# POST ###############################

Future<http.Response?> sendPostRequest({required String view, required Map<String, dynamic> body, String? token}) async {
  try {
    Uri url = Uri.parse('$address$view/');

    // Envoyer la requête POST
    http.Response response = await http.post(url,
        headers:
        {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'JWT $token',
          //'Referer': 'http://localhost:9000/',
          //'Origin': 'http://localhost:9000/',
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      // Requête réussie
      if (kDebugMode) {
        print('Requête POST réussie');
      }
      //return jsonDecode(response.body);
    } else {
      // Requête échouée
      if (kDebugMode) {
        print('Échec de la requête POST');
      }
      if (kDebugMode) {
        print('Code d\'erreur : ${response.statusCode}');
      }
    }
    return response;
  } catch (error) {
    // Erreur lors de l'envoi de la requête
    if (kDebugMode) {
      print('Erreur : $error');
    }
  }
  // En cas d'erreur ou de requête échouée, renvoyer une valeur nulle
  return null;
}

//############################# GET with token ###############################

Future<http.Response> tokenGet({required String view, required String token}) async {
  final url = Uri.parse('$address$view/');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
    );

    return response; // Renvoie directement la réponse HTTP
  } catch (error) {
    // Gestion des erreurs, affichez un message d'erreur si nécessaire
    if (kDebugMode) {
      print('Erreur lors de la requête HTTP : $error');
    }
    // En cas d'erreur, renvoyer null ou une réponse d'erreur personnalisée si nécessaire
    return http.Response('Erreur lors de la requête HTTP', 500);
  }
}

//############################# DELETE with token ###############################

Future<http.Response?> sendDeleteRequest({required String view, String? token}) async {
  try {
    Uri url = Uri.parse('$address$view/'); // Remplacez par votre adresse de base

    // Envoyer la requête DELETE
    http.Response response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'JWT $token',
      },
    );

    if (response.statusCode == 200) {
      // Requête réussie
      if (kDebugMode) {
        print('Requête DELETE réussie');
      }
      // Vous pouvez ajouter ici d'autres traitements si nécessaire
    } else {
      // Requête échouée
      if (kDebugMode) {
        print('Échec de la requête DELETE');
      }
      if (kDebugMode) {
        print('Code d\'erreur : ${response.statusCode}');
      }
    }
    return response;
  } catch (error) {
    // Erreur lors de l'envoi de la requête
    if (kDebugMode) {
      print('Erreur : $error');
    }
  }
  // En cas d'erreur ou de requête échouée, renvoyer une valeur nulle
  return null;
}

//############################# PUT with token ###############################

Future<http.Response?> sendPutRequest({
  required String view,
  required String? token,
  required Map<String, dynamic>? requestBody, // Corps de la requête PUT (facultatif)
}) async {
  try {
    Uri url = Uri.parse('$address$view/');

    // Envoyer la requête PUT
    http.Response response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'JWT $token',
      },
      body: requestBody != null ? jsonEncode(requestBody) : null,
    );

    if (response.statusCode == 200) {
      // Requête réussie
      if (kDebugMode) {
        print('Requête PUT réussie');
      }
      // Vous pouvez ajouter ici d'autres traitements si nécessaire
    } else {
      // Requête échouée
      if (kDebugMode) {
        print('Échec de la requête PUT');
      }
      if (kDebugMode) {
        print('Code d\'erreur : ${response.statusCode}');
      }
    }
    return response;
  } catch (error) {
    // Erreur lors de l'envoi de la requête
    if (kDebugMode) {
      print('Erreur : $error');
    }
  }
  // En cas d'erreur ou de requête échouée, renvoyer une valeur nulle
  return null;
}

