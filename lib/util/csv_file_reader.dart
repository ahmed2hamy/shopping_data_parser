import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart';
import 'package:shopping_data_parser/model/result_model.dart';

class CSVFileReader {
  Future<List<ResultModel>> generateFiles(String path) async {
    List<ResultModel> results = [];
    Map<String, String> productQtyMap = HashMap();
    Map<String, String> popularBrandMap;
    Map<String, Map<String, int>> productBrandMap = HashMap();
    String inputFileName = basename(path);
    String qtyFileName = "0_$inputFileName";
    String brandFileName = "1_$inputFileName";
    int totalOrderLines =
        await _readOrderLines(path, productQtyMap, productBrandMap);
    _calculateAverageProductQty(productQtyMap, totalOrderLines);
    popularBrandMap = _findPopularBrand(productBrandMap);
    ResultModel qtyResult = _writeFile(productQtyMap, path, qtyFileName);
    ResultModel brandResult = _writeFile(popularBrandMap, path, brandFileName);
    results.addAll([qtyResult, brandResult]);
    return results;
  }

  Future<int> _readOrderLines(String path, Map<String, String> productQtyMap,
      Map<String, Map<String, int>> productBrandMap) async {
    int totalOrderLines = 0;
    try {
      File file = File(path);

      await file.readAsLines().asStream().forEach((orderLines) {
        for (String orderLine in orderLines) {
          totalOrderLines = orderLines.length;
          List<String> orderLineDetails =
              orderLine.replaceAll(RegExp("\""), "").split(",");
          String productName = orderLineDetails[2];
          String brandName = orderLineDetails[4];
          double orderQty = double.parse(orderLineDetails[3]);
          _createProductQtyMap(productQtyMap, productName, orderQty);
          _createProductBrandMap(productBrandMap, productName, brandName);
        }
      });
      return totalOrderLines;
    } catch (e) {
      log("_readOrderLinesError: $e");
      rethrow;
    }
  }

  void _createProductQtyMap(
      Map<String, String> productQtyMap, String productName, double orderQty) {
    if (productQtyMap.containsKey(productName)) {
      double qty = double.parse(productQtyMap[productName]!);
      orderQty = qty + orderQty;
    }
    productQtyMap[productName] = orderQty.toString();
  }

  void _createProductBrandMap(Map<String, Map<String, int>> productBrandMap,
      String productName, String brandName) {
    Map<String, int>? brandQtyMap = HashMap();
    int qty = 1;
    if (productBrandMap.containsKey(productName)) {
      brandQtyMap = productBrandMap[productName];
      if (brandQtyMap?.containsKey(brandName) ?? false) {
        qty = brandQtyMap![brandName] ?? -1;
        qty++;
      }
    }
    brandQtyMap![brandName] = qty;
    productBrandMap[productName] = brandQtyMap;
  }

  void _calculateAverageProductQty(
      Map<String, String> productQtyMap, int totalOrderLines) {
    for (MapEntry<String, String> entry in productQtyMap.entries) {
      productQtyMap[entry.key] =
          (double.parse(entry.value) / totalOrderLines).toString();
    }
  }

  Map<String, String> _findPopularBrand(
      Map<String, Map<String, int>> productBrandMap) {
    Map<String, String> popularBrandMap = HashMap();

    for (MapEntry<String, Map<String, int>> entry in productBrandMap.entries) {
      int maxValue = entry.value.values.reduce(math.max);
      String maxValueKey =
          entry.value.keys.firstWhere((e) => entry.value[e] == maxValue);

      popularBrandMap[entry.key] = maxValueKey;
    }

    return popularBrandMap;
  }

  ResultModel _writeFile(
      Map<String, String> inputMap, String path, String fileName) {
    List<String> lines = [];

    String filePath = "${dirname(path)}/$fileName";

    File file = File(filePath);
    log(filePath);
    try {
      String fileEntry = '';
      for (MapEntry<String, String> entry in inputMap.entries) {
        fileEntry += "${entry.key}, ${entry.value}\n";
        log(fileEntry);
        lines.add(fileEntry);
      }
      file.writeAsString(fileEntry);

      ResultModel resultModel = ResultModel(fileName: fileName, lines: lines);
      return resultModel;
    } catch (e) {
      rethrow;
    }
  }
}
