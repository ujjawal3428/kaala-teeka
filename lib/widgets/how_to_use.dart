import 'package:flutter/material.dart';

class HowToUse extends StatelessWidget {
  const HowToUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'How to Use',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '1. Take 1 tablet.\n2. Crush it well into a fine powder.\n3. Put the powdered medicine in your mouth and drink water.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.8),
          ),
          SizedBox(height: 16),
          Text(
            'Contra-Indications',
            style: TextStyle(
              color: Color(0xFFB03A2E),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Not recommended for pregnant women and people with high acidity. Consult your physician if you have pre-existing medical conditions or are on other medication.',
            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}
