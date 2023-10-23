import 'package:flutter/material.dart';
import 'package:video_gen_app/music_gen.dart';
import 'text_gen.dart';
import 'voice_gen.dart';
import 'img_gen.dart';
import 'montage_gen.dart';
import 'upload.dart';
import 'projects_menu.dart';
import 'drawer.dart';

class MainFrame extends StatelessWidget {
  final String token;
  final String projectName;
  final int id;
  const MainFrame({super.key, required this.token, required this.projectName, required this.id});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // Nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text(projectName),
          actions: [
            IconButton(
              icon: const Icon(Icons.home), // Icône de la maison
              onPressed: () {
                // Gérer l'action lorsque le bouton est pressé
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectPage(token: token)),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              // Tab(text: 'Tendances'), // Onglet 1
              // Tab(text: 'SEO'), // Onglet 2
              Tab(text: 'Script'), // Onglet 3
              Tab(text: 'Voix'), // Onglet 4
              Tab(text: 'Musique'), // Onglet 5
              Tab(text: 'Images'), // Onglet 6
              Tab(text: 'Montage'), // Onglet 7
              Tab(text: 'Upload'), // Onglet 8
              // Tab(text: 'Ads'), // Onglet 9
              // Tab(text: 'Performances'), // Onglet 10
            ],
          ),
        ),
        drawer: CustomDrawer(token: token,),
        body: TabBarView(
          children: [
            // Contenu de l'onglet 1 - Tendances
            //const Center(child: Text('Tendances')),
            // Contenu de l'onglet 2 - SEO
            //const Center(child: Text('SEO')),
            // Contenu de l'onglet 3 - Script
            TextFrame(token: token, id: id,),
            // Contenu de l'onglet 4 - Voix
            VoiceFrame(token: token, id: id,),
            // Contenu de l'onglet 5 - Animation de visage
            MusicFrame(token: token, id: id,),
            // Contenu de l'onglet 6 - Images
            ImagesGenerationFrame(token: token, id: id,),
            // Contenu de l'onglet 7 - Montage
            MontageFrame(token: token, id: id,),
            // Contenu de l'onglet 8 - Upload
            UploadFrame(token: token, id: id,),
            // Contenu de l'onglet 9 - Animation de visage
            // const Center(child: Text('Ads')),
            // Contenu de l'onglet 10 - Animation de visage
            // const Center(child: Text('Performances')),
          ],
        ),
      ),
    );
  }
}
