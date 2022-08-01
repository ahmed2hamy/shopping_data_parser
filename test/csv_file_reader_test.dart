import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_data_parser/util/csv_file_reader.dart';

void main() {
  test(
    'should parse the CSV file and write it to the output files',
    () async {
      //arrange

      File qtyFile = File("test/fixtures/0_The order_log00.csv");
      File brandFile = File("test/fixtures/1_The order_log00.csv");

      //act
      await CSVFileReader().generateFiles('test/fixtures/The order_log00.csv');

      //assert
      await qtyFile.readAsLines().asStream().forEach((orderLines) {
        expect(orderLines[0], "Intelligent Copper Knife, 2.4");
        expect(orderLines[1], "Small Granite Shoes, 0.8");
      });

      await brandFile.readAsLines().asStream().forEach((orderLines) {
        expect(orderLines[0], "Intelligent Copper Knife, Hilll-Gorczany");
        expect(orderLines[1], "Small Granite Shoes, Rowe and Legros");
      });
    },
  );
}
