import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/constants/sizes.dart';
import '../../../../../common_widgets/constants/text_string.dart';
import '../../../../core/screens/forget_password/forget_password_mail_screen.dart';
import '../../../controllers/login_controllers.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}
bool _passwordVisible = true;

@override
 void initState() {
    _passwordVisible = false;
  }

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: tEmail,
                  hintText: tEmail,
                  border: OutlineInputBorder()
                  ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              obscureText: _passwordVisible,
              controller: controller.password,
              decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: tPassword,
                hintText: tPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                   _passwordVisible = !_passwordVisible;
                   
               }
               );
               },
                  icon: _passwordVisible? const Icon(Icons.visibility_off_outlined) :const Icon(Icons.visibility_outlined),
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () => {Get.to(() => const ForgetPasswordMailScreen())}, child: const Text(tForgetPassword)),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {controller.login();},
                child: Text(tLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}