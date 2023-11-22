// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/controllers/parking_controllers.dart';

class BuildingSelector extends StatelessWidget {
  const BuildingSelector({super.key});

  @override
  Widget build(BuildContext context) {
    ParkingController parkingController = Get.put(ParkingController());
    return DropdownButton(
        focusColor: Colors.white,
        items: const [
          DropdownMenuItem(
            value: "A Building",
            child: Text("A Building"),
          ),
          DropdownMenuItem(
            value: "B Building",
            child: Text("B Building"),
          ),
          DropdownMenuItem(
            value: "C Building",
            child: Text("C Building"),
          )
        ],
        onChanged: (value) {
          parkingController.selectedBuilding.value = value.toString();
          // print(value);
        },
        hint: Obx(
          () => Text(
            parkingController.selectedBuilding.value,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        )
      );
  }
}
