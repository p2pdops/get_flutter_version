import 'package:get_flutter_version/dv_parser.dart';

import 'dart:io';
import 'dart:convert';

import 'package:get_flutter_version/dv_searcher.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Please provide the path to libflutter.so');
    exit(1);
  }

  final filePath = arguments[0];
  final file = File(filePath);

  if (!await file.exists()) {
    print('File not found at: $filePath');
    exit(1);
  }

  try {
    // Read the binary file as a string for pattern matching
    final binaryContent = await file.readAsString(encoding: latin1);
    final dartVersion = extractDartVersion(binaryContent);

    print('Dart version: $dartVersion');

    var x = getDartCommitDetails(dartVersion);
  } catch (e) {
    print('An error occurred: $e');
    exit(1);
  }
}
