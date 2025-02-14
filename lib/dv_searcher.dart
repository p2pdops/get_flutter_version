import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CommitDetails {
  String commitUrl, commitMessage, version;
  DateTime commitTime;

  CommitDetails(
      this.commitUrl, this.commitMessage, this.commitTime, this.version);
}

Future<CommitDetails?> getDartCommitDetails(String dartVersion) async {
  final dartSdkUrl =
      'https://dart.googlesource.com/sdk.git/+/refs/tags/$dartVersion?format=JSON';

  print('Dart SDK URL: $dartSdkUrl');

  try {
    final response = await http.get(Uri.parse(dartSdkUrl));

    if (response.statusCode == 200) {
      // print('Dart commit info: ${response.body}');

      final data = jsonDecode(response.body.replaceFirst(")]}'", ''));
      // print('Dart commit metadata: $data');
      final commitTimeStr = data['committer']['time'] as String;
      final commitMessage = data['message'] as String;
      final commitUrl = dartSdkUrl;
      print('Time: $commitTimeStr');

      DateFormat format = DateFormat("EEE MMM dd HH:mm:ss yyyy Z");

      final commitTime = format.parse(commitTimeStr);

      return CommitDetails(commitUrl, commitMessage, commitTime, dartVersion);
    } else {
      print(
          'Failed to fetch Dart commit metadata. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching Dart commit time: $e');
    return null;
  }
}

Future<String> githubFindCommit(CommitDetails details) async {
  var searchStart = details.commitTime;

  while (true) {
    final formattedStart = searchStart.toIso8601String();
    final formattedEnd = searchStart.add(Duration(days: 2)).toIso8601String();

    final flutterRepoCommitsUrl =
        'https://api.github.com/repos/flutter/flutter/commits?path=DEPS&since=$formattedStart&until=$formattedEnd';
    print('Searching for commits between $formattedStart and $formattedEnd');
    print("Flutter Repo Commits URL: $flutterRepoCommitsUrl");
    final headers = {
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'dart-script',
    };

    try {
      final response =
          await http.get(Uri.parse(flutterRepoCommitsUrl), headers: headers);

      if (response.statusCode == 200) {
        final commits = jsonDecode(response.body) as List;

        for (var commit in commits) {
          final commitMessage = commit['commit']['message'] as String;

          // Check if the commit message matches "Roll Dart to <dartVersion>"
          if (commitMessage.contains('Roll Dart to ${details.version}')) {
            final commitSha = commit['sha'];
            return 'https://github.com/flutter/flutter/commit/$commitSha';
          }
        }
      } else {
        print('Failed to fetch commits. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Flutter commits: $e');
    }

    // Increment search window by 2 days
    searchStart = searchStart.add(Duration(days: 2));
  }
}
