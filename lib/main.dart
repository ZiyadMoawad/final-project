import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/LoginPage.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nrbolqnslftuqyrngdyx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5yYm9scW5zbGZ0dXF5cm5nZHl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY2Mjc4OTksImV4cCI6MjA1MjIwMzg5OX0.2U_qI6NddBpqHK-3j9pEVUuMvQRNGlmTpdtUWmsVawY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), 
    );
  }
}
