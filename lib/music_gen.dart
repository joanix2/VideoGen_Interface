import 'package:flutter/material.dart';
import 'audio.dart';
import 'config.dart';

class MusicFrame extends StatefulWidget {
  final String token;
  final int id;
  const MusicFrame({super.key, required this.token, required this.id});

  @override
  MusicFrameState createState() => MusicFrameState();
}

class MusicFrameState extends State<MusicFrame> {
  List<String> textList = [
    'musique 1',
    'musique 2',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(pad), // Ajoute un padding à tout le contenu
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les boutons pour remplir la largeur
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Action à effectuer lorsque le bouton d'importation est cliqué
                  },
                  child: Padding(
                    padding: EdgeInsets.all(pad),
                    child: const Text("Importer"),
                  ),
                ),
              ),
              SizedBox(width: pad,),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Action à effectuer lorsque le bouton de génération est cliqué
                  },
                  child: Padding(
                    padding: EdgeInsets.all(pad),
                    child: const Text("Générer"),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pad), // Ajoute un espace vertical
          CardListWidget(textList: textList),
        ],
      ),
    );
  }
}

class CardListWidget extends StatelessWidget {
  final List<String> textList;

  const CardListWidget({super.key, required this.textList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: textList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            //margin: EdgeInsets.all(pad),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListTile(
                    title: Text(textList[index]),
                  ),
                ),
                const Expanded(
                  child: AudioPlayerControls(audioFilePath: '',),
                ),
                IconButton(
                  icon: const Icon(Icons.delete), // Icône de suppression
                  onPressed: () {
                    // Action à effectuer lorsque le bouton de suppression est cliqué
                  },
                  color: color1,
                )
              ],
            )
          );
        },
      ),
    );
  }
}