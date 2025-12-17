import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'RutaLog',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tu diario de viajes en carretera',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFD1D5DB),
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'CARGANDO RUTAS...',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                'v1.0.2',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
