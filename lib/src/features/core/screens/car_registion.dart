import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:tparking/src/common_widgets/constants/sizes.dart';
import 'package:tparking/src/common_widgets/constants/colors.dart';
import 'package:tparking/src/common_widgets/constants/text_string.dart';
import 'orientation_widget.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';
import 'package:tparking/src/features/core/controllers/profile_controllers.dart';

class CarRegistion extends StatefulWidget {
  const CarRegistion({super.key});

  @override
  State<CarRegistion> createState() => _CarRegistionState();
}

class _CarRegistionState extends State<CarRegistion> {
  final _profileController = Get.put(ProfileController());
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _profileController.getUserData();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Error loading profile",
        message: e.toString(),
        duration: const Duration(seconds: 3),
      ));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addCar(String carReg) async {
    if (_user == null) return;
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
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
    if (mounted) {
      setState(() {
        _user = updatedUser;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCar(int index) async {
    if (_user == null) return;
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    final updatedCars = List<String>.from(_user!.carRegistrations)..removeAt(index);
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
    if (mounted) {
      setState(() {
        _user = updatedUser;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: isDark ? tSecondaryColor : tPrimaryColor,
        elevation: 3.0,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        title: Text(tCarRegistration,
            style: Theme.of(context).textTheme.headlineMedium),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _user == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Could not load user data"),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            _loadUserData();
                          },
                          child: const Text("Retry"),
                        )
                      ],
                    ),
                  )
                : OrientationWidget(
                    portrait: PortraitContent(
                      user: _user!,
                      onAdd: _addCar,
                      onDelete: _deleteCar,
                    ),
                    lanscape: LanscapeContent(
                      user: _user!,
                      onAdd: _addCar,
                      onDelete: _deleteCar,
                    ),
                  ),
      ),
    );
  }
}

class PortraitContent extends StatefulWidget {
  final UserModel user;
  final Function(String) onAdd;
  final Function(int) onDelete;

  const PortraitContent({
    super.key,
    required this.user,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  State<PortraitContent> createState() => _PortraitContentState();
}

class _PortraitContentState extends State<PortraitContent> {
  late final TextEditingController inputcontroller;

  @override
  void initState() {
    super.initState();
    inputcontroller = TextEditingController();
  }

  @override
  void dispose() {
    inputcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cars = widget.user.carRegistrations;
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(
                vertical: 50, horizontal: tDefaultSize - 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  maxLength: 7,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: inputcontroller,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.car_crash, color: tTomatoColor),
                      prefixIconColor: tTomatoColor,
                      suffixIcon: TextButton(
                        onPressed: () {
                          final text = inputcontroller.text.trim();
                          if (text.isEmpty) {
                            Get.showSnackbar(const GetSnackBar(
                              title: tError,
                              message: "Please Enter Car Registration",
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            widget.onAdd(text);
                            inputcontroller.clear();
                          }
                        },
                        child: const Text(
                          "ADD",
                          style: TextStyle(
                            color: tTomatoColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      labelText: tCarRegistration,
                      labelStyle: const TextStyle(color: tTomatoColor),
                      floatingLabelStyle: const TextStyle(color: tTomatoColor),
                      counterStyle: const TextStyle(color: tTomatoColor),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: tTomatoColor, width: 1.5),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: tTomatoColor, width: 2.0),
                      ),
                      border: const OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cars.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: SizedBox(
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ScaleAnimation(
                          duration: const Duration(milliseconds: 400),
                          child: ListTile(
                            leading: const Icon(Icons.car_rental),
                            title: Text(cars[index]),
                            subtitle: const Text("Your Car Register"),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => widget.onDelete(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LanscapeContent extends StatefulWidget {
  final UserModel user;
  final Function(String) onAdd;
  final Function(int) onDelete;

  const LanscapeContent({
    super.key,
    required this.user,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  State<LanscapeContent> createState() => _LanscapeContentState();
}

class _LanscapeContentState extends State<LanscapeContent> {
  late final TextEditingController inputcontroller;

  @override
  void initState() {
    super.initState();
    inputcontroller = TextEditingController();
  }

  @override
  void dispose() {
    inputcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cars = widget.user.carRegistrations;
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(
                  vertical: 50, horizontal: tDefaultSize - 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    maxLength: 7,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: inputcontroller,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.car_crash, color: tTomatoColor),
                        prefixIconColor: tTomatoColor,
                        suffixIcon: TextButton(
                          onPressed: () {
                            final text = inputcontroller.text.trim();
                            if (text.isEmpty) {
                              Get.showSnackbar(const GetSnackBar(
                                title: tError,
                                message: "Please Enter Car Registration",
                                duration: Duration(seconds: 2),
                              ));
                            } else {
                              widget.onAdd(text);
                              inputcontroller.clear();
                            }
                          },
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              color: tTomatoColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        labelText: tCarRegistration,
                        labelStyle: const TextStyle(color: tTomatoColor),
                        floatingLabelStyle: const TextStyle(color: tTomatoColor),
                        counterStyle: const TextStyle(color: tTomatoColor),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: tTomatoColor, width: 1.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: tTomatoColor, width: 2.0),
                        ),
                        border: const OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cars.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: SizedBox(
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.only(top: 14, right: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ScaleAnimation(
                            duration: const Duration(milliseconds: 400),
                            child: ListTile(
                              leading: const Icon(Icons.car_rental),
                              title: Text(cars[index]),
                              subtitle: const Text("Your Car Register"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => widget.onDelete(index),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
