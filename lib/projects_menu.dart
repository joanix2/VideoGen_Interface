import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'utilities.dart';
import 'config.dart';
import 'main_app.dart';
import 'package:http/http.dart' as http;
import 'project.dart';
import 'drawer.dart';

class ProjectPage extends StatefulWidget {
  final String token;
  const ProjectPage({super.key, required this.token});

  @override
  ProjectPageState createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {
  TextEditingController controller = TextEditingController();
  List<Project> projects = [];
  Future<void>? _fetchProjectsFuture;


  @override
  void initState() {
    super.initState();
    _fetchProjectsFuture = fetchProjects();
  }

  // Fonction pour récupérer les projets depuis le serveur
  Future<void> fetchProjects() async {
    final response = await tokenGet(view: '/projects', token: widget.token);
    final dynamic jsonData = json.decode(response.body);
    setState(() {
      projects = jsonData.map<Project>((data) => Project.fromJson(data)).toList();
    });
    if (kDebugMode) {
      print(response.body);
      print(projects);
    }
  }

  bool isProjectNameExists(String name) {
    return projects.any((project) => project.name == name);
  }

  void alert(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('The project name already exists.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void newProject({ValueChanged<http.Response>? onReceive}) async {
    final name = await openDialog(
      context: context,
      titleText: 'Add new project',
      fieldText: 'Enter new project name',
      buttonText: 'Submit',
      controller: controller,
    );

    if (name == null || name.isEmpty) return;

    if (isProjectNameExists(name)) {
      return;
    }

    Map<String, dynamic> requestBody = {
      'name': name,
    };
    http.Response? response = await sendPostRequest(view: 'projects', body: requestBody, token: widget.token);
    onReceive!(response!);
  }
  
  Future<void> delProject(int id) async {
    http.Response? response = await sendDeleteRequest(view: 'project/$id', token: widget.token);
    if (response?.statusCode == 204) {
      setState(() {
        projects.removeWhere((project) => project.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text('Projects'),
      ),
      drawer: CustomDrawer(token: widget.token,),
      body: FutureBuilder(
        future: _fetchProjectsFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Afficher la barre de chargement pendant le chargement
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Gérer les erreurs ici
            if (kDebugMode) {
              print(snapshot.error.toString());
              return Center(
                child: Text('Error: ${snapshot.error.toString()}'),
              );
            }
            return const Text('Error');
          } else {
            // Afficher la liste des projets lorsque le chargement est terminé
            return Padding(
              padding: EdgeInsets.all(pad),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: calculateColumnCount(context), // Nombre de colonnes en fonction de la largeur de l'écran
                  crossAxisSpacing: pad,
                  mainAxisSpacing: pad,
                ),
                itemCount: projects.length + 1, // Ajouter 1 pour le conteneur "Ajouter un projet"
                itemBuilder: (BuildContext context, int index) {
                  if (index == projects.length) {
                    // Dernier index, afficher le conteneur "Ajouter un projet"
                    return GestureDetector(
                      onTap: (){
                        newProject(
                            onReceive: (response) {
                              if (response.statusCode == 201) {
                                fetchProjects();
                              }
                            }
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(pad),
                        decoration: BoxDecoration(
                          color: whiteWithOpacity50,
                          borderRadius: BorderRadius.circular(pad),
                        ),
                        child: const Icon(Icons.add_rounded, size: 100, color: color2), // Icône de bouton "plus"
                      ),
                    );
                  } else {
                    // Index précédents, afficher les containers de projet normaux
                    Project project = projects[index];
                    return ProjectFrame(project: project, page: this, token: widget.token,);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  int calculateColumnCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columnCount = (screenWidth / 300).floor(); // Ajustez la valeur 200 selon la taille souhaitée pour chaque container
    return columnCount > 0 ? columnCount : 1;
  }
}

class ProjectFrame extends StatelessWidget {
  final String token;
  final ProjectPageState page;
  final Project project;

  const ProjectFrame({super.key, required this.page,required this.project, required this.token});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainFrame(token: token, projectName: project.name, id: project.id,)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: whiteWithOpacity50,
          borderRadius: BorderRadius.circular(pad),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left : pad, top: pad/2, bottom: pad/2, right: pad/2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color2,
                borderRadius: BorderRadius.all(Radius.circular(pad)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(project.name, style: TextStyle(fontSize: title2?.fontSize, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed:  () async {
                      final confirmed = await showConfirmationDialog(
                        context: context,
                        name: project.name,
                      );
                      if (confirmed == null) return;
                      if (confirmed) {
                        page.delProject(project.id);
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: pad),
            ...(project.title != "" ? [Text('Title: ${project.title}', style: title2)] : []),
            SizedBox(height: pad),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(pad), // Ajustez le rayon selon vos préférences
                color: project.sent ? color2 : color1, // Couleur verte si sent est true, sinon rouge
              ),
              child: Padding(
                padding: EdgeInsets.all(pad), // Ajustez les marges intérieures selon vos préférences
                child: Text(
                  project.sent ? 'Sent' : 'Not Sent', // Texte en fonction de la valeur de sent
                  style: TextStyle(
                    color: Colors.white, // Texte en blanc
                    fontSize: title2?.fontSize, // Ajustez la taille de police selon vos préférences
                  ),
                ),
              ),
            ),
            SizedBox(height: pad),
            // Convert the Set<Text> to a List<Widget> using toList()
            //...(project.channel != null ? [Text('Channel: ${project.channel}', style: title2)] : []),
          ],
        ),
      ),
    );
  }
}
