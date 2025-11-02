import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/auth_provider.dart';
import 'services/local_db_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'models/topup_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Hive.initFlutter();

  
  Hive.registerAdapter(TopUpRecordAdapter());

  
  await Hive.openBox(LocalDbService.USER_REGISTRATION_BOX);
  await Hive.openBox<TopUpRecord>('topup_history');

  
  final prefs = await SharedPreferences.getInstance();
  final storedUser = prefs.getString('logged_in_user');

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(storedUser),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Akhir App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          
          return auth.isLoggedIn
              ? const DashboardScreen()
              : const LoginScreen();
        },
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
