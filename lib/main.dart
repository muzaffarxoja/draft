import 'package:calendar_view/calendar_view.dart';
import 'package:draft/material_sidebar.dart';
import 'package:flutter/material.dart';

import 'time_table.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MaterialSidebar(), // Ensure this is your main navigation
    );
  }
}





