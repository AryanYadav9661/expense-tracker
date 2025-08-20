import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firebase_service.dart';
import 'providers/expense_provider.dart';
import 'screens/home_screen.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AdService.init();
  final fs = FirebaseService();
  runApp(MyApp(firebaseService: fs));
}

class MyApp extends StatelessWidget {
  final FirebaseService firebaseService;
  const MyApp({super.key, required this.firebaseService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider(firebaseService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker Plus',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
