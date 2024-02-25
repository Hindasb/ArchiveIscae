import 'package:flutter/material.dart';
import './documentpage.dart'; // Importer la page des documents

class DocumentTypePage extends StatelessWidget {
  final bool isMaster;
  final String level;
  final String branch;
  final String semester;

  const DocumentTypePage({
    Key? key,
    required this.isMaster,
    required this.level,
    required this.branch,
    required this.semester,
    required Color onPrimary,
    required int elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Liste des types de documents
    List<String> documentTypes = [
      'COURS',
      'TP',
      'DEVOIRS',
      'EXAMENS'
    ]; // Mettre en majuscules

    return Scaffold(
      appBar: AppBar(
        title: Text('Documents - $semester'),
        backgroundColor: Colors.purple, // Couleur de l'appBar
      ),
      body: ListView.builder(
        itemCount: documentTypes.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () {
                // Naviguer vers la page des documents correspondante au type sélectionné
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentPage(
                      isMaster: isMaster,
                      level: level,
                      branch: branch,
                      semester: semester,
                      documentType:
                          documentTypes[index], // Utiliser la casse correcte
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  documentTypes[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
