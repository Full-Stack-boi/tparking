
//import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//final _auth = FirebaseAuth.instance.currentUser;

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  // final List<String> phoneNo;
  final String phoneNo;
  final String password;
  final String roles;
  final String? imgaeLink; 
  //final Uint8List? file;

  UserModel({
    this.imgaeLink,
    this.id, 
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.roles
    
   }
  );
  toJson(){
    return {
      "Fullname"  : fullName,
      "Email"     : email,
      "Password"  : password,
      "PhoneNo"   : phoneNo,
      "Roles"     : roles,
      "imgaeLink"   : imgaeLink, 
    };
  }
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic >> document){
    final data = document.data()!;
    return UserModel(
      id: document.id,
      fullName: data["Fullname"],
      email: data["Email"],
      phoneNo: data["PhoneNo"],
      password: data["Password"],
      roles: data["Roles"],
      imgaeLink:  data["imgaeLink"]
      );
  } 
  
}
