import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://psblzqtmmqscrdgiithz.supabase.co';
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzYmx6cXRtbXFzY3JkZ2lpdGh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTMxNDMsImV4cCI6MjA0NzEyOTE0M30.Uz_yqb_NRZ0yQ6wzK07aIRT-Ip_3B99knK6v_fwX6mE';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl, 
      anonKey: supabaseKey
    );
  }
}