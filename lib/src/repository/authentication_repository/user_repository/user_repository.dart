

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';

import '../../../common_widgets/constants/text_string.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _supabase = Supabase.instance.client;

  Future<void> createUser(UserModel user) async {
    try {
      final data = user.toJson();
      if (user.id != null) {
        data['id'] = user.id;
      }
      print("Supabase: Attempting to insert profile data: $data");
      await _supabase.from('profiles').insert(data);
      print("Supabase: Profile data inserted successfully!");
      Get.showSnackbar(const GetSnackBar(
        title: "Success",
        message: "Your account has been created. ",
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      print("Supabase: ERROR inserting profile: $error");
      Get.showSnackbar(const GetSnackBar(
        title: tError,
        message: "Something went wrong. Try again. ",
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('email', email)
        .single();
    
    UserModel user = UserModel.fromJson(response);

    // Generate signed URL dynamically if the user has an image path
    if (user.imgaeLink != null && user.imgaeLink!.isNotEmpty) {
      try {
        final signedUrl = await _supabase.storage
            .from('ProfileImage')
            .createSignedUrl(user.imgaeLink!, 7200);
        user = UserModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phoneNo: user.phoneNo,
          password: user.password,
          roles: user.roles,
          imgaeLink: signedUrl,
          carRegistrations: user.carRegistrations,
        );
      } catch (e) {
        // Fallback or ignore
      }
    }
    return user;
  }

  Future<List<UserModel>> allUser() async {
    final response = await _supabase.from('profiles').select();
    final List<UserModel> users = [];
    
    for (var row in response) {
      UserModel user = UserModel.fromJson(row);
      if (user.imgaeLink != null && user.imgaeLink!.isNotEmpty) {
        try {
          final signedUrl = await _supabase.storage
              .from('ProfileImage')
              .createSignedUrl(user.imgaeLink!, 7200);
          user = UserModel(
            id: user.id,
            fullName: user.fullName,
            email: user.email,
            phoneNo: user.phoneNo,
            password: user.password,
            roles: user.roles,
            imgaeLink: signedUrl,
            carRegistrations: user.carRegistrations,
          );
        } catch (_) {}
      }
      users.add(user);
    }
    return users;
  }

  Future<void> updateUserRecord(UserModel user) async {
    final data = user.toJson();
    // Do not overwrite the stored DB path/filename with the temporary signed URL
    if (user.imgaeLink != null && 
        (user.imgaeLink!.startsWith('http://') || user.imgaeLink!.startsWith('https://'))) {
      data.remove('imgaeLink');
    }
    await _supabase.from('profiles').update(data).eq('id', user.id!);
  }

  Future<void> deleteDocumentByField(String email) async {
    await _supabase.from('profiles').delete().eq('email', email);
  }
}