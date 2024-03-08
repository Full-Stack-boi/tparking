import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';
import 'package:tparking/src/features/core/screens/profiles/profile_image.dart';
import 'package:tparking/src/repository/authentication_repository/user_repository/user_repository.dart';

import '../../../../common_widgets/constants/colors.dart';
import '../../../../common_widgets/constants/image_stritngs.dart';
import '../../../../common_widgets/constants/sizes.dart';
import '../../../../common_widgets/constants/text_string.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../controllers/profile_controllers.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tEditProfile,
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
              future: controller.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data as UserModel;

                    void saveprofile() async {
                      saveData(user.id, file: _image);
                    }

                    final fullName = TextEditingController(text: user.fullName);
                    final email = TextEditingController(text: user.email);
                    final password = TextEditingController(text: user.password);
                    final id = TextEditingController(text: user.id);
                    // final phoneNo = TextEditingController(text:user.phoneNo);
                    final phoneNo = TextEditingController(text: user.phoneNo);
                    final roles = TextEditingController(text: user.roles);
                    // final imgaeLink = TextEditingController(text: user.imgaeLink);

                    void selectImage() async {
                      final Uint8List img = await picImage(ImageSource.gallery);

                      setState(() {
                        _image = img;
                        saveprofile();
                      });
                    }

                    return Column(
                      children: [
                        // -- IMAGE with ICON
                        Stack(
                          children: [
                            _image != null
                                ?
                                // CircleAvatar(
                                //     child: const Image(image: AssetImage(tProfileImage))),
                                // _image!= null ?
                                SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: MemoryImage(_image!)),
                                  )
                                : const SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image(
                                            image: AssetImage(tProfileImage))),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: tPrimaryColor),
                                child: IconButton(
                                    onPressed: selectImage,
                                    icon: const Icon(LineAwesomeIcons.camera,
                                        color: Colors.black, size: 20)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),

                        // -- Form Fields
                        Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: fullName,
                                decoration: const InputDecoration(
                                    label: Text(tFullName),
                                    prefixIcon: Icon(LineAwesomeIcons.user)),
                              ),
                              // const SizedBox(height: tFormHeight - 20),
                              // TextFormField(
                              //   controller: email,
                              //   decoration: const InputDecoration(
                              //       label: Text(tEmail), prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                              // ),
                              const SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: phoneNo,
                                decoration: const InputDecoration(
                                    label: Text(tPhoneNo),
                                    prefixIcon: Icon(LineAwesomeIcons.phone)),
                              ),
                              // const SizedBox(height: tFormHeight - 20),
                              // TextFormField(
                              //   obscureText: true,
                              //   controller: password,
                              //   decoration: InputDecoration(
                              //     label: const Text(tPassword),
                              //     prefixIcon: const Icon(Icons.fingerprint),
                              //     suffixIcon:
                              //     IconButton(icon: const Icon(LineAwesomeIcons.eye_slash), onPressed: () {}),
                              //   ),
                              // ),
                              const SizedBox(height: tFormHeight),

                              // -- Form Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // ignore: non_constant_identifier_names
                                    final UserData = UserModel(
                                        id: id.text,
                                        fullName: fullName.text.trim(),
                                        email: email.text.trim(),
                                        phoneNo: phoneNo.text.trim(),
                                        // phoneNo:    List.filled(1, phoneNo.text.trim(),growable: true),
                                        password: password.text.trim(),
                                        roles: roles.text.trim(),
                                        imgaeLink: user.imgaeLink.toString());
                                    _image == null
                                        ? Get.showSnackbar(const GetSnackBar(
                                            message:
                                                "Your profile didn't change . ",
                                            duration: Duration(seconds: 2),
                                          ))
                                        : saveprofile();
                                    await controller.updateRecord(UserData);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: tPrimaryColor,
                                      side: BorderSide.none,
                                      shape: const StadiumBorder()),
                                  child: const Text(tEditProfile,
                                      style: TextStyle(color: tDarkColor)),
                                ),
                              ),
                              const SizedBox(height: tFormHeight),

                              // -- Created Date and Delete Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // const Text.rich(
                                  //   TextSpan(
                                  //     text: tJoined,
                                  //     style: TextStyle(fontSize: 12),
                                  //     children: [
                                  //       TextSpan(
                                  //           text: tJoinedAt,
                                  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                                  //     ],
                                  //   ),
                                  // ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.redAccent.withOpacity(0.1),
                                        elevation: 0,
                                        foregroundColor: Colors.red,
                                        shape: const StadiumBorder(),
                                        side: BorderSide.none),
                                    child: const Text(tDelete),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "DELETE USER",
                                        // titleStyle: const TextStyle(fontSize: 20),
                                        content: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "Are you sure, you want to delete your account?",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        confirm: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              side: BorderSide.none),
                                          onPressed: () {
                                            AuthenticationRepository.instance
                                                .deleteUser();
                                            UserRepository.instance
                                                .deleteDocumentByField(
                                                    user.email);
                                          },
                                          child: const Text("YES"),
                                        ),

                                        cancel: OutlinedButton(
                                            onPressed: () => Get.back(),
                                            child: const Text("No")),
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text('Sommthing went wrong'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
