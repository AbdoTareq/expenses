import 'package:file_picker/file_picker.dart';
import 'package:logger/web.dart';

abstract class PickerManager {
  Future<String?> pickFile();
}

class FilePickerManager extends PickerManager {
  @override
  Future<String?> pickFile() async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (file != null) {
        return file.files.first.path!;
      }
    } catch (e) {
      Logger().i(e);
    }
    return null;
  }
}
