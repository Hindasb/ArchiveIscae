import 'package:flutter/material.dart';
import './documents_page.dart'; // Importer la page des documents

class SemesterPage extends StatelessWidget {
  final bool isMaster;
  final String level;
  final String branch;
  final String semester;

  const SemesterPage({
    Key? key,
    required this.isMaster,
    required this.level,
    required this.branch,
    required this.semester,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> l1Semesters = ['S1', 'S2'];
    List<String> l2Semesters = ['S3', 'S4'];
    List<String> l3Semesters = ['S5', 'S6'];
    List<String> m1Semesters = ['S1', 'S2'];
    List<String> m2Semesters = ['S3', 'S4'];

    List<String> semesters = [];
    if (level.startsWith('L')) {
      if (level == 'L1') {
        semesters = l1Semesters;
      } else if (level == 'L2') {
        semesters = l2Semesters;
      } else if (level == 'L3') {
        semesters = l3Semesters;
      }
    } else if (level.startsWith('M')) {
      if (level == 'M1') {
        semesters = m1Semesters;
      } else if (level == 'M2') {
        semesters = m2Semesters;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Semestres - $semester'),
        backgroundColor: Colors.purple, // Couleur de l'appBar
      ),
      body: Center(
        child: ListView.builder(
          itemCount: semesters.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentTypePage(
                        isMaster: isMaster,
                        level: level,
                        branch: branch,
                        onPrimary: Colors.black, // Couleur du texte
                        elevation: 3, // Élévation du bouton
                        semester: semesters[index],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Couleur du bouton
                  padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20), // Ajuster le rembourrage du bouton
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10)), // Forme du bouton
                ),
                child: Text(
                  semesters[index],
                  style: TextStyle(
                    fontSize: 24.0, // Taille du texte
                    fontWeight: FontWeight.bold, // Poids de la police
                    color: Colors.white, // Couleur du texte
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
