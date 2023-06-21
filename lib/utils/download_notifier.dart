import 'package:flutter/foundation.dart';
import 'package:internet_file/internet_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:internet_file/storage_io.dart';

final DownloadNotifier downloadNotifier = DownloadNotifier();

class DownloadNotifier extends ChangeNotifier {
  Map<String, dynamic> downloads = {};

  Future<String?> downloadMaterial(
      {required InternetFileStorageIO storageIO,
      required String downloadLink,
      required String fileName}) async {
    if (downloads.containsKey(fileName)) return null;

    var dir = await getExternalStorageDirectory();
    String filePath = "${dir!.path}/$fileName";

    try {
      await InternetFile.get(
        downloadLink,
        storage: storageIO,
        progress: (receivedLength, contentLength) {
          final percentage = receivedLength / contentLength * 100;
          if (!downloads.containsKey(fileName)) {
            downloads[fileName] = {"progress": percentage, "isComplete": false};
          }
          downloads[fileName]["progress"] = percentage;
          notifyListeners();
          if (kDebugMode)print('download progress: $receivedLength of $contentLength ($percentage%)');
        },
        storageAdditional: storageIO.additional(
          filename: fileName,
          location: dir.path,
        ),
      );
      print(downloads);
      downloads.remove(fileName);
      notifyListeners();
      return filePath;
    } catch (e) {
      return "";
    }
  }
}
