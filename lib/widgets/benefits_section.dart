import 'package:flutter/material.dart';
import '../widgets/benefit_card.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Why Kaala Teeka?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          BenefitCard(
            icon: Icons.speed,
            title: 'Rapid Relief',
            desc: 'Works fast to ease muscle & joint pain.',
          ),
          BenefitCard(
            icon: Icons.nature,
            title: '100% Herbal',
            desc: 'Made from trusted Ayurvedic ingredients.',
          ),
          BenefitCard(
            icon: Icons.shield_outlined,
            title: 'Safe Long-Term',
            desc: 'No side effects, suitable for regular use.',
          ),
          BenefitCard(
            icon: Icons.verified,
            title: 'Clinically Trusted',
            desc: 'Manufactured by C.A. Pharmacy Pvt. Ltd, Indore.',
          ),
        ],
      ),
    );
  }
}
