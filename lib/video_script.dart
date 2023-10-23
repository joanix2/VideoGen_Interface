import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_gen_app/project.dart';
import 'package:video_gen_app/utilities.dart';

import 'api.dart';
import 'config.dart';


class ClipListFrame extends StatefulWidget {
  final String token;
  final int id;
  final String title;
  final Widget? Function(Clip clip)? onCreateClipWidget;
  final Axis direction;
  final bool border;

  const ClipListFrame({super.key,
    required this.token,
    required this.id,
    required this.title,
    this.onCreateClipWidget,
    this.direction = Axis.horizontal,
    this.border = false,
  });

  @override
  ClipListFrameState createState() => ClipListFrameState();
}

class ClipListFrameState extends State<ClipListFrame> {
  late Future<List<Clip>> _clipsFuture;
  late List<Clip> clips;

  @override
  void initState() {
    super.initState();
    // Initialisez la future liste de clips ici
    _clipsFuture = getProjectClips(token: widget.token, id: widget.id);
  }

  void alert(String error){
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text('Une erreur s\'est produite lors de l\'ajout du clip : $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      }, context: context,
    );
  }

  Future<void> deleteAllClips(int projectId) async {
    try {
      // Mettez en œuvre la logique pour ajouter un nouveau clip ici
      await sendDeleteRequest(view: 'project/clips/$projectId', token: widget.token);

      // Rafraîchissez la liste des clips après avoir ajouté le nouveau clip
      setState(() {
        _clipsFuture = getProjectClips(token: widget.token, id: widget.id);
      });
    } catch (error) {
      alert(error.toString());
    }
  }

