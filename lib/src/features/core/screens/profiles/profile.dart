import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';

import '../../../../common_widgets/constants/colors.dart';
import '../../../../common_widgets/constants/image_stritngs.dart';
import '../../../../common_widgets/constants/sizes.dart';
import '../../../../common_widgets/constants/text_string.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../controllers/profile_controllers.dart';
import '../Infometion.dart';
import 'profile_menu_widget.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black26:tPrimaryColor,
        title: Text(tProfile, style: Theme.of(context).textTheme.headlineMedium),
        // actions: [IconButton(onPressed: () {}, icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasData) {
                  UserModel  userData = snapshot.data as UserModel;
                  return Column(
            children: [

              /// -- IMAGE
              Stack(
                children: [
                   SizedBox(
                    width: 120,
                    height: 120,
                    // child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage(tProfileImage))
                    //     ),
                     child: userData.imgaeLink == null|| userData.imgaeLink=='' ? const CircleAvatar(backgroundColor: Colors.transparent,
                         child: Image(image: AssetImage(tProfileImage)
                         )
                        )
                     :CircleAvatar(backgroundColor: Colors.transparent,
                         backgroundImage: NetworkImage(userData.imgaeLink.toString()),
                        ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: tPrimaryColor),
                      child: IconButton(onPressed: () => Get.to(() => const UpdateProfileScreen(),transition: Transition.circularReveal,duration: const Duration(milliseconds: 500)),
                       icon: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                        size: 20,
                      ),
                      ),        
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                userData.fullName, style: Theme.of(context).textTheme.headlineMedium),
              Text(
                userData.email, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfileScreen(),transition: Transition.cupertino),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor, side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text(tEditProfile, style: TextStyle(color: tDarkColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              // const SizedBox(height: 10),

              /// -- MENU
              // ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {}),
              // ProfileMenuWidget(title: "User Management", icon: LineAwesomeIcons.user_check, onPress: () {}),
              ProfileMenuWidget(title: "Information", icon: LineAwesomeIcons.info, onPress: () {Get.to(const Information());}),
               const Divider(),
              // const SizedBox(height: 10),
              // ProfileMenuWidget(title: "Information", icon: LineAwesomeIcons.info, onPress: () {}),
              ProfileMenuWidget(title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.defaultDialog(
                      title: "LOGOUT",
                      titleStyle: const TextStyle(fontSize: 20),
                      content: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Are you sure, you want to Logout?"),
                      ),
                      confirm:
                       ElevatedButton(
                          onPressed: () => AuthenticationRepository.instance.logout(),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                          child: const Text("Yes"),
                        ),
              
                      cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
                    );
                  }),
            ],
          );
                }
              }
              else if (snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()));
                }
                 else{
                  return const Center(child: Text('Sommthing went wrong'));
                 }
                  return const Center(child: CircularProgressIndicator());
                },
          ),
          ),
        ),
        );
        
  }
}