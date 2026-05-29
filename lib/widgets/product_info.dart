import 'package:flutter/material.dart';
import '../theme.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About the Product', style: KaalaTeekaTheme.heading2),
          const SizedBox(height: 12),
          Text(
            'Kaala Teeka is an Ayurvedic herbal tablet by Amora that provides rapid relief from muscle and joint pain. '
            'Crafted from time-tested herbs, it is safe for long-term use with no known side effects.',
            style: KaalaTeekaTheme.paragraph,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoTile(Icons.eco, 'Herbal'),
              _infoTile(Icons.verified_outlined, 'Ayurvedic'),
              _infoTile(Icons.thumb_up_outlined, 'No Side Effects'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: KaalaTeekaTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: KaalaTeekaTheme.muted),
        ),
        child: Column(
          children: [
            Icon(icon, color: KaalaTeekaTheme.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
