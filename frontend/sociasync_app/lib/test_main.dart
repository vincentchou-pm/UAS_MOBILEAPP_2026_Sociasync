import 'package:flutter/material.dart';
import 'package:sociasync_app/screens/auth/login_page.dart';
import 'package:sociasync_app/services/local_notification_service.dart';

// Test version of main that skips notification initialization
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set test mode for notification service
  LocalNotificationService.isTestMode = true;
  // Skip LocalNotificationService.initialize() during tests
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D5093)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
