import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedNiveau;
  String? _selectedFiliere;
  String? _selectedSemestre;

  FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currentUser;

  List<String> niveaux = [];
  List<String> filieres = [];
  List<String> semestres = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    fetchNiveaux();
    fetchFilieres();
    fetchSemestres();
  }

  Future<void> fetchNiveaux() async {
    var niveauSnapshot = await FirebaseFirestore.instance.collection('niveaux').get();
    setState(() {
      niveaux = niveauSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> fetchFilieres() async {
    var filiereSnapshot = await FirebaseFirestore.instance.collection('filieres').get();
    setState(() {
      filieres = filiereSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> fetchSemestres() async {
    var semestreSnapshot = await FirebaseFirestore.instance.collection('semestres').get();
    setState(() {
      semestres = semestreSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> _addStudent() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        _selectedNiveau != null &&
        _selectedFiliere != null &&
        _selectedSemestre != null) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Enregistrer les détails de l'étudiant dans Firestore
        FirebaseFirestore.instance.collection('students').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'niveau': _selectedNiveau,
          'filiere': _selectedFiliere,
          'semestre': _selectedSemestre,
        });

        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _selectedNiveau = null;
        _selectedFiliere = null;
        _selectedSemestre = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nouvel étudiant ajouté avec succès')),
        );
      } catch (e) {
        print('Erreur lors de l\'ajout de l\'étudiant: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de l\'étudiant')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des étudiants'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('documents')
            .where('niveau', isEqualTo: _selectedNiveau)
            .where('filiere', isEqualTo: _selectedFiliere)
            .where('semestre', isEqualTo: _selectedSemestre)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var documentData = documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(documentData['title']),
                subtitle: Text('Description: ${documentData['description']}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Ajouter un nouvel étudiant'),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Nom'),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Mot de passe'),
                        obscureText: true,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedNiveau,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedNiveau = value;
                          });
                        },
                        items: niveaux.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Niveau'),
                      ),
                      if (_selectedNiveau != null)
                        DropdownButtonFormField<String>(
                          value: _selectedFiliere,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedFiliere = value;
                            });
                          },
                          items: filieres.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(labelText: 'Filière'),
                        ),
                      DropdownButtonFormField<String>(
                        value: _selectedSemestre,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedSemestre = value;
                          });
                        },
                        items: semestres.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Semestre'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addStudent();
                      Navigator.of(context).pop();
                    },
                    child: Text('Ajouter'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
