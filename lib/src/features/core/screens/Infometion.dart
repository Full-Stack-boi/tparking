import 'package:flutter/material.dart';

import '../../../common_widgets/constants/colors.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: isDark ? Colors.black26 : tPrimaryColor,
        title: Text('Infometion',
            style: Theme.of(context).textTheme.headlineMedium),
        // actions: [IconButton(onPressed: () {}, icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text('Developer Team',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(
              height: 5,
            ),
            Text('Team 7 ', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(
              height: 5,
            ),
            Text('Develop By ',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 5,
            ),
            Text('Nattawut Bupoo',
                style: Theme.of(context).textTheme.headlineSmall)
          ],
        ),
      ),
    );
  }
}
