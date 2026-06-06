
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:get/get.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';
import 'package:tparking/src/repository/authentication_repository/user_repository/user_repository.dart';
import 'package:tparking/src/features/authentication/screens/splash_screen/welcome/welcome_screen.dart';
import 'package:tparking/src/features/core/screens/dashboard/dashboard.dart';
import 'package:tparking/src/repository/exceptions/login_with_email_and_pssword_failure.dart';
import 'package:tparking/src/repository/exceptions/signup_email_password_failure.dart';

import '../../common_widgets/constants/text_string.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final _supabase = supabase.Supabase.instance.client;
  late final Rx<supabase.User?> supabaseUser;

  //Will be loaded when app launches to set and track user session
  @override
  void onReady() {
    supabaseUser = Rx<supabase.User?>(_supabase.auth.currentUser);
    _supabase.auth.onAuthStateChange.listen((data) {
      supabaseUser.value = data.session?.user;
    });
    ever(supabaseUser, _setInitialScreen);
  }

  /// If we are setting initial screen from here
  /// then in the main.dart => App() add CircularProgressIndicator()
  _setInitialScreen(supabase.User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => const Dashboard());
  }

  //FUNC
  Future<String?> createUserWithEmailAndPassword(String email, String password, [UserModel? user]) async {
    try {
      final response = await _supabase.auth.signUp(email: email, password: password);
      if (response.user != null) {
        if (user != null) {
          final userWithId = UserModel(
            id: response.user!.id,
            fullName: user.fullName,
            email: user.email,
            phoneNo: user.phoneNo,
            password: user.password,
            roles: user.roles,
            imgaeLink: user.imgaeLink,
          );
          await UserRepository.instance.createUser(userWithId);
        }
        supabaseUser.value = response.user;
        Get.offAll(() => const Dashboard());
      }
    } on supabase.AuthException catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: tError,
          message: e.message,
          duration: const Duration(seconds: 3),
        )
      );
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on supabase.AuthException catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: tError,
          message: e.message == "Unable to establish connection on channel."
              ? "Email or Password isn't filled"
              : e.message,
          duration: const Duration(seconds: 3),
        )
      );
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  Future<void> logout() async => await _supabase.auth.signOut();
  Future<void> deleteUser() async => await logout(); 
}