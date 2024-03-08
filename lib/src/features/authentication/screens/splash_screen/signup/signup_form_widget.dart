import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tparking/src/features/authentication/controllers/signup_controllers.dart';

import '../../../../../common_widgets/constants/sizes.dart';
import '../../../../../common_widgets/constants/text_string.dart';
import '../../../models/user_model.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllers = Get.put(SignUpController());
    final fromkey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
        key: fromkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controllers.fullName,
              decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controllers.email,
              decoration: const InputDecoration(
                  label: Text(tEmail), prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controllers.phoneNo,
              decoration: const InputDecoration(
                  label: Text(tPhoneNo), prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: tFormHeight - 20),
            DropdownSearch<String>(
              // selectedItem: "Student",
              popupProps: const PopupProps.menu(
                showSelectedItems: true,
                isFilterOnline: true,
                // constraints: BoxConstraints(maxHeight:200),
                fit: FlexFit.loose,
              ),
              items: const ["Student", 'Teacher', "Another"],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  prefixIcon: Icon(Icons.badge_rounded),
                  labelText: "Chooce Your Roles",
                  hintText: "Select Roles",
                ),
              ),
              onChanged: (value) {
                controllers.roles.text = value!;
              },
            ), //Te
            // TextFormField(
            //   controller: controllers.roles,
            //   decoration: const InputDecoration(
            //       label: Text(tRoles), prefixIcon: Icon(Icons.person)),
            // ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controllers.password,
              decoration: const InputDecoration(
                  label: Text(tPassword), prefixIcon: Icon(Icons.fingerprint)),
            ),
            const SizedBox(height: tFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (fromkey.currentState!.validate()) {
                    final user = UserModel(
                      email: controllers.email.text.trim(),
                      password: controllers.password.text.trim(),
                      phoneNo: controllers.phoneNo.text.trim(),
                      // phoneNo:  List.filled(1, controllers.phoneNo.text.trim(),growable: true) ,
                      fullName: controllers.fullName.text.trim(),
                      roles: controllers.roles.text.trim(),
                    );
                    SignUpController.instance.createUser(user);
                  }
                },
                child: Text(tSignup.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
