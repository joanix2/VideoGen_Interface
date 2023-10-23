import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_gen_app/project.dart';
import 'package:video_gen_app/utilities.dart';
import 'package:video_gen_app/video_script.dart';
import 'api.dart';
import 'config.dart';

class TextFrame extends StatefulWidget {
  final String token;
  final int id;

  const TextFrame({Key? key, required this.token, required this.id}) : super(key: key);

  @override
  TextFrameState createState() => TextFrameState();
}

class TextFrameState extends State<TextFrame> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController scriptController = TextEditingController();

  Future<void>? _projectFuture;
  Project? currentProject;

  @override
  void initState() {
    super.initState();
    _projectFuture = getProject(
        token: widget.token,
        id: widget.id,
        onReceive: (project) {
          currentProject = project;
        });
  }

  Future<void> updateProject({
    required String param,
    required String text,
  }) async {
    try {
      Map<String, dynamic> requestBody = {
        param: text,
      };
      http.Response? response = await sendPutRequest(view: 'project/${widget.id}', requestBody: requestBody, token: widget.token);
      if (response != null && response.statusCode == 200) {
        // La requête POST a réussi, vous pouvez effectuer des actions supplémentaires ici si nécessaire
        if (kDebugMode) {
          print('Nouveau titre enregistré avec succès');
        }
      } else {
        // La requête POST a échoué, vous pouvez gérer les erreurs ici si nécessaire
        if (kDebugMode) {
          print('Échec de l\'enregistrement du nouveau titre');
        }
      }
    } catch (error) {
      // Gérer les erreurs d'envoi de requête ici
      if (kDebugMode) {
        print('Erreur lors de l\'envoi de la requête : $error');
      }
    }
  }

  Future<String?> getText({required String prompt, required int maxToken}) async {
    http.Response? response = await sendPostRequest(
        view: 'textgen/${widget.id}',
        body: {
          "prompt" : prompt,
          "max_tokens" : maxToken
        },
        token: widget.token
    );
    if (response != null && response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      // Assurez-vous que le JSON renvoyé contient la liste des clips
      final String text = jsonData['generated_text'];
      return text;
    }
    return null;
  }

  void updateTitle(String text){
    if (kDebugMode) {
      print(text);
    }
    updateProject(param: 'new_title', text: text,);
    titleController.text = text;
  }

  void updateDescription(String text){
    if (kDebugMode) {
      print(text);
    }
    updateProject(param: 'new_description', text: text,);
    descriptionController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _projectFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher la barre de chargement pendant le chargement
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Gérer les erreurs ici
          return const Text('Error');
        } else if (currentProject == null) {
          // Gérer les erreurs ici
          return Text('No project with id ${widget.id}');
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(pad),
              child: Column(
                children: [
                  // Champ de texte pour le thème de la vidéo
                  TextInputFrame(
                    title: "Thème de la vidéo",
                    textToCopy: '',
                    controller: titleController,
                    defaultText: currentProject!.title,
                    onChanged: (text) {
                      //updateProject(param: 'new_title', text: text,);
                    },
                    onDeletePressed: (){
                      updateTitle("");
                    },
                    onGeneratePressed: () async {
                      /*
                      String? text = await getText(
                          prompt : "donne moi un titre de video youtube",
                          maxToken : 20
                      );
                      if (text != null) {
                        updateTitle(text);
                      }
                      */
                    },
                  ),

                  // Champ de texte pour le titre de la vidéo
                  TextInputFrame(
                    title: "Titre de la vidéo",
                    textToCopy: '',
                    controller: titleController,
                    defaultText: currentProject!.title,
                    onChanged: (text) {
                      updateProject(param: 'new_title', text: text,);
                    },
                    onDeletePressed: (){
                      updateTitle("");
                    },
                    onGeneratePressed: () async {
                      String? text = await getText(
                          prompt : "donne moi un titre de video youtube",
                          maxToken : 20
                      );
                      if (text != null) {
                        updateTitle(text);
                      }
                    },
                  ),

                  // Champ de texte pour la description de la vidéo
                  TextInputFrame(
                    title: "Description de la vidéo",
                    textToCopy: '',
                    controller: descriptionController,
                    defaultText: currentProject!.description,
                    onChanged: (text) {
                      updateProject(param: 'new_description', text: text,);
                    },
                    onDeletePressed: (){
                      updateDescription("");
                    },
                    onGeneratePressed: () async {
                      String? text = await getText(
                          prompt : "écrit la description de la video youtube",
                          maxToken : 1000
                      );
                      if (text != null) {
                        updateDescription(text);
                      }
                    },
                  ),
                  ClipListFrame(
                    title: 'Script de la vidéo', token: widget.token, id: widget.id,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    // Disposez des contrôleurs lorsque le widget est détruit pour éviter les fuites de mémoire
    titleController.dispose();
    descriptionController.dispose();
    scriptController.dispose();
    super.dispose();
  }
}


/*
void _copyToClipboard(String text, BuildContext context) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Texte copié dans le presse-papiers"),
    ),
  );
}
*/

class TextInputFrame extends StatelessWidget {
  final String title;
  final String textToCopy;
  final TextEditingController controller;
  final Function(String text)? onChanged;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onGeneratePressed;
  final String defaultText;

  const TextInputFrame({super.key, required this.title, required this.textToCopy, required this.controller, this.defaultText = "", this.onChanged, this.onDeletePressed, this.onGeneratePressed});

  @override
  Widget build(BuildContext context) {
    controller.text = const Utf8Codec().decode(defaultText.codeUnits);
    return Column(
      children: [
        SizedBox(height: pad, width: pad),
        Text(title, style: title1),
        SizedBox(height: pad, width: pad),
        ButtonRow(
          onGeneratePressed: () {
            onGeneratePressed!();
          },
          onDeletePressed: (){
            onDeletePressed!();
          }
        ),
        SizedBox(height: pad, width: pad),
        TextField(
          controller: controller, // Utilisez le contrôleur fourni
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            hintText: 'Enter text...',
            fillColor: Colors.white54,
          ),
          onChanged: onChanged, // Set the onChanged callback
        ),
      ],
    );
  }
}




