import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaala_teeka_app/screens/cart_page.dart';
import '../models/order_model.dart';
import '../models/order_store.dart';
import '../services/firebase_service.dart' as firebase;
import '../theme.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/product_info.dart';
import '../widgets/ingredients_section.dart';
import '../widgets/benefits_section.dart';
import '../widgets/how_to_use.dart';
import '../widgets/order_form.dart';
import '../widgets/footer.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // ── Cart state ──────────────────────────────────────────────
  int _cartQty = 0;
  static const double _pricePerUnit = 299.0;

  // ── Order form controllers ───────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  int _orderQty = 1;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  void _addToCart() {
    setState(() => _cartQty++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to cart!'),
        backgroundColor: const Color(0xFFB03A2E),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ── Test Firestore ──────────────────────────────────────────
  Future<void> _testFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('test_users').add({
        'name': 'Ujjawal',
        'age': 21,
        'timestamp': DateTime.now(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Firestore test successful! Data sent.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Firestore error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final order = OrderModel(
      id: 'KT-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      pincode: _pincodeCtrl.text.trim(),
      quantity: _orderQty,
      totalAmount: _orderQty * _pricePerUnit,
      orderDate: DateTime.now(),
    );

    try {
      // Debug: Log order before saving
      print('🔷 Saving order to Firebase: ${order.id}');

      // Save order to Firebase
      await firebase.FirebaseService.instance.saveOrder(order);
      print('✅ Order saved to Firebase successfully!');

      // Also save to local store
      OrderStore.instance.addOrder(order);
      print('✅ Order saved to local store');

      // Reset form
      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _phoneCtrl.clear();
      _addressCtrl.clear();
      _cityCtrl.clear();
      _stateCtrl.clear();
      _pincodeCtrl.clear();
      setState(() {
        _cartQty = 0;
        _orderQty = 1;
      });
      print('✅ Form cleared');

      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Order Placed! 🎉',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Order ID: ${order.id}\nAmount: ₹${order.totalAmount.toStringAsFixed(0)}\n\nWe will call you shortly to confirm.',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFB03A2E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );

      // Show snackbar confirmation
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Order placed successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('❌ Error placing order: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaalaTeekaTheme.background,
      appBar: AppBarWidget(
        cartQty: _cartQty,
        onCartPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        onAdminPressed: () => Navigator.pushNamed(context, '/admin'),
        onTestDbPressed: _testFirestore,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(
              onAddToCart: _addToCart,
              onOrderNow: () {
                Scrollable.ensureVisible(
                  _formKey.currentContext ?? context,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
            const ProductInfo(),
            const IngredientsSection(),
            const BenefitsSection(),
            const HowToUse(),
            OrderForm(
              formKey: _formKey,
              nameCtrl: _nameCtrl,
              phoneCtrl: _phoneCtrl,
              addressCtrl: _addressCtrl,
              cityCtrl: _cityCtrl,
              stateCtrl: _stateCtrl,
              pincodeCtrl: _pincodeCtrl,
              orderQty: _orderQty,
              onIncrement: () => setState(() => _orderQty++),
              onDecrement: () {
                if (_orderQty > 1) setState(() => _orderQty--);
              },
              onSubmit: _placeOrder,
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
