import 'package:flutter/material.dart';
import './semestres_page.dart';

class BranchPage extends StatelessWidget {
  final bool isMaster;
  final String level;
  final String branch;
  final String semester;

  const BranchPage(
      {Key? key,
      required this.isMaster,
      required this.level,
      required this.branch,
      required this.semester})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> branches = isMaster
        ? (level == 'M1' || level == 'M2')
            ? ['IG', 'FC']
            : []
        : (level == 'L1' || level == 'L2' || level == 'L3')
            ? ['IG', 'RT', 'DI', 'FC', 'GRH']
            : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Filières - $level'),
        backgroundColor: Colors.purple, // Couleur de l'appBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (String currentBranch in branches)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SemesterPage(
                              isMaster: isMaster,
                              level: level,
                              semester: semester,
                              branch: currentBranch,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        currentBranch,
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
                    SizedBox(height: 20), // Espace vertical entre les boutons
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
