import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/landing_page.dart';
import 'screens/admin_dashboard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const KaalaTeekaApp());
}

class KaalaTeekaApp extends StatelessWidget {
  const KaalaTeekaApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaala Teeka – Amora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB03A2E),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/admin': (context) => const AdminDashboard(),
      },
    );
  }
}
