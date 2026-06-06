import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

Future<Uint8List?> picImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(
    source: source,
    imageQuality: 50, // Compress quality to 50%
    maxWidth: 400,    // Resize width to maximum 400px
    maxHeight: 400,   // Resize height to maximum 400px
  );
  if (file != null) {
    return await file.readAsBytes();
  }
  return null;
}

Future<String> uploadimgtostorage(
    String bucketName, Uint8List file, String? userid) async {
  final path = '$userid';
  await _supabase.storage.from(bucketName).uploadBinary(
        path,
        file,
        fileOptions: const FileOptions(upsert: true),
      );
  return path;
}

Future<String> saveData(String? userid, {Uint8List? file}) async {
  String resp = "Some thing Error";
  try {
    String imageUrl = await uploadimgtostorage('ProfileImage', file!, userid);
    await _supabase
        .from('profiles')
        .update({'imgaeLink': imageUrl})
        .eq('id', userid!);
    resp = "Success";
  } catch (err) {
    resp = err.toString();
  }
  return resp;
}
