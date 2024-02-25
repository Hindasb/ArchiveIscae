import 'package:flutter/material.dart';
import './niveaux_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ARCHIVE DE L ISCAE'),
        backgroundColor:
            Color.fromARGB(255, 141, 86, 179), // Couleur de l'appBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Choisissez les niveaux :',
                style: TextStyle(
                  fontSize: 24, // Taille de la police
                  color: Colors.black, // Couleur du texte
                ),
                textAlign: TextAlign.center, // Alignement du texte au centre
              ),
              SizedBox(
                  height: 20), // Ajoute une distance verticale de 20 pixels
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelPage(
                        isMaster: false,
                        level: '',
                        semester: '',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Licence',
                  style: TextStyle(
                    fontSize: 20, // Taille de la police
                    color: Colors.white, // Couleur du texte
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Couleur du bouton
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0), // Espacement interne du bouton
                ),
              ),
              SizedBox(
                  height: 20), // Ajoute une distance verticale de 20 pixels
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelPage(
                        isMaster: true,
                        level: '',
                        semester: '',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Master',
                  style: TextStyle(
                    fontSize: 20, // Taille de la police
                    color: Colors.white, // Couleur du texte
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Couleur du bouton
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0), // Espacement interne du bouton
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
