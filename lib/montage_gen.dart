import 'package:flutter/material.dart';
import 'utilities.dart';

class MontageFrame extends StatefulWidget {
  final String token;
  final int id;

  const MontageFrame({super.key, required this.token, required this.id});

  @override
  MontageFrameState createState() => MontageFrameState();
}

class MontageFrameState extends State<MontageFrame> {
  String selectedFormat = "Horizontal"; // Format de la vidéo sélectionné par défaut

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Choix du format de la vidéo (Horizontal/Vertical)
        CustomDropdownMenu(
          labelText: "Format de la vidéo",
          items: ["Horizontal", "Vertical"],
          onChanged: (selected) {
            setState(() {
              selectedFormat = selected!;
            });
          },
        ),

        // Intro
        HideFrame(
          checkboxText: " Ajouter une intro",
          child: CustomDropdownMenu(
            labelText: "Intro:",
            items: const ["Intro 1", "Intro 2", "Intro 3"],
            onChanged: (selected) {
              setState(() {
                selectedFormat = selected!;
              });
            },
          ),
        ),

        // Outro
        HideFrame(
          checkboxText: " Ajouter une outro",
          child: CustomDropdownMenu(
            labelText: "Outro:",
            items: const ["Outro 1", "Outro 2", "Outro 3"],
            onChanged: (selected) {
              setState(() {
                selectedFormat = selected!;
              });
            },
          ),
        ),

        // Création du label "Génération de la vidéo"
        const Text("Génération de la vidéo"),

        // Création du bouton "Monter la vidéo"
        ElevatedButton(
          onPressed: generateVideo,
          child: const Text("Monter la vidéo"),
        ),

        // Initialisation de la variable pour le bouton "Visionner"
        ElevatedButton(
          onPressed: () {
            // Mettez en œuvre la logique du bouton "Visionner" ici
          },
          child: const Text("Visionner"),
        ),
      ],
    );
  }

  void generateVideo() {
    // Mettez en œuvre la logique de génération de la vidéo ici
  }
}
