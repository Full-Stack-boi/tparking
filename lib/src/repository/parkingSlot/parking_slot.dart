

import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tparking/src/common_widgets/constants/colors.dart';
import 'package:tparking/src/common_widgets/constants/text_string.dart';

import '../../features/controllers/parking_controllers.dart';
import '../../features/core/screens/orientation_widget.dart';
import '../../features/core/screens/reserves/booking_page.dart';


class ParkingSlot extends StatelessWidget {
  final bool? isParked;
  final bool? isBooked;
  final String? slotName;
  final String slotId;
  final String time;

  const ParkingSlot({
    super.key,
    this.isParked,
    this.isBooked,
    this.slotName,
    this.slotId = "0.0",
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    String snap = '';
    final Detail = FirebaseDatabase.instance.ref().child(slotId).child('name');
    Detail.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      snap = dataSnapshot.value.toString();
    });
     ParkingController controller = Get.put(ParkingController());
    return DashedContainer(
      dashColor: Colors.blue.shade300,
      dashedLength: 10.0,
      blankLength: 9.0,
      strokeWidth: 1.0,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 180,
        height: 120,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                time == "0.0"
                    ? const SizedBox(width: 1)
                    :  Text(time),
                    // Container(
                    //     child: Text(time),
                    //   ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade100,
                      ),
                      borderRadius: BorderRadius.circular(20)
                      ),
                  child: Text(
                    slotName.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text("")
                // Container(
                //   child: const Text(""),
                // )
              ],
            ),
            const SizedBox(height: 10),
            //if (isParked == true)
            if (isBooked == true && isParked == true)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      shape:const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))) ,
                      backgroundColor:  Colors.white,
                      SafeArea(
                        child: OrientationWidget(portrait: 
                        Column(
                          children: [
                            Container(
                              // alignment: Alignment.center,
                              margin:  const EdgeInsets.only(top: 7.5),
                              height: 8,
                              width: Get.width/3,
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                              ),
                            
                            ),
                            const SizedBox(height: 5),
                            Column(
                              
                              children:[
                                Text('Parked By',style: Theme.of(context).textTheme.headlineLarge?.apply(color: Colors.black54)),
                                const SizedBox(height: 5,),
                                Text("Car License $snap",style: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.black),),
                                // Lottie.asset('assets/animation/Parked_by.json',height: Get.height/2.5),
                                Container(
                                  child:  Lottie.asset('assets/animation/Parked_by.json',height: Get.height/2.5),
                                )
                              ]
                              
                            ),
                      
                                          ],
                                          ), lanscape: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin:  EdgeInsets.only(top: Get.height/60),
                              height: 8,
                              width: Get.width/3,
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                              ),
                            
                            ),
                            // const SizedBox(width: 50),
                            Row(
                              
                              children:[
                                const SizedBox(width: 20,),
                                Text('Parked By',style: Theme.of(context).textTheme.headlineLarge?.apply(color: Colors.black54)),
                                const SizedBox(width: 25,),
                                Text("Car License $snap",style: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.black),),
                                SizedBox(
                                  width: Get.width/2.6,
                                  height: Get.height/2,
                                  child:  Lottie.asset('assets/animation/Parked_by.json'),
                                )
                              ]
                              
                            ),
                      
                                          ],
                                          ),),
                      )
                      
                    );
                  },
                  child: Image.asset("assets/images/icons8-car-100.png"),
                ),
                // child: Material(
                //   type: MaterialType.circle,
                //   color: Colors.transparent,
                //   child: InkWell(
                //     onTap: () {
                      
                //     },
                //     child: Image.asset("assets/images/icons8-car-100.png"),
                //   ),
                // ),
                // child: Image.asset("assets/images/icons8-car-100.png"),
              )
            else if (isBooked == true)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "BOOKED",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (controller.isParked==true) {
                        Get.showSnackbar(const GetSnackBar(title: tAlert, message: "Please Check-Out before Booking",duration: Duration(seconds: 2),));
                        
                      }
                      else{
                        if (controller.isBooked==true) {
                          Get.showSnackbar(const GetSnackBar(title: tAlert, message: "Please Wait Before Booking new one",duration: Duration(seconds: 2),));
                        } else {
                          Get.to(BookingPage(
                        slotId: slotId,
                        slotName: slotName.toString(),
                      )
                     ,transition: Transition.circularReveal,duration: const Duration(milliseconds: 800));
                        }
                          
                      }
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                      decoration: BoxDecoration(
                        color: tPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "BOOK",
                        style: TextStyle(
                          color: tDarkColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
