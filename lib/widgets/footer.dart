import 'package:flutter/material.dart';
import '../theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0A0A0A),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: const [
          Text(
            'AMORA Ayurvedic Wellness',
            style: TextStyle(
              color: KaalaTeekaTheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Plot No. 294B, 1st Floor, E Boring Canal Rd,\nSri Krishna Nagar, Kidwaipuri Patna, Bihar 800001',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.5),
          ),
          SizedBox(height: 8),
          Text(
            'Manufactured by: C.A. Pharmacy Pvt. Ltd, Indore, MP',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          SizedBox(height: 8),
          Text(
            'support@amora.health  |  Ph: 75620 40204',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          SizedBox(height: 16),
          Text(
            '© 2024 Amora. All rights reserved.',
            style: TextStyle(color: Colors.white24, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
