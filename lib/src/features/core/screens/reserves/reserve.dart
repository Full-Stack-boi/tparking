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
    ParkingController parkingController = Get.find<ParkingController>();
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: isDark ? tSecondaryColor : tPrimaryColor,
            elevation: 3.0,
            shadowColor: isDark ? Colors.black54 : Colors.black12,
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
                    const SizedBox(height: 10),
                    ...parkingController.groupedFilteredParkingSlots.entries.map((entry) {
                      final floorName = entry.key;
                      final floorSlots = entry.value;

                      return Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(
                            floorName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                          children: [
                            ...List.generate(
                              (floorSlots.length / 2).ceil(),
                              (index) {
                                final leftIndex = index * 2;
                                final rightIndex = leftIndex + 1;

                                final leftSlot = floorSlots[leftIndex];
                                final rightSlot = rightIndex < floorSlots.length
                                    ? floorSlots[rightIndex]
                                    : null;

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ParkingSlot(
                                            isBooked: leftSlot.booked ?? false,
                                            isParked: leftSlot.isParked ?? false,
                                            slotName: leftSlot.slotName ?? "",
                                            slotId: leftSlot.id ?? "",
                                            time: leftSlot.parkingHours?.toString() ?? "0.0",
                                            parkedTo: leftSlot.parkedTo,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: VerticalDivider(
                                              color: Colors.red, thickness: 2),
                                        ),
                                        Expanded(
                                          child: rightSlot != null
                                              ? ParkingSlot(
                                                  isBooked: rightSlot.booked ?? false,
                                                  isParked: rightSlot.isParked ?? false,
                                                  slotName: rightSlot.slotName ?? "",
                                                  slotId: rightSlot.id ?? "",
                                                  time: rightSlot.parkingHours?.toString() ?? "0.0",
                                                  parkedTo: rightSlot.parkedTo,
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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