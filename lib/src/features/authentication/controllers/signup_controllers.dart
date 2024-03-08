import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';
import 'package:tparking/src/repository/authentication_repository/user_repository/user_repository.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final roles = TextEditingController();

  final userRepo = Get.put(UserRepository());

  //Call this Function from Design & it will do the rest
  void registerUser(String email, String password) async {
    // String? error =
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password)
        .toString();
    //  if(error != null) {5
    //    Get.showSnackbar(GetSnackBar(message: error.toString(),));
    //  }
  }

  void createUser(UserModel user) async {
    if (password.text == "" || phoneNo.text == "" || roles.text == "") {
      Get.showSnackbar(const GetSnackBar(
        message: "Please Enter The Empty Field",
        duration: Duration(seconds: 3),
      ));
    } else {
      bool isValid = EmailValidator.validate(email.text);
      if (isValid == true) {
        await userRepo.createUser(user);
        registerUser(user.email, user.password);
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: "Please Enter infrom @gmail.com",
          duration: Duration(seconds: 3),
        ));
      }
      // if (email.text == "" ||email.text != '@gmail' ) {
      //   Get.showSnackbar(const GetSnackBar(message: "Please Enter infrom @gmail.com",duration: Duration(seconds: 3),));
      // } else {

      // }
    }
  }
}
