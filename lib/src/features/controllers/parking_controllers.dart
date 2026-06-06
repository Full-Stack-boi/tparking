import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tparking/src/features/core/controllers/car_register_list.dart';
import 'package:tparking/src/features/core/screens/dashboard/dashboard.dart';
//import '../config/colors.dart';
import '../models/car_model.dart';
import 'notification_local.dart';

class ParkingController extends GetxController {
  final fb = FirebaseDatabase.instance;
  var parkingHours = 10.0.obs;
  var selectedBuilding = "A Building".obs;
  TextEditingController name = TextEditingController();
  var slot1Time = "".obs;
  var slot2Time = "".obs;
  var slot3Time = "".obs;
  var slot4Time = "".obs;
  var slot5Time = "".obs;
  var slot6Time = "".obs;
  var slot7Time = "".obs;
  var slot8Time = "".obs;
  var slot1KEY = "-NRdY57houxuL83j7cok";
  var slot2KEY = "-NRdYRojJXhw3_aixhnM";
  var slot3KEY = "-NRdYTO7yp_MbMxjhic3";
  var slot4KEY = "-NRdYWXOcd8oWymDLroj";
  var slot5KEY = "-NRh9RiMNakdmIi6fZUv";
  var slot6KEY = "-NRh9UdC92OokxV__NlW";
  var slot7KEY = "-NRhCKffU8n0q23MErf5";
  var slot8KEY = "-NRhCR1Szb2a59nUtcfs";
  var slot1 = CarModel().obs;
  var slot2 = CarModel().obs;
  var slot3 = CarModel().obs;
  var slot4 = CarModel().obs;
  var slot5 = CarModel().obs;
  var slot6 = CarModel().obs;
  var slot7 = CarModel().obs;
  var slot8 = CarModel().obs;
  final isBooked = false.obs;
  late String slotIdPraked = '';
  late String checkslotId = '';
  final isParked = false.obs;

  final List<StreamSubscription> _subscriptions = [];

  @override
  void onInit() {
    super.onInit();
    isParked.value = SharedPreference.getID() != null;
    getData();
  }

  @override
  void onClose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    name.dispose();
    super.onClose();
  }

  void updateData(slotId) async {
    await fb.ref().child(slotId).update(
      {
        "name": name.text,
        "parkingHours": parkingHours.toString(),
        //    "paymentDone": true,
        "booked": true,
      },
    );
    slotIdPraked = slotId;
    isBooked.value = true;
    if (kDebugMode) {
      print("Data Updated");
    }
    Get.defaultDialog(
        barrierDismissible: false,
        title: "SLOT BOOKED",
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        content: Column(
          children: [
            Lottie.asset(
              'assets/animation/sloting_done.json',
              width: 100,
              height: 100,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Slot Booked",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(const Dashboard(),
                    transition: Transition.circularReveal);
              },
              child: const Text("Close"),
            )
          ],
        ));

    if (slotId == slot1KEY) {
      startSlotTimer(slot1KEY, slot1);
    } else if (slotId == slot2KEY) {
      startSlotTimer(slot2KEY, slot2);
    } else if (slotId == slot3KEY) {
      startSlotTimer(slot3KEY, slot3);
    } else if (slotId == slot4KEY) {
      startSlotTimer(slot4KEY, slot4);
    } else if (slotId == slot5KEY) {
      startSlotTimer(slot5KEY, slot5);
    } else if (slotId == slot6KEY) {
      startSlotTimer(slot6KEY, slot6);
    } else if (slotId == slot7KEY) {
      startSlotTimer(slot7KEY, slot7);
    } else {
      startSlotTimer(slot8KEY, slot8);
    }
    slotIdPraked = slotId;
    checkslotId = slotIdPraked;
  }

  checkoutupdate(slotIdPraked) async {
    await fb.ref().child(slotIdPraked).update(
      {
        "isParked": true,
        "parkingHours": 0.0.toString(),
      },
    );
    isParked.value = true;
  }

  parkUpdate(checkslotId) async {
    await fb.ref().child(checkslotId).update(
      {"isParked": false, "booked": false, "name": ""},
    );
    isParked.value = false;
  }

  void getData() {
    if (_subscriptions.isNotEmpty) return;

    _subscriptions.add(fb.ref().child(slot1KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot1.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
    _subscriptions.add(fb.ref().child(slot2KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot2.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
    _subscriptions.add(fb.ref().child(slot3KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot3.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
    _subscriptions.add(fb.ref().child(slot4KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot4.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
    _subscriptions.add(fb.ref().child(slot5KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot5.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
    _subscriptions.add(fb.ref().child(slot6KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot6.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
    _subscriptions.add(fb.ref().child(slot7KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot7.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
    _subscriptions.add(fb.ref().child(slot8KEY).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      slot8.value = CarModel.fromJson(
        json.decode(
          json.encode(dataSnapshot.value),
        ),
      );
    }));
  }

  void addCar(CarModel car) {
    fb.ref().push().set(car.toJson());
  }

  void startSlotTimer(String slotKey, Rx<CarModel> slotObs) async {
    double time = double.parse(slotObs.value.parkingHours.toString());

    while (time != 0) {
      await Future.delayed(const Duration(seconds: 1)); // for testing
      //await Future.delayed(Duration(minutes: 1)); ---> use for publicshed
      time--;
      await fb.ref().child(slotKey).update(
        {
          "parkingHours": time.toString(),
        },
      );
    }

    if (isParked.value == false) {
      await fb.ref().child(slotKey).update(
        {"booked": false, "isParked": false, "name": ""},
      );
      NotificationLocal().scheduleNotification(
          title: 'Alert', body: 'Your slot has been cancel');
    }

    isBooked.value = false;
  }
}
