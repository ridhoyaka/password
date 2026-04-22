import 'package:flutter/material.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Manager',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blue[900],
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade900,
          secondary: Colors.blue.shade700,
        ),
      ),
      home: DashboardPage(),
    );
  }
}