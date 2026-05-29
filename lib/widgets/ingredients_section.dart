import 'package:flutter/material.dart';
import '../widgets/ingredient_chip.dart';

class IngredientsSection extends StatelessWidget {
  const IngredientsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredients = [
      ('Rasna', '75mg'),
      ('Shudh Shilajeet', '100mg'),
      ('Yograj Guggul', '100mg'),
      ('Kolonji', '12.5mg'),
      ('Ashwagandha', '75mg'),
      ('Jaitun', '12.5mg'),
      ('Jaiphal', '5mg'),
      ('Karnel', '60mg'),
      ('Mitha Suranjan', '50mg'),
      ('Godanti Bhasma', '30mg'),
      ('Mochras', '25mg'),
      ('Arugula', '50mg'),
      ('Sonth', '100mg'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Ingredients',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ingredients
                .map((e) => IngredientChip(name: e.$1, dose: e.$2))
                .toList(),
          ),
        ],
      ),
    );
  }
}
