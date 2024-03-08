import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:smart_car_parking/components/parking_slot.dart';
import 'package:tparking/src/repository/parkingSlot/parking_slot.dart';

import '../../../../common_widgets/constants/colors.dart';
import '../../../../repository/parkingSlot/building_selector.dart';
import '../../../controllers/parking_controllers.dart';

class Reserve extends StatelessWidget {
  const Reserve({super.key});

  @override
  Widget build(BuildContext context) {
    ParkingController parkingController = Get.put(ParkingController());
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: isDark ? Colors.black26 : tPrimaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                Text("TPARKING",
                    style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Obx(
          () => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Parking Slots",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            BuildingSelector(),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 1),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("ENTRY"),
                            Icon(
                              Icons.keyboard_arrow_down,
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Obx(
                          () => ParkingSlot(
                            isBooked: parkingController.slot1.value.booked,
                            isParked: parkingController.slot1.value.isParked,
                            slotName: "A-1",
                            slotId: parkingController.slot1KEY,
                            time: parkingController.slot1.value.parkingHours
                                .toString(),
                          ),
                        )),
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child:
                              VerticalDivider(color: Colors.red, thickness: 2),
                        ),
                        Expanded(
                          child: ParkingSlot(
                            isBooked: parkingController.slot2.value.booked,
                            isParked: parkingController.slot2.value.isParked,
                            slotName: "A-2",
                            slotId: parkingController.slot2KEY,
                            time: parkingController.slot2.value.parkingHours
                                .toString(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: Obx(
                          () => ParkingSlot(
                            slotId: parkingController.slot3KEY,
                            isBooked: parkingController.slot3.value.booked,
                            isParked: parkingController.slot3.value.isParked,
                            time: parkingController.slot3.value.parkingHours
                                .toString(),
                            slotName: "A-3",
                          ),
                        )),
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child:
                              VerticalDivider(color: Colors.red, thickness: 2),
                        ),
                        Expanded(
                            child: Obx(
                          () => ParkingSlot(
                            slotId: parkingController.slot4KEY,
                            isBooked: parkingController.slot4.value.booked,
                            isParked: parkingController.slot4.value.isParked,
                            slotName: "A-4",
                            time: parkingController.slot4.value.parkingHours
                                .toString(),
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: Obx(
                          () => ParkingSlot(
                            slotId: parkingController.slot5KEY,
                            isBooked: parkingController.slot5.value.booked,
                            isParked: parkingController.slot5.value.isParked,
                            time: parkingController.slot5.value.parkingHours
                                .toString(),
                            slotName: "A-5",
                          ),
                        )),
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child:
                              VerticalDivider(color: Colors.red, thickness: 2),
                        ),
                        Expanded(
                            child: Obx(
                          () => ParkingSlot(
                            slotId: parkingController.slot6KEY,
                            isBooked: parkingController.slot6.value.booked,
                            isParked: parkingController.slot6.value.isParked,
                            slotName: "A-6",
                            time: parkingController.slot6.value.parkingHours
                                .toString(),
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: Obx(
                          () => ParkingSlot(
                            slotId: parkingController.slot7KEY,
                            isBooked: parkingController.slot7.value.booked,
                            isParked: parkingController.slot7.value.isParked,
                            slotName: "A-7",
                            time: parkingController.slot7.value.parkingHours
                                .toString(),
                          ),
                        )),
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child:
                              VerticalDivider(color: Colors.red, thickness: 2),
                        ),
                        Expanded(
                            child: Obx(
                          () => ParkingSlot(
                            slotId: parkingController.slot8KEY,
                            isBooked: parkingController.slot8.value.booked,
                            isParked: parkingController.slot8.value.isParked,
                            slotName: "A-8",
                            time: parkingController.slot8.value.parkingHours
                                .toString(),
                          ),
                        ))
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "EXIT",
                              textAlign: TextAlign.justify,
                            ),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}


// import 'package:flutter/material.dart';

// class Reserve extends StatefulWidget {
//   const Reserve({super.key});

//   @override
//   State<Reserve> createState() => _MyReserve();
// }

// class _MyReserve extends State<Reserve> {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//      body: Container(
//         color: Colors.pink,
//      )
//   );
// }