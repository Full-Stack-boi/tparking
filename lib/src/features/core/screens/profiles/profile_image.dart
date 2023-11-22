// import 'dart:ffi';
// import 'dart:html';
 import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

picImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  // XFile? file = await imagePicker.pickImage(source: source);
  if (file!=null) {
    return await file.readAsBytes();
  } 
  // print("no ImageEEEEEEEEEEEEEEEEEEEEE");

}



Future<String> uploadimgtostorage(String childName,Uint8List file,String? userid)async{
 Reference ref = _storage.ref().child(childName).child(userid!);
 UploadTask uploadTask = ref.putData(file);
 TaskSnapshot snapshot = await uploadTask;
 String getDownloadURL = await snapshot.ref.getDownloadURL();
 return  getDownloadURL;

}


Future<String> saveData(String? userid, {
  Uint8List? file
}) async{
  String resp = " Some thing Error";
  try {
    String imageUrl =  await uploadimgtostorage('ProfileImage',file!,userid);
    await _firestore.collection('User').doc(userid).update({'imgaeLink': imageUrl});
  } catch (err) {
    resp = err.toString();
    
  }
  return resp;
}