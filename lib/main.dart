import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'view/splash_screen_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//-------โค๊ดสำหรับrunแอพพลิเคชั่น Supabase โปรเจคที่เราทำงานไว้-------//
  await Supabase.initialize(
    url: 'https://eethlcbaheoigziysdwi.supabase.co', // Replace with your Supabase URL
    publishableKey: 'sb_publishable_RakrTjabUsIMgxPTZ9IVtA_1RUJlOAT', // Replace with your Supabase anon key
  );
//-----------------------------------------------------------------//

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
