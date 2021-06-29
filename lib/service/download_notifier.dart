import 'dart:io';
import 'dart:typed_data';
import 'package:geschehen/widgets/download_button.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadNotifier with ChangeNotifier {
  double _progress = 0;
  double get downloadProgress => _progress;
  static DownloadStatus _status = DownloadStatus.notDownloaded;
  get downloadStatus => _status;

  initStatus(String filename) async {
    if (await isDownloaded(filename)) {
      _status = DownloadStatus.downloaded;
      notifyListeners();
    }
  }

  void startDownloading(String url, String filename) {
    _startDownloading(url, filename);
  }

  Future _startDownloading(String url, String filename) async {
    if (await isDownloaded(filename)) {
      _status = DownloadStatus.downloaded;
      notifyListeners();
      return;
    }
    _status = DownloadStatus.fetchingDownload;
    notifyListeners();
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>> chunks = List.empty(growable: true);
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      _status = DownloadStatus.downloading;
      notifyListeners();
      r.stream.listen(
        (List<int> chunk) {
          if (r.contentLength != null && r.contentLength! > 0) {
            _progress = downloaded / r.contentLength!;
          }
          debugPrint("$_progress");
          chunks.add(chunk);
          downloaded += chunk.length;
          notifyListeners();
        },
        onDone: () async {
          _progress = 1.0;
          _status = DownloadStatus.downloaded;
          notifyListeners();
          // Save the file
          File file = new File('$dir/$filename');
          final Uint8List bytes = Uint8List(r.contentLength ?? 0);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);
          return;
        },
        onError: (e) {
          print(e);
        },
      );
    });
  }

  static Future<bool> isDownloaded(String filename) async {
    final file = await getLocalFile(filename);
    if (file != null) {
      return true;
    }
    return false;
  }

  static Future<String?> getLocalFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$filename");
    if (await file.exists()) {
      print("File exists: " + file.path);
      _status = DownloadStatus.downloaded;
      return file.path;
    }
    _status = DownloadStatus.notDownloaded;
    return null;
  }

  Future delete(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$filename");
    if (await file.exists()) {
      print("File exists: " + file.path);
      file.deleteSync();
      _status = DownloadStatus.notDownloaded;
      notifyListeners();
    }
  }
}

Future<bool> isDownloaded(String filename) async {
  final file = await getLocalFile(filename);
  if (file != null) {
    return true;
  }
  return false;
}

Future<String?> getLocalFile(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/$filename");
  if (await file.exists()) {
    print("File exists: " + file.path);
    return file.path;
  }
  return null;
}
