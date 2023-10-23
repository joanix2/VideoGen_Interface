import 'package:flutter/material.dart';
import 'utilities.dart';
import 'config.dart';

class UploadFrame extends StatefulWidget {
  final String token;
  final int id;

  const UploadFrame({super.key, required this.token, required this.id});

  @override
  UploadFrameState createState() => UploadFrameState();
}

class UploadFrameState extends State<UploadFrame> {
  DateTime selectedDate = DateTime.now();
  Map<String, int> category = {
    "Film et animation": 1,
    "Automobiles et véhicules": 2,
    "Musique": 10,
    "Animaux": 15,
    "Sports": 17,
    "Voyage et événements": 19,
    "Gaming": 20,
    "People et blogs": 22,
    "Comédie": 23,
    "Divertissement": 24,
    "Actualités et politique": 25,
    "Howto et style": 26,
    "Éducation": 27,
    "Science et technologie": 28,
    "Non lucratif et activisme": 29,
    "Films": 30,
    "Animation": 31,
    "Action et aventure": 32,
    "Classiques": 33,
    "Comédie": 34,
    "Documentaire": 35,
    "Drame": 36,
    "Famille": 37,
    "Étranger": 38,
    "Horreur": 39,
    "Science-fiction et fantastique": 40,
    "Courts métrages": 41,
    "Thriller": 42,
    "Shorts": 43,
    "Spectacles": 44,
    "Bandes-annonces": 45,
  };

  Map<String, int> status = {
    "Publique" : 0,
    "Privée" : 1,
    "Non répertoriée" : 2
  };

  List<String> uploadString = [
    "Upload sur Youtube",
    "Upload sur Tiktok",
    "Upload sur Instagram",
    "Upload sur Linkedin"
  ];
  late int selectedCategory;
  late int selectedStatus;
  late List<bool> socialNetworkUpload;

  @override
  void initState() {
    super.initState();
    selectedCategory = category.values.first;
    selectedStatus = status.values.first;
    socialNetworkUpload = List.generate(uploadString.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Programmer la date de publication
        HideFrame(
          checkboxText: " Programmer la date de publication",
          child: DateTimePickerCombined(
            onDateSelected: (DateTime value) {
              setState(() {
                selectedDate = DateTime(
                  value.year,
                  value.month,
                  value.day,
                  selectedDate.hour,
                  selectedDate.minute,
                );
                //print(selectedDate);
              });
            },
            onTimeSelected: (TimeOfDay value) {
              setState(() {
                selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  value.hour,
                  value.minute,
                );
                //print(selectedDate);
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: pad*2, right: pad*2),
          child: Column(
            children: [
              CustomDropdownMenu(
                labelText: 'Choix du statut',
                items: status.keys.toList(),
                onChanged: (value){
                  selectedCategory = status[value]!;
                },
              ),
              CustomDropdownMenu(
                labelText: 'Choix de la category',
                items: category.keys.toList(),
                onChanged: (value){
                  selectedCategory = category[value]!;
                },
              ),
              // Tags (liste de string)
              //const TagManagerWidget()
              // miniature (chemain d'image)
              // for kids (bool)
              // notif (bool)
            ],
          ),
        ),
        SizedBox(height: pad),
        Text("Choix des réseaux sur lesquels téléverser la vidéo.", style: title1,),
        SizedBox(height: pad),
        SizedBox(
          width: 500,
          child: CheckboxList(
            items: uploadString,
            onChecked: (List<bool> values) {
              // Faites quelque chose avec les valeurs mises à jour
              socialNetworkUpload = values;
            },
          ),
        ),
        SizedBox(height: pad),
        // Bouton pour uploader la vidéo sur YouTube
        ElevatedButton(
          onPressed: () {
            // Mettez en œuvre la logique pour uploader la vidéo sur YouTube ici
          },
          child: const Text("Téléverser la vidéo"),
        ),
      ],
    );
  }
}


class DateTimePickerCombined extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const DateTimePickerCombined({super.key, required this.onDateSelected, required this.onTimeSelected});

  @override
  DateTimePickerCombinedState createState() => DateTimePickerCombinedState();
}

class DateTimePickerCombinedState extends State<DateTimePickerCombined> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = (await showTimePicker(
      context: context,
      initialTime: selectedTime,
    ));
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        widget.onTimeSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: pad),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                  selectedDate.toLocal().toString().split(' ')[0],
                  style: title1
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Changer la date'),
              ),
            ],
          ),
          SizedBox(width: pad,),
          Column(
            children: [
              Text(
                  selectedTime.format(context),
                  style: title1
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: const Text('Changer l\'heure'),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class CheckboxList extends StatefulWidget {
  final List<String> items;
  final ValueChanged<List<bool>> onChecked;

  const CheckboxList({super.key, required this.items, required this.onChecked});


  @override
  CheckboxListState createState() => CheckboxListState();
}

class CheckboxListState extends State<CheckboxList> {
  late List<bool> isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = List.generate(widget.items.length, (index) => false);
  }

  void _handleCheckboxChanged(int index, bool value) {
    setState(() {
      isChecked[index] = value;
      widget.onChecked(isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.items.length, (index) {
        return CheckboxListTile(
          title: Text(widget.items[index], style: title2,),
          value: isChecked[index],
          onChanged: (value) {
            _handleCheckboxChanged(index, value ?? false);
          },
        );
      }),
    );
  }
}

class TagManagerWidget extends StatefulWidget {
  const TagManagerWidget({super.key});

  @override
  TagManagerWidgetState createState() => TagManagerWidgetState();
}

class TagManagerWidgetState extends State<TagManagerWidget> {
  List<String> tags = [];
  TextEditingController tagController = TextEditingController();

  void addTag() {
    String nouveauTag = tagController.text.trim();
    if (nouveauTag.isNotEmpty && !tags.contains(nouveauTag)) {
      setState(() {
        tags.add(nouveauTag);
      });
      tagController.clear();
    }
  }

  void delTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: tagController,
          decoration: const InputDecoration(labelText: 'Nouveau Tag'),
        ),
        ElevatedButton(
          onPressed: addTag,
          child: const Text('Ajouter un Tag'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return ListTile(
                title: Text(tag),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => delTag(tag),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


