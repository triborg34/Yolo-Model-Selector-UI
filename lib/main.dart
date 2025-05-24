import 'package:cvui/utils/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Model Switcher",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: MyBinding(),
      getPages: pages,
      initialRoute: '/',
      themeMode: ThemeMode.dark,
      
    );
  }
}