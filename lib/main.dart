import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/database_helper.dart';
import 'providers/product_provider.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await DatabaseHelper.instance.db;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Barcode App',
        home: const MainScreen(),
      ),
    );
  }
}
