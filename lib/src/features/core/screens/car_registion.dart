import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:tparking/src/common_widgets/constants/sizes.dart';
import 'package:tparking/src/features/core/screens/reserves/car_register_list.dart';

import '../../../common_widgets/constants/colors.dart';
import '../../../common_widgets/constants/text_string.dart';
import 'orientation_widget.dart';

class CarRegistion extends StatefulWidget {
  const CarRegistion({super.key});

  @override
  State<CarRegistion> createState() => _MyCarRegistion();
}

List<String> carRegisters = [
  // "กค6969","AABBCC",
];

class _MyCarRegistion extends State<CarRegistion> {
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black26 : tPrimaryColor,
        title: Text(tCarRegistration,
            style: Theme.of(context).textTheme.headlineMedium),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: const SafeArea(
          child: OrientationWidget(
        portrait: PortraitContent(),
        lanscape: LanscapeContent(),
      )),
    );

    // child: Column(
    //   children: [
    //     Container(
    //       child: IconButton(onPressed: (){carRegister.add("QWERS");}, icon: Icon(Icons.access_alarm)),
    //     ),
    //     Container(
    //   child: IconButton(onPressed: (){carRegister.remove("QWERS");}, icon: Icon(Icons.accessibility_new_outlined)),
    // ),
    //   ],
    // ),

    // );
  }
}

class PortraitContent extends StatefulWidget {
  const PortraitContent({super.key});

  @override
  State<PortraitContent> createState() => _ProtraitState();
}

class _ProtraitState extends State<PortraitContent> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      carRegisters = CarRegistions.getToken() ?? [];
      // carRegisters[index] = carRegisters[index];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inputcontroller = TextEditingController();
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            // height: 300,
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
                      prefixIcon: const Icon(Icons.car_crash),
                      suffixIcon: TextButton(
                        onPressed: () async {
                          if (inputcontroller.value.text == '') {
                            Get.showSnackbar(const GetSnackBar(
                              title: tError,
                              message: "Please Enter Car Registration",
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            // แก้ได้
                            setState(() {
                              carRegisters = CarRegistions.getToken() ?? [];

                              //carRegister = carRegister;
                            });
                            // แก้ได้
                            carRegisters.add(inputcontroller.value.text);
                            await CarRegistions.SetCarRegister(carRegisters);
                          }
                        },
                        child: const Text("ADD"),
                      ),
                      label: const Text(tCarRegistration),
                      border: const OutlineInputBorder()),
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Align(
                //   alignment: Alignment.center,
                //   child: TextButton(
                //     onPressed: () {
                //       if (inputcontroller.value.text == '') {
                //         Get.showSnackbar(const GetSnackBar(
                //           title: "Error",
                //           message: "Please Enter Car Registration",
                //           duration: Duration(seconds: 3),
                //         ));
                //       } else {
                //           // แก้ได้
                //         setState(() {carRegister = carRegister; });
                //         // แก้ได้
                //         carRegister.add(inputcontroller.value.text);
                //       }
                //     },
                //     child: const Text("ADD"),
                //   ),
                // ),
                // const SizedBox(
                //   height: 25,
                // ),
                // Align(
                //   alignment: Alignment.center,
                //   child: TextButton(
                //     onPressed: () {
                //       if (inputcontroller.value.text == '') {
                //         Get.showSnackbar(const GetSnackBar(
                //           title: "Error",
                //           message: "Please Enter Car Registration",
                //           duration: Duration(seconds: 3),
                //         ));
                //       } else {

                //       }
                //     },
                //     child: const Text("Remove"),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: carRegisters.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: SlideAnimation(
                      child: SizedBox(
                          child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        // margin: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ScaleAnimation(
                          duration: const Duration(milliseconds: 400),
                          child: ListTile(
                            leading: const Icon(Icons.car_rental),
                            title: Text((carRegisters[index])),
                            subtitle: const Text("Your Car Register"),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // แก้ได้
                                setState(() {
                                  carRegisters =
                                      CarRegistions.getToken(index) ?? [];
                                  // carRegisters[index] = carRegisters[index];
                                });
                                // แก้ได้
                                CarRegistions.delete();
                                carRegisters.remove(carRegisters[index]);
                                CarRegistions.SetCarRegister(carRegisters);
                                //carRegisters.remove(carRegisters[index]);
                              },
                            ),

                            // child: Text(carRegister[index],style: TextStyle(fontSize:20),)
                          ),
                        ),
                      )),
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
  const LanscapeContent({super.key});

  @override
  State<LanscapeContent> createState() => _LanscapeContentState();
}

class _LanscapeContentState extends State<LanscapeContent> {
  @override
  Widget build(BuildContext context) {
    final inputcontroller = TextEditingController();
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: SingleChildScrollView(
            child: Container(
              // height: 300,
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
                        prefixIcon: const Icon(Icons.car_crash),
                        suffixIcon: TextButton(
                          onPressed: () {
                            if (inputcontroller.value.text == '') {
                              Get.showSnackbar(const GetSnackBar(
                                title: tError,
                                message: "Please Enter Car Registration",
                                duration: Duration(seconds: 2),
                              ));
                            } else {
                              // แก้ได้
                              setState(() {
                                carRegisters = carRegisters;
                              });
                              // แก้ได้
                              carRegisters.add(inputcontroller.value.text);
                            }
                          },
                          child: const Text("ADD"),
                        ),
                        label: const Text(tCarRegistration),
                        border: const OutlineInputBorder()),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       if (inputcontroller.value.text == '') {
                  //         Get.showSnackbar(const GetSnackBar(
                  //           title: "Error",
                  //           message: "Please Enter Car Registration",
                  //           duration: Duration(seconds: 3),
                  //         ));
                  //       } else {
                  //           // แก้ได้
                  //         setState(() {carRegister = carRegister; });
                  //         // แก้ได้
                  //         carRegister.add(inputcontroller.value.text);
                  //       }
                  //     },
                  //     child: const Text("ADD"),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 25,
                  // ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       if (inputcontroller.value.text == '') {
                  //         Get.showSnackbar(const GetSnackBar(
                  //           title: "Error",
                  //           message: "Please Enter Car Registration",
                  //           duration: Duration(seconds: 3),
                  //         ));
                  //       } else {

                  //       }
                  //     },
                  //     child: const Text("Remove"),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: carRegisters.length,
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
                        // margin: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ScaleAnimation(
                          duration: const Duration(milliseconds: 400),
                          child: ListTile(
                            leading: const Icon(Icons.car_rental),
                            title: Text(carRegisters[index]),
                            subtitle: const Text("Your Car Register"),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // แก้ได้
                                setState(() {
                                  carRegisters[index] = carRegisters[index];
                                });
                                // แก้ได้
                                carRegisters.remove(carRegisters[index]);
                              },
                            ),

                            // child: Text(carRegister[index],style: TextStyle(fontSize:20),)
                          ),
                        ),
                      )),
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
