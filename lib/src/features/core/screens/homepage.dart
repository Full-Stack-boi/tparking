import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

//import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../common_widgets/constants/colors.dart';
import '../../controllers/parking_controllers.dart';
import '../controllers/car_register_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

// ignore: non_constant_identifier_names
bool _VIsible = false;

class _HomepageState extends State<Homepage> {
  Location location = Location();
  double? distance;
  double tnilag = 100.6284;
  double tnilat = 13.7380;
  late double lat1, lng1;
  final nowTimes = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    location.onLocationChanged.listen((event) {
      lng1 = event.longitude!;
      lat1 = event.latitude!;
    });

    double calculateDistance(
        double lat1, double lng1, double tnilat, double tnilag) {
      double distance = 0;

      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((tnilat - lat1) * p) / 2 +
          c(lat1 * p) * c(tnilat * p) * (1 - c((tnilag - lng1) * p)) / 2;
      distance = 12742 * asin(sqrt(a));

      return distance;
    }

    late ParkingController parkingController = Get.put(ParkingController());

    // ignore: non_constant_identifier_names
    void ResetParked() {
      parkingController.parkUpdate(parkingController.slot1KEY);
      parkingController.parkUpdate(parkingController.slot2KEY);
      parkingController.parkUpdate(parkingController.slot3KEY);
      parkingController.parkUpdate(parkingController.slot4KEY);
      parkingController.parkUpdate(parkingController.slot5KEY);
      parkingController.parkUpdate(parkingController.slot6KEY);
      parkingController.parkUpdate(parkingController.slot7KEY);
      parkingController.parkUpdate(parkingController.slot8KEY);
    }

    if (nowTimes.hour > 19 || nowTimes.hour < 5) {
      ResetParked();
    }

    /// มากทำต่อ
    if (parkingController.isBooked == false) {
      _VIsible = false;
    }
    if (parkingController.isBooked == true) {
      _VIsible = true;
    }

    /// มาทำต่อ
    parkingController.isBooked ??= false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black26 : tPrimaryColor,
        title: Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30.4,
                    ),
                    CircularCountDownTimer(
                      width: 100,
                      height: 100,
                      duration: parkingController.parkingHours.value.toInt(),
                      fillColor: Colors.red,
                      ringColor: Colors.amber,
                      autoStart: parkingController.isBooked,
                      textStyle: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Check-In Your Parking',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Visibility(
                      visible: _VIsible,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        child: SizedBox(
                            height: 50,
                            width: 300,
                            child: FilledButton(
                                onPressed: () {
                                  setState(() {
                                    distance = calculateDistance(
                                        lat1, lng1, tnilat, tnilag);
                                  });
                                  if (distance! <= 0.15) {
                                    SharedPreference.SetParking_id(
                                            parkingController.slotIdPraked)
                                        .toString();
                                    parkingController.checkoutupdate(
                                        SharedPreference.getID());
                                    setState(() {
                                      _VIsible = _VIsible;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: Text("You has Check-in",
                                                textScaleFactor: 1.5),
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: Text("You Didn't in TNI.",
                                                textScaleFactor: 1.5),
                                          );
                                        });
                                  }

                                  // if ( distance> 2.0) {
                                  //   timer = Timer(Duration(seconds: 10), () =>
                                  //   parkingController.parkUpdate(parkingController.checkslotId));

                                  // } else {
                                  //   timer.cancel();
                                  // }

                                  //Get.off(Dashboard());
                                },
                                child: const Text('CHECK-IN'))),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: true,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        child: SizedBox(
                            height: 50,
                            width: 300,
                            child: FilledButton(
                                onPressed: () {
                                  if (SharedPreference.getID() == null) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: Text("You Didn't Parked",
                                                textScaleFactor: 1.5),
                                          );
                                        });
                                  } else {
                                    parkingController
                                        .parkUpdate(SharedPreference.getID());
                                    SharedPreference.ParkIDdelete();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: Text("You has CHECK-OUT",
                                                textScaleFactor: 1.5),
                                          );
                                        });
                                  }

                                  //AuthenticationRepository.instance.logout();
                                },
                                child:
                                    // Text(CarRegistions.getID().toString())))
                                    const Text('CHECK-OUT'))),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

// return Scaffold (
//   appBar: AppBar(
//    title:  Text('Data',style: Theme.of(context).textTheme.headlineMedium,),
//    centerTitle: true,
//    elevation: 1,
//    backgroundColor: isDark?  Colors.black12 : Colors.amber ,

//   ),
//   body: SingleChildScrollView(
//   child: Column(children: [
//     Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//       Container(
//       width: 100,
//       height: 100,
//       margin: EdgeInsets.only(top: 60),
//       child: Center(
//         child: CircularCountDownTimer(
//           width: 100,
//           height: 100,
//            duration: parkingController.parkingHours.value.toInt(),
//             fillColor: Colors.red,
//              ringColor: Colors.amber,
//              autoStart: parkingController.isBooked,
//              textStyle: const TextStyle(
//               fontSize: 40
//               ),
//              ),
//       ),
//     ),
//       ],
//     ),
//     SizedBox(height: 50,),
//     Row(children: [
//       Center(
//       child: Container(
//         margin: EdgeInsets.only(left: 190),
//         child: Column(children: [],),
//       ),
//     )],
//     )

//   ],)
// ),
// );
//}
//}
