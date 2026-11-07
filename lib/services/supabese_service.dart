import 'package:flutter_run_tracker_app/model/run.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<String> uploadImageFile(XFile xfile) async {
    final newFileName =
        '${DateTime.now().millisecondsSinceEpoch}_${xfile.name}';

    await supabase.storage.from('run_bk').uploadBinary(
          newFileName,
          await xfile.readAsBytes(),
          fileOptions: FileOptions(contentType: xfile.mimeType),
        );
    return supabase.storage.from('run_bk').getPublicUrl(newFileName);
  }

  Future<void> insertRunData(Run run) async {
    await supabase.from('Run_tp').insert(run.toJson());
  }

  Future<void> uploadAndSaveRun(Run run, {XFile? image}) async {
    if (image != null) {
      run.runimageUrl = await uploadImageFile(image);
    }

    await insertRunData(run);
  }
}
