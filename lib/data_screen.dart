import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopping_data_parser/constants/constants.dart';
import 'package:shopping_data_parser/model/result_model.dart';
import 'package:shopping_data_parser/util/csv_file_reader.dart';

class DataScreen extends StatefulWidget {
  final File kCSVFile;

  const DataScreen({
    Key? key,
    required this.kCSVFile,
  }) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<ResultModel> results = [];

  @override
  void initState() {
    super.initState();

    CSVFileReader().generateFiles(widget.kCSVFile.path).then((value) {
      results = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kResultString),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: results
              .map(
                (r) => Column(
                  children: r.lines.map((l) => Text(l)).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
