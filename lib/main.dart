import 'package:flutter/material.dart';
import 'package:latihan_ukk/MyHomePage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://psblzqtmmqscrdgiithz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzYmx6cXRtbXFzY3JkZ2lpdGh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTMxNDMsImV4cCI6MjA0NzEyOTE0M30.Uz_yqb_NRZ0yQ6wzK07aIRT-Ip_3B99knK6v_fwX6mE' 
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Myhomepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
