import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './document_viewer.dart';

class DocumentPage extends StatefulWidget {
  final bool isMaster;
  final String level;
  final String branch;
  final String semester;
  final String documentType;

  const DocumentPage({
    Key? key,
    required this.isMaster,
    required this.level,
    required this.branch,
    required this.semester,
    required this.documentType,
  }) : super(key: key);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  List<String> documents = [];

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('documents')
          .where('level', isEqualTo: widget.level)
          .where('branch', isEqualTo: widget.branch)
          .where('semester', isEqualTo: widget.semester)
          .get();

      List<String> fetchedDocuments = [];
      querySnapshot.docs.forEach((doc) {
        fetchedDocuments.add(doc['documentPath']);
      });

      setState(() {
        documents = fetchedDocuments;
      });

      print('Documents fetched successfully from Firestore.');
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  Future<void> selectDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        setState(() {
          documents.add(filePath);
          saveDocumentDetails(filePath);
        });
      }
    }
  }

  Future<void> saveDocumentDetails(String filePath) async {
    try {
      await FirebaseFirestore.instance.collection('documents').add({
        'level': widget.level,
        'branch': widget.branch,
        'semester': widget.semester,
        'documentPath': filePath,
      });
      print('Document details saved successfully in Firestore.');
    } catch (e) {
      print('Error saving document details: $e');
    }
  }

  Future<void> deleteDocumentDetails(int index) async {
    try {
      String docPath = documents[index];
      await FirebaseFirestore.instance
          .collection('documents')
          .where('documentPath', isEqualTo: docPath)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.first.reference.delete();
      });
      setState(() {
        documents.removeAt(index);
      });
      print('Document details successfully deleted from Firestore.');
    } catch (e) {
      print('Error deleting document details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.documentType} - ${widget.semester}'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 5,
                child: ListTile(
                  title: Text('Document ${index + 1}'),
                  subtitle: Text(documents[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.open_in_new),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DocumentViewer(
                                documentContent: documents[index],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await deleteDocumentDetails(index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectDocument();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
