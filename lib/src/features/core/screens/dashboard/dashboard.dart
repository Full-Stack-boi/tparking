import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tparking/src/common_widgets/constants/colors.dart';

import '../homepage.dart';
import '../car_registion.dart';
import '../profiles/profile.dart';
import '../reserves/reserve.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _MyDashboard();
}

class _MyDashboard extends State<Dashboard> {
  
  // Pages
  List pages = [
    const Homepage(),
    const Reserve(),
    const CarRegistion(),
    const ProfileScreen()
  ];
  //Pages


  // ignore: non_constant_identifier_names
  int Pages_currentIndex = 0;
  void onTap(int index){
    setState(() {
       Pages_currentIndex = index; 
       
    });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder:(child, primaryAnimation, secondaryAnimation)
         => FadeThroughTransition(
        animation: primaryAnimation,
        secondaryAnimation: secondaryAnimation,
        child: child),
        child: pages[Pages_currentIndex],) 
      ,
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: tWhiteColor,
        onTap: onTap,
        currentIndex: Pages_currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          SalomonBottomBarItem(
            title: const Text("Home") ,
            icon: const Icon(Icons.home)
            ),
          SalomonBottomBarItem(
            title: const Text("Reserve"),
            icon: const Icon(Icons.car_rental),
            selectedColor: Colors.blueAccent
            ),
          SalomonBottomBarItem(
            title: const Text("Registion"),
            icon: const Icon(Icons.pageview)
            ),
          SalomonBottomBarItem(
            title: const Text("Profile"),
            icon: const Icon(Icons.person),
            selectedColor: Colors.red
            ),
        ]
        ),
    );
  }
}

 