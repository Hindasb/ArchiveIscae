import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GestionEtudiantsPage extends StatefulWidget {
  @override
  _GestionEtudiantsPageState createState() => _GestionEtudiantsPageState();
}

class _GestionEtudiantsPageState extends State<GestionEtudiantsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Contrôleurs pour les champs de formulaire
  TextEditingController _nomController = TextEditingController();
  TextEditingController _matriculeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late List<DocumentSnapshot> etudiants;

  @override
  void initState() {
    super.initState();
    _fetchEtudiants();
  }

  void _fetchEtudiants() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('etudiants').get();
    setState(() {
      etudiants = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des étudiants'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddEtudiantDialog(context);
              },
              child: Text('Ajouter étudiant'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Liste des étudiants ajoutés:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            _buildEtudiantsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEtudiantsList() {
    if (etudiants.isEmpty) {
      return Text('Aucun étudiant ajouté');
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: etudiants.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text(etudiants[index]['nom']),
              subtitle: Text(etudiants[index]['matricule']),
              onTap: () {
                _showEditEtudiantDialog(context, etudiants[index]);
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteEtudiant(etudiants[index].id);
                },
              ),
            ),
          );
        },
      );
    }
  }

  void _showAddEtudiantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter étudiant'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextFormField(
                  controller: _matriculeController,
                  decoration: InputDecoration(labelText: 'Matricule'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _registerEtudiant();
                Navigator.pop(context);
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEtudiantDialog(
      BuildContext context, DocumentSnapshot etudiant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier étudiant'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller:
                      TextEditingController(text: etudiant['nom']),
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextFormField(
                  controller: TextEditingController(
                      text: etudiant['matricule']),
                  decoration: InputDecoration(labelText: 'Matricule'),
                ),
                TextFormField(
                  controller:
                      TextEditingController(text: etudiant['email']),
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Mettre à jour les informations de l'étudiant dans Firestore
                // ici, vous pouvez implémenter la mise à jour des données
                Navigator.pop(context);
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _registerEtudiant() async {
    // Récupération des valeurs des champs de formulaire
    String nom = _nomController.text.trim();
    String matricule = _matriculeController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Vérification que l'utilisateur est enregistré avant d'ajouter les détails dans Firestore
      if (userCredential.user != null) {
        // Ajout de l'étudiant dans la collection "etudiants" dans Firestore
        await _firestore.collection('etudiants').doc(userCredential.user!.uid).set({
          'nom': nom,
          'matricule': matricule,
          'email': email,
        });

        // Ajouter l'utilisateur à la collection "users" avec le rôle "etudiant"
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'rool': 'Etudiant',
        });

        // Réinitialisation des champs après l'ajout
        _nomController.clear();
        _matriculeController.clear();
        _emailController.clear();
        _passwordController.clear();

        // Mettre à jour la liste des étudiants
        _fetchEtudiants();

        // Affichage d'un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Étudiant ajouté avec succès'),
          ),
        );
      }
    } catch (e) {
      print('Erreur lors de l\'inscription de l\'étudiant: $e');
      // Affichage d'un message d'erreur s'il y a un problème lors de l'inscription
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'inscription de l\'étudiant: $e'),
        ),
      );
    }
  }

  void _deleteEtudiant(String id) {
    _firestore.collection('etudiants').doc(id).delete().then((_) {
      _fetchEtudiants();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Étudiant supprimé avec succès'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression de l\'étudiant: $error'),
        ),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: GestionEtudiantsPage(),
  ));
}
