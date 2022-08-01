import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shopping_data_parser/constants/constants.dart';
import 'package:shopping_data_parser/data_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _pickCSVFile,
          child: const Text(kPickCSVFileString),
        ),
      ),
    );
  }

  void _pickCSVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["csv"],
      allowMultiple: false,
      dialogTitle: kPickCSVFileString,
    );

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.first.path;
      if (filePath != null) {
        File file = File(filePath);

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DataScreen(kCSVFile: file),
          ),
        );
      }
    }
  }
}
