import 'package:flutter/material.dart';
import 'package:video_gen_app/config.dart';
import 'audio.dart';
import 'utilities.dart';
import 'video_script.dart';

class VoiceFrame extends StatelessWidget {
  final String token;
  final int id;

  const VoiceFrame({super.key, required this.token, required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Choix de la langue', style: title1),
        CustomDropdownMenu(
          labelText: "Selection de la langue",
          items: const ["English", "French", "German"],
          onChanged: (selectedLanguage) {
            // Mettez en œuvre la logique de sélection de la langue ici
          },
        ),
        Text('Choix de la voix', style: title1),
        CustomDropdownMenu(
          labelText: "Selection de la voix",
          items: const ["speaker3", "speaker6"],
          onChanged: (selectedVoice) {
            // Mettez en œuvre la logique de sélection de la voix ici
          },
        ),
        Builder(
          builder: (BuildContext context) {
            double screenWidth = MediaQuery.of(context).size.width;

            if (screenWidth < 600) {
              // Si la largeur de l'écran est inférieure à 600 pixels
              return ClipListFrame(
                token: token,
                id: id,
                title: 'Voix de la vidéo',
                direction: Axis.vertical,
                onCreateClipWidget: (clip) {
                  // Retournez le widget AudioPlayerControls en utilisant l'instance AudioPlayer et le chemin du fichier audio
                  return const AudioPlayerControls(audioFilePath: 'chemin/vers/votre/fichier/audio.mp3');
                },
              );
            } else {
              // Si la largeur de l'écran est supérieure ou égale à 600 pixels
              return ClipListFrame(
                token: token,
                id: id,
                title: 'Voix de la vidéo',
                onCreateClipWidget: (clip) {
                  // Retournez le widget AudioPlayerControls en utilisant l'instance AudioPlayer et le chemin du fichier audio
                  return const SizedBox(
                    width: 300,
                    child: AudioPlayerControls(audioFilePath: 'chemin/vers/votre/fichier/audio.mp3'),
                  );
                },
              );
            }
          },
        )
      ],
    );
  }
}
