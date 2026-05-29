import 'package:flutter/material.dart';
import '../theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final int cartQty;
  final VoidCallback onCartPressed;
  final VoidCallback onAdminPressed;
  final VoidCallback onTestDbPressed;

  const AppBarWidget({
    super.key,
    required this.cartQty,
    required this.onCartPressed,
    required this.onAdminPressed,
    required this.onTestDbPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: KaalaTeekaTheme.background,
      title: const Text(
        'AMORA',
        style: TextStyle(
          color: KaalaTeekaTheme.primary,
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: 4,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: onCartPressed,
            ),
            if (cartQty > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: KaalaTeekaTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$cartQty',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        TextButton(
          onPressed: onAdminPressed,
          child: const Text(
            'Admin',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
        TextButton(
          onPressed: onTestDbPressed,
          child: const Text(
            'Test DB',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
