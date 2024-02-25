import 'package:flutter/material.dart';
import './filieres_page.dart'; // Importer la page suivante

class LevelPage extends StatelessWidget {
  final bool isMaster;
  final String level;
  final String semester;

  const LevelPage(
      {Key? key,
      required this.isMaster,
      required this.level,
      required this.semester})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> levels = isMaster ? ['M1', 'M2'] : ['L1', 'L2', 'L3'];

    return Scaffold(
      appBar: AppBar(
        title: Text(isMaster ? 'Niveaux Master' : 'Niveaux Licence'),
        backgroundColor: Colors.purple, // Couleur de l'appBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (String currentLevel in levels)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchPage(
                              isMaster: isMaster,
                              semester: semester,
                              level: currentLevel,
                              branch:
                                  'dummy', // Vous devez passer une branche réelle ici
                            ),
                          ),
                        );
                      },
                      child: Text(
                        currentLevel,
                        style: TextStyle(
                          fontSize: 24, // Taille de la police
                          color: Colors.white, // Couleur du texte
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple, // Couleur du bouton
                        padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20), // Ajuster le rembourrage du bouton
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10)), // Forme du bouton
                      ),
                    ),
                    SizedBox(height: 20), // Espacement entre les boutons
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