  Future<bool> updateAllClipsIndex({required int newIndex, required int step}) async{
    // Mettez à jour l'index de tous les clips ayant un index supérieur ou égal
    http.Response? response = await sendPostRequest(
      view: 'project/clips/update_index',
      token: widget.token,
      body: {
        'project_id' : widget.id,
        'new_index' : newIndex,
        'step' : step
      },
    );
    if (response?.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<void> newClip(int index) async {
    try {
      // Mettez en œuvre la logique pour ajouter un nouveau clip ici
      await sendPostRequest(view: 'project/clips/${widget.id}', body: {"index":index}, token: widget.token);

      // Rafraîchissez la liste des clips après avoir ajouté le nouveau clip
      setState(() {
        _clipsFuture = getProjectClips(token: widget.token, id: widget.id);
      });
    } catch (error) {
      alert(error.toString());
    }
  }

  Future<void> addClip(int index) async {
    if (await updateAllClipsIndex(newIndex: index, step: 1)){
      newClip(index);
    }
  }

  Future<void> deleteClip(int id) async {
    try {
      // Mettez en œuvre la logique pour ajouter un nouveau clip ici
      await sendDeleteRequest(view: 'clip/$id', token: widget.token);

      // Rafraîchissez la liste des clips après avoir ajouté le nouveau clip
      setState(() {
        _clipsFuture = getProjectClips(token: widget.token, id: widget.id);
      });
    } catch (error) {
      alert(error.toString());
    }
  }

  Future<void> removeClip(Clip clip) async {
    if (await updateAllClipsIndex(newIndex: clip.index, step: -1)){
      deleteClip(clip.id);
    }
  }

  Future<void> switchClip({required Clip clip1, required Clip clip2}) async {
    await sendPostRequest(
      view: 'project/clips/switch/${clip1.id}/${clip2.id}',
      token: widget.token,
      body: {},
    );
  }

  Future<void> moveClip(Clip clip, int delta) async {
    int newIndex = clip.index+delta;
    if (newIndex >= 0 && newIndex < clips.length){
      Clip clip2 = clips[newIndex];
      await switchClip(clip1: clip, clip2: clip2);
      setState(() {
        _clipsFuture = getProjectClips(token: widget.token, id: widget.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: pad),
        Text(widget.title, style: title1,),
        SizedBox(height: pad),
        FutureBuilder<List<Clip>>(
          future: _clipsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Affichez un indicateur de chargement pendant le chargement des clips.
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              // Affichez la liste des clips
              clips = snapshot.data!;
              //clips.sort((a, b) => a.index.compareTo(b.index));
              int clipsLen = clips.length;

              return Column(
                children: [
                  ButtonRow(
                    onGeneratePressed: () {
                      // Mettez en œuvre la logique pour "Générer" ici
                      /*
                        sendPostRequest(
                          view: view,
                          token: token,
                          body: {
                            "prompt" : "donne moi un titre de video youtube",
                            "max_tokens" : 20
                          });*/
                    },
                    onDeletePressed: () {
                      //_copyToClipboard(widget.defaultText, context); // Copiez le texte par défaut
                      deleteAllClips(widget.id);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: clips.map((clip) => ClipWidget(
                      clip: clip,
                      token: widget.token,
                      direction: widget.direction,
                      border : widget.border,
                      onAddPressed: (){
                        addClip(clip.index);
                      },
                      onDeletePressed: (){
                        removeClip(clip);
                      },
                      onMoveUpPressed: () {
                        moveClip(clip, -1);
                      },
                      onMoveDownPressed: () {
                        moveClip(clip, 1);
                      },
                      child: widget.onCreateClipWidget?.call(clip),
                    )).toList(),
                  ),
                  SizedBox(height: pad),
                  Row(
                    children: [
                      SizedBox(width: pad*5,),
                      Expanded(
                        child: AddButton(
                          onAddPressed: () async {
                            addClip(clipsLen);
                          },
                        ),
                      ),
                      SizedBox(width: pad*5,),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}


class ClipWidget extends StatefulWidget {
  final Clip clip;
  final String token;
  final VoidCallback? onAddPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback onMoveUpPressed;
  final VoidCallback onMoveDownPressed;
  final Axis direction;
  final bool border;
  final Widget? child;

  const ClipWidget({super.key, required this.clip, this.onAddPressed, this.onDeletePressed, required this.token, required this.onMoveUpPressed, required this.onMoveDownPressed, this.child, this.direction = Axis.horizontal, this.border = false});

  @override
  ClipWidgetState createState() => ClipWidgetState();
}

class ClipWidgetState extends State<ClipWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: const Utf8Codec().decode(widget.clip.text.codeUnits));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: pad),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: pad*4,
              child: Text(
                widget.clip.index.toString(),
                style: title2,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                margin: widget.border ? EdgeInsets.all(pad) : EdgeInsets.symmetric(horizontal: pad),
                padding: widget.border ? EdgeInsets.all(pad) : null,
                decoration: widget.border ? BoxDecoration(
                  borderRadius: BorderRadius.circular(pad),
                  border: Border.all(color: Colors.black),
                ) : null,
                child : Column(
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
                              hintText: 'Enter text...',
                              fillColor: Colors.white54,
                            ),
                            onChanged: (text){
                              sendPutRequest(
                                  view: 'clip/${widget.clip.id}',
                                  token: widget.token,
                                  requestBody: {
                                    "new_text" : text
                                  }
                              );
                            },
                          ),
                        ),
                        if (widget.child != null && widget.direction == Axis.horizontal) widget.child!, // Affiche clipWidget uniquement s'il n'est pas null
                      ],
                    ),
                    if (widget.child != null && widget.direction == Axis.vertical) widget.child!, // Affiche clipWidget uniquement s'il n'est pas null
                  ],
                ),
              ),
            ),
            SizedBox(
              width: pad*4,
              child: ClipPopupMenuButton(
                onAddClipPressed: () {
                  if (widget.onAddPressed != null) {
                    widget.onAddPressed!();
                  }
                },
                onMoveUpPressed: () {
                  widget.onMoveUpPressed();
                },
                onMoveDownPressed: () {
                  widget.onMoveDownPressed();
                },
                onDeletePressed: () {
                  if (widget.onDeletePressed != null) {
                    widget.onDeletePressed!();
                  }
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ClipPopupMenuButton extends StatefulWidget {
  final VoidCallback onAddClipPressed;
  final VoidCallback onMoveUpPressed;
  final VoidCallback onMoveDownPressed;
  final VoidCallback onDeletePressed;

  const ClipPopupMenuButton({
    Key? key,
    required this.onAddClipPressed,
    required this.onMoveUpPressed,
    required this.onMoveDownPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  ClipPopupMenuButtonState createState() => ClipPopupMenuButtonState();
}

class ClipPopupMenuButtonState extends State<ClipPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'add_clip',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Add clip'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'move_up',
          child: ListTile(
            leading: Icon(Icons.arrow_upward),
            title: Text('Move up'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'move_down',
          child: ListTile(
            leading: Icon(Icons.arrow_downward),
            title: Text('Move down'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
      onSelected: (String choice) {
        // Gérez ici les actions pour chaque option du menu en utilisant les callbacks
        switch (choice) {
          case 'add_clip':
            widget.onAddClipPressed();
            break;
          case 'move_up':
            widget.onMoveUpPressed();
            break;
          case 'move_down':
            widget.onMoveDownPressed();
            break;
          case 'delete':
            widget.onDeletePressed();
            break;
        }
      },
    );
  }
}