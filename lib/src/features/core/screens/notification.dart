import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tparking/src/common_widgets/constants/sizes.dart';
import 'package:tparking/src/features/core/screens/reserves/car_register_list.dart';

class TPNotification extends StatefulWidget {
  const TPNotification({super.key});

  @override
  State<TPNotification> createState() => _MyTPNotification();
}

class _MyTPNotification extends State<TPNotification> {
  @override
  Widget build(BuildContext context) {
    final inputcontroller = TextEditingController();
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Car Registration"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
              child: Container(
            // height: 1000,
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
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      if (inputcontroller.value.text == '') {
                        Get.showSnackbar(const GetSnackBar(
                          title: "Error",
                          message: "Please Enter Car Registration",
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        carRegister.add(inputcontroller.value.text);
                      }
                    },
                    child: const Text("ADD"),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      if (inputcontroller.value.text == '') {
                        Get.showSnackbar(const GetSnackBar(
                          title: "Error",
                          message: "Please Enter Car Registration",
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        carRegister.remove(inputcontroller.value.text);
                      }
                    },
                    child: const Text("Remove"),
                  ),
                ),
              ],
            ),
          )),
        )
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

        );
  }
}
