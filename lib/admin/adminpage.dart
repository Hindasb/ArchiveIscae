import 'package:flutter/material.dart';
import './gestion_etudiants_page.dart'; // Importer la page de gestion des étudiants
import '../pages/home_page.dart'; // Importer la page d'accueil

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Page Admin'),
      ),
      backgroundColor: Colors.white, // Couleur d'arrière-plan
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page de gestion des étudiants
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GestionEtudiantsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple, // Couleur du texte du bouton
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0), // Espacement interne du bouton
                ),
                child: Text(
                  'Gérer les étudiants',
                  style: TextStyle(fontSize: 20), // Taille du texte
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page d'accueil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple, // Couleur du texte du bouton
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0), // Espacement interne du bouton
                ),
                child: Text(
                  'Accéder aux documents',
                  style: TextStyle(fontSize: 20), // Taille du texte
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
