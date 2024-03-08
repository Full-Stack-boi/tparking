import 'package:flutter/material.dart';

class OrientationWidget extends StatelessWidget {
  const OrientationWidget({
    super.key,
    required this.portrait,
    required this.lanscape,
  });

  final Widget portrait;
  final Widget lanscape;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait ? portrait : lanscape;
      },
    );
  }
}
