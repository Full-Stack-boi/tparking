

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';

import '../../../common_widgets/constants/text_string.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db  = FirebaseFirestore.instance;

  

  createUser(UserModel user) async {
     await _db.collection("User").add(user.toJson()).whenComplete(
    //await _db.collection("User").doc(_auth.toString()).set(user.toJson()).whenComplete(
      () => Get.showSnackbar(const GetSnackBar( title: "Success",message:  "You account has been created. ",
      duration: Duration(seconds: 2),)),
   )
  // ignore: body_might_complete_normally_catch_error
  .catchError((error,stackTrace){
     Get.showSnackbar(const GetSnackBar( title: tError,message: "Somthing went wrong. Try again. ",
     duration: Duration(seconds: 2)));
    }
   );
    
  }
  Future<UserModel> getUserDetails(String email) async{
    final snapshot = await _db.collection("User").where("Email",isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  //   Future<List<UserModel>> getUserDetails(String email) async{
  //   final snapshot = await _db.collection("User").where("Email",isEqualTo: email).get();
  //   final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  //   return userData;
  // }

Future<List<UserModel>> allUser() async{
    final snapshot = await _db.collection("User").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

Future<void> updateUserRecord(UserModel user) async{
  await _db.collection("User").doc(user.id).update(user.toJson());

}


Future<void> deleteDocumentByField(String email) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('User')
      .where('Email', isEqualTo: email)
      .get();

  for (var doc in querySnapshot.docs) {
    doc.reference.delete();
  }
}

  // for (var doc in snapshot.docs) {
  //   doc.reference.delete();
  // }

}