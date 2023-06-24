import 'package:flutter/material.dart';
import 'package:websitepp/pages/draggable.dart';
import 'package:websitepp/utils/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
      ),
      home: Drag(),
    );
  }
}
