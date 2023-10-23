import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'config.dart';

class AudioPlayerControls extends StatefulWidget {
  final String audioFilePath;

  const AudioPlayerControls({super.key,
    required this.audioFilePath,
  });

  @override
  AudioPlayerControlsState createState() => AudioPlayerControlsState();
}

class AudioPlayerControlsState extends State<AudioPlayerControls> {
  bool isPlaying = false;
  // Créez une instance de AudioPlayer
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          color: color2,
          iconSize: 40,
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            if (isPlaying) {
              setState(() {
                audioPlayer.pause();
                isPlaying = false;
              });
            } else {
              setState(() {
                isPlaying = true;
                audioPlayer.play(AssetSource(widget.audioFilePath));
              });
            }
          },
        ),
        Expanded(
            child: Slider(
              value: 0.0,
              onChanged: (double value) {
                // Ajoutez ici la logique pour déplacer la position de lecture.
                // Vous pouvez utiliser widget.audioPlayer pour définir la position.
              },
            ),
        ),
      ],
    );
  }
}