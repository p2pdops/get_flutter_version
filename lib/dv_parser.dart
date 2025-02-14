String extractDartVersion(String binaryContent) {
  // Regular expression to extract text between the specified pattern and NUL
  final extractionPattern = RegExp(r'xmlparse\.c:%d\) %\*s"\x00(.*?) on');

  // Search for the extracted data
  final match = extractionPattern.firstMatch(binaryContent);

  if (match != null) {
    final extractedText = match.group(1) ?? '';

    // Extract everything before the date (if present)
    final beforeDatePattern = RegExp(r'^(.*) \(.*\)');
    final beforeDateMatch = beforeDatePattern.firstMatch(extractedText);
    final preVersionText = beforeDateMatch?.group(1) ?? extractedText;

    // Refine to match the version pattern
    final versionValidationPattern = RegExp(r'[\w\d.-]+ \(\w+\)');
    final validationMatch = versionValidationPattern.firstMatch(preVersionText);

    if (validationMatch != null) {
      var versionName = validationMatch.group(0);
      if (versionName == null) return 'Version not found';

      // versionName examples
      // 3.8.0-24.0.dev (dev)
      // 3.5.4 (stable)

      // Extract version = replace (channel) with empty string
      final version = versionName.replaceAll(RegExp(r' \(\w+\)$'), '').trim();

      return version;
    } else {
      return 'Valid Dart version pattern not found';
    }
  } else {
    return 'Pattern not found in the binary content';
  }
}
