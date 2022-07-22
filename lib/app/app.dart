import 'package:flutter/material.dart';
import 'package:in_app_purchase_flutter/app/features/home/page/home.page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter in-app-purchase',
      home: HomePage(),
    );
  }
}
