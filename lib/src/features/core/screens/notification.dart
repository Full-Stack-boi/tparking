import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tparking/src/common_widgets/constants/sizes.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';
import 'package:tparking/src/features/core/controllers/profile_controllers.dart';

class TPNotification extends StatefulWidget {
  const TPNotification({super.key});

  @override
  State<TPNotification> createState() => _MyTPNotification();
}

class _MyTPNotification extends State<TPNotification> {
  late final TextEditingController inputcontroller;
  final _profileController = Get.find<ProfileController>();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    inputcontroller = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    inputcontroller.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _profileController.getUserData();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addCar(String carReg) async {
    if (_user == null) return;
    setState(() {
      _isLoading = true;
    });
    final updatedCars = List<String>.from(_user!.carRegistrations)..add(carReg);
    final updatedUser = UserModel(
      id: _user!.id,
      fullName: _user!.fullName,
      email: _user!.email,
      phoneNo: _user!.phoneNo,
      password: _user!.password,
      roles: _user!.roles,
      imgaeLink: _user!.imgaeLink,
      carRegistrations: updatedCars,
    );
    await _profileController.updateRecord(updatedUser);
    setState(() {
      _user = updatedUser;
      _isLoading = false;
    });
  }

  Future<void> _deleteCar(String carReg) async {
    if (_user == null) return;
    setState(() {
      _isLoading = true;
    });
    final updatedCars = List<String>.from(_user!.carRegistrations)..remove(carReg);
    final updatedUser = UserModel(
      id: _user!.id,
      fullName: _user!.fullName,
      email: _user!.email,
      phoneNo: _user!.phoneNo,
      password: _user!.password,
      roles: _user!.roles,
      imgaeLink: _user!.imgaeLink,
      carRegistrations: updatedCars,
    );
    await _profileController.updateRecord(updatedUser);
    setState(() {
      _user = updatedUser;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Car Registration"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: _isLoading || _user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                    child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: tFormHeight - 10, horizontal: tDefaultSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: inputcontroller,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.car_repair),
                            label: Text("Car Registration"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            final text = inputcontroller.text.trim();
                            if (text.isEmpty) {
                              Get.showSnackbar(const GetSnackBar(
                                title: "Error",
                                message: "Please Enter Car Registration",
                                duration: Duration(seconds: 3),
                              ));
                            } else {
                              _addCar(text);
                              inputcontroller.clear();
                            }
                          },
                          child: const Text("ADD"),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            final text = inputcontroller.text.trim();
                            if (text.isEmpty) {
                              Get.showSnackbar(const GetSnackBar(
                                title: "Error",
                                message: "Please Enter Car Registration",
                                duration: Duration(seconds: 3),
                              ));
                            } else {
                              _deleteCar(text);
                              inputcontroller.clear();
                            }
                          },
                          child: const Text("Remove"),
                        ),
                      ),
                    ],
                  ),
                )),
              ));
  }
}
