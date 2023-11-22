import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tparking/src/common_widgets/constants/colors.dart';
import 'package:tparking/src/features/core/screens/reserves/car_register_list.dart';



import '../../../../common_widgets/constants/text_string.dart';
import '../../../authentication/models/user_model.dart';
import '../../../controllers/parking_controllers.dart';
import '../../controllers/profile_controllers.dart';



class BookingPage extends StatefulWidget {
  final String slotName;
  final String slotId;
  const BookingPage({super.key, required this.slotId, required this.slotName});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

//   List<String> carRegister =[
//   "กค6969","AABBCC",
// ];


class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    ParkingController parkingController = Get.put(ParkingController());
    final nowTimes = DateTime.now();
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tPrimaryColor,
        title: const Text(
          "BOOK SLOT",
          style: TextStyle(
            color: tDarkColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(
          color: tDarkColor,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future : controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;
                  
                  return  Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animation/running_car.json',
                    width: 300,
                    height: 200,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    "Book Now 😊",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: tPrimaryColor,
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Text(
                    "Select Car registration ",
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: 
                    DropdownSearch<String>(
                      selectedItem: '',
    popupProps:  const PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: true,
        isFilterOnline: true,
        // constraints: BoxConstraints(maxHeight:200),
        fit: FlexFit.loose
        
    ),
    items:  carRegister,
    dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            labelText: "Car Registration",
            hintText: "Select Car Registration",
        ),
    ),
    onChanged: (value) {
      
        parkingController.name.text = value!;
      
                       },
                     
    
)//TextFormField(
                    //   decoration: const InputDecoration(
                    //     fillColor: Colors.black26,
                    //     filled: true,
                    //     border: InputBorder.none,
                    //     prefixIcon: Icon(
                    //       Icons.person,
                    //       color: Colors.white,
                    //     ),
                    //     hintText: "Your Car registration number",
                    //  onChanged: (value) {
                    //      parkingController.name.text = value!;
                    //    },
                    //   ),
                    //   
                    // ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    "Choose Slot Time (in Minuits)",
                  )
                ],
              ),
              const SizedBox(height: 10),
              Obx(
                () =>
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorColor: Colors.blueGrey, //value colors
 
                  ),child: Slider(
                  thumbColor: tPrimaryColor,
                  activeColor: tAccentColor,
                  inactiveColor: lightBg,
                  label: parkingController.parkingHours.value.toString(),
                  value: parkingController.parkingHours.value,
                  onChanged: (v) {
                    parkingController.parkingHours.value = v;
                  },
                  divisions: 2,
                  min: 10,
                  max: 30,
                ),
              ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("10"),
                    Text("20"),
                    Text("30"),
                    // Text("40"),
                    // Text("50"),
                    // Text("60"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Slot Name",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: tDarkColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        widget.slotName,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 55,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (parkingController.name.text == "") {
                        Get.showSnackbar(const GetSnackBar(title: tError,
                         message: "Please Select Your Car Registration",
                         duration: Duration(seconds: 2),));
                      } 
                       else {
                        if (user.roles == 'Student' && nowTimes.hour<=14) {
                        Get.showSnackbar(const GetSnackBar(title: tAlert,
                         message: "Please wait until 15.00 pm",
                         duration: Duration(seconds: 2),));
                      }else {
                        if (nowTimes.hour>19||nowTimes.hour<5) {
                          Get.showSnackbar(const GetSnackBar(title: tAlert,
                         message: "Please wait until 5.00 am",
                         duration: Duration(seconds: 2),
                         )
                         );
                        }else{
                          parkingController.updateData(widget.slotId);
                          parkingController.name.text = '';
                        }
                          
                        }
                        
                        
                      }
                      
                      
                      //NotificationLocal().showNotification(title: 'Time',body: 'asdasd');
                      //parkingController.slotIdPraked.toString()  ==  slotId;
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: const Text(
                        "BOOK NOW",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
                }
                else if (snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()));
                } else{
                  return const Center(child: Text('Sommthing went wrong'));
                 }
              }  else{
                  return const Center(child: CircularProgressIndicator());
                }
              }
        ),
        ),
      )),
    );
    
  }
}
