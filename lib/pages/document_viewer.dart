import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class DocumentViewer extends StatelessWidget {
  final String documentContent;

  const DocumentViewer({
    Key? key,
    required this.documentContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Viewer'),
      ),
      body: Center(
        child: File(documentContent).path.toLowerCase().endsWith('.pdf')
            ? PDFView(
                filePath: documentContent,
                // add the option you need
              )
            : Image.file(
                File(documentContent),
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
