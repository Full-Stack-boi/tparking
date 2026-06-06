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
  late final Future _userDataFuture;
  late final ProfileController controller;

  late final TextEditingController fullName;
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController id;
  late final TextEditingController phoneNo;
  late final TextEditingController roles;

  bool _controllersInitialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    _userDataFuture = controller.getUserData();

    fullName = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    id = TextEditingController();
    phoneNo = TextEditingController();
    roles = TextEditingController();
  }

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    id.dispose();
    phoneNo.dispose();
    roles.dispose();
    super.dispose();
  }

  void selectImage() async {
    final Uint8List? img = await picImage(ImageSource.gallery);

    if (img != null) {
      if (mounted) {
        setState(() {
          _image = img;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        backgroundColor: isDark ? tSecondaryColor : tPrimaryColor,
        elevation: 3.0,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        title: Text(tEditProfile,
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data as UserModel;

                    if (!_controllersInitialized) {
                      fullName.text = user.fullName;
                      email.text = user.email;
                      password.text = user.password;
                      id.text = user.id ?? '';
                      phoneNo.text = user.phoneNo;
                      roles.text = user.roles;
                      _controllersInitialized = true;
                    }

                    return Column(
                      children: [
                        // -- IMAGE with ICON
                        Stack(
                          children: [
                            _image != null
                                ? SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: MemoryImage(_image!)),
                                  )
                                : (user.imgaeLink != null && user.imgaeLink!.isNotEmpty && user.imgaeLink != 'null')
                                    ? SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(user.imgaeLink!)),
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
                              const SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                controller: phoneNo,
                                decoration: const InputDecoration(
                                    label: Text(tPhoneNo),
                                    prefixIcon: Icon(LineAwesomeIcons.phone)),
                              ),
                              const SizedBox(height: tFormHeight),

                              // -- Form Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: _isSaving
                                    ? const Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        onPressed: () async {
                                          if (mounted) {
                                            setState(() {
                                              _isSaving = true;
                                            });
                                          }
                                          try {
                                            String? finalImageUrl = user.imgaeLink;
                                            if (_image != null) {
                                              finalImageUrl = await uploadimgtostorage(
                                                  'ProfileImage', _image!, id.text);
                                            }
                                            final UserData = UserModel(
                                                id: id.text,
                                                fullName: fullName.text.trim(),
                                                email: email.text.trim(),
                                                phoneNo: phoneNo.text.trim(),
                                                password: password.text.trim(),
                                                roles: roles.text.trim(),
                                                imgaeLink: finalImageUrl,
                                                carRegistrations: user.carRegistrations);

                                            await controller.updateRecord(UserData);
                                            Get.showSnackbar(const GetSnackBar(
                                              title: "Success",
                                              message: "Profile updated successfully.",
                                              duration: Duration(seconds: 2),
                                            ));
                                            Get.back();
                                          } catch (e) {
                                            Get.showSnackbar(GetSnackBar(
                                              title: tError,
                                              message: e.toString(),
                                              duration: const Duration(seconds: 2),
                                            ));
                                          } finally {
                                            if (mounted) {
                                              setState(() {
                                                _isSaving = false;
                                              });
                                            }
                                          }
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
                    return const Center(child: Text('Something went wrong'));
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
