import 'package:flutter/material.dart';

import 'view/splash_screen_ui.dart';

void main() {
  runApp(const Runtwickerapp());
}

class Runtwickerapp extends StatelessWidget {
  const Runtwickerapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUI(),
    );
  }
}
