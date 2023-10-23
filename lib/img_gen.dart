import 'package:flutter/material.dart';
import 'config.dart';
import 'video_script.dart';

class ImagesGenerationFrame extends StatefulWidget {
  final String token;
  final int id;
  const ImagesGenerationFrame({super.key, required this.token, required this.id});

  @override
  ImagesGenerationFrameState createState() => ImagesGenerationFrameState();
}

class ImagesGenerationFrameState extends State<ImagesGenerationFrame> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipListFrame(
            token: widget.token,
            id: widget.id,
            title: 'Générer toutes les images',
            direction: Axis.vertical,
            border: true,
            onCreateClipWidget: (clip) {
              return Column(
                children: [
                  SizedBox(height: pad, width: pad,),
                  const ImageFrame(
                      description: "description"
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ImageFrame extends StatefulWidget {
  final String description;
  final Function(String text)? onChanged;

  const ImageFrame({
    super.key,
    required this.description,
    this.onChanged,
  });

  @override
  ImageFrameState createState() => ImageFrameState();
}

class ImageFrameState extends State<ImageFrame> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'Enter description...',
                  fillColor: Colors.white54,
                ),
                onChanged: widget.onChanged,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // Action à effectuer lorsque l'icône de téléchargement est cliquée
              },
            ),
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () {
                // Action à effectuer lorsque l'icône de téléversement est cliquée
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Action à effectuer lorsque l'icône de flèche vers la gauche est cliquée
              },
            ),
            IconButton(
              icon: const Icon(Icons.loop),
              onPressed: () {
                // Action à effectuer lorsque l'icône de flèche circulaire est cliquée
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                // Action à effectuer lorsque l'icône de flèche vers la droite est cliquée
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


