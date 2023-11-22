
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tparking/src/features/authentication/screens/splash_screen/welcome/welcome_screen.dart';
import 'package:tparking/src/features/core/screens/dashboard/dashboard.dart';
import 'package:tparking/src/repository/exceptions/login_with_email_and_pssword_failure.dart';
import 'package:tparking/src/repository/exceptions/signup_email_password_failure.dart';

import '../../common_widgets/constants/text_string.dart';


class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();


  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;


  //Will be load when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }


  /// If we are setting initial screen from here
  /// then in the main.dart => App() add CircularProgressIndicator()
  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => const Dashboard());
  }


  //FUNC
  Future<String?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => const Dashboard()) : Get.to(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
        Get.showSnackbar(
        GetSnackBar(title: tError,
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
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {

      //var snackbar = SnackBar(content: Text(e.message.toString()));
      Get.showSnackbar(
        GetSnackBar(title: tError,
      message: e.message =="Unable to establish connection on channel."?
      "Email or Password isn't fielded":e.message,
      duration: const Duration(seconds: 3),
      )
      );
      //final ex = LogInWithEmailAndPasswordFailure.code(e.code);
      // Get.snackbar("Error",e.message.toString(),
      // snackPosition: SnackPosition.TOP,
      // backgroundColor: Colors.black54,
      // colorText: tWhiteColor);
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }


  Future<void> logout() async => await _auth.signOut();
  Future<void> deleteUser() async => await _auth.currentUser!.delete(); 


}