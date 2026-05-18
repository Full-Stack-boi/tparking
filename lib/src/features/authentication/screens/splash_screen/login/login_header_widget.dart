import 'package:flutter/material.dart';

import '../../../../../common_widgets/constants/image_stritngs.dart';
import '../../../../../common_widgets/constants/text_string.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: const AssetImage(tWelcomeScreenImage),
          height: size.height * 0.2,
          width: 400,
        ),
        Text(tLoginTitle, style: Theme.of(context).textTheme.displayLarge),
        Text(tLoginSubTitle, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
