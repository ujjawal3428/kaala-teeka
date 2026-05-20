import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String name;
  final String dose;

  const IngredientChip({super.key, required this.name, required this.dose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: name,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            TextSpan(
              text: '  $dose',
              style: const TextStyle(
                  color: Color(0xFFB03A2E),
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}