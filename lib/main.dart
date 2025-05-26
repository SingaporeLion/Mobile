import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solana_flutter/controllers/appController.dart';
import 'package:solana_flutter/ui/screens/homeScreen.dart';
import 'package:solana_flutter/ui/screens/nftsScreen.dart';
import 'package:solana_flutter/ui/screens/profile.dart';
import 'package:solana_flutter/ui/screens/splashScreen.dart';
import 'package:solana_flutter/ui/screens/swap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppController appController = Get.put(AppController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: StartingPage(),
    );
  }
}
