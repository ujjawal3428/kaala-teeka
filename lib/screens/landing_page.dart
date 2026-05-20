import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/order_store.dart';
import '../widgets/ingredient_chip.dart';
import '../widgets/benefit_card.dart';

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

  void _placeOrder() {
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

    OrderStore.instance.addOrder(order);

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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Order Placed! 🎉',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Order ID: ${order.id}\nAmount: ₹${order.totalAmount.toStringAsFixed(0)}\n\nWe will call you shortly to confirm.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFB03A2E))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(),
            _buildProductInfo(),
            _buildIngredients(),
            _buildBenefits(),
            _buildHowToUse(),
            _buildOrderForm(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ── App Bar ─────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D0D0D),
      title: const Text(
        'AMORA',
        style: TextStyle(
          color: Color(0xFFB03A2E),
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: 4,
        ),
      ),
      actions: [
        // Cart icon
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                if (_cartQty > 0) {
                  // scroll to order form
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$_cartQty item(s) in cart. Fill the form below to order.',
                      ),
                      backgroundColor: const Color(0xFFB03A2E),
                    ),
                  );
                }
              },
            ),
            if (_cartQty > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFB03A2E),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$_cartQty',
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
        // Admin shortcut
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/admin'),
          child: const Text(
            'Admin',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
        // Firestore test button
        TextButton(
          onPressed: _testFirestore,
          child: const Text(
            'Test DB',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // ── Hero Section ─────────────────────────────────────────────
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0A08), Color(0xFF0D0D0D)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          // Product jar image
          Container(
            width: 200,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB03A2E), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/photo1.jpg', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Kaala Teeka',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFB03A2E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Rapid Comfort for Muscles & Joints',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'दर्द को लगाओ काला टीका',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ayurvedic Medicine | Herbal | No Side Effects',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 24),
          // Price + Add to Cart
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '₹299',
                style: TextStyle(
                  color: Color(0xFFB03A2E),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '/ 30 tablets',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB03A2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  // Scroll to order form
                  Scrollable.ensureVisible(
                    _formKey.currentContext ?? context,
                    duration: const Duration(milliseconds: 500),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Order Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Product Info ─────────────────────────────────────────────
  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About the Product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Kaala Teeka is an Ayurvedic herbal tablet by Amora that provides rapid relief from muscle and joint pain. '
            'Crafted from time-tested herbs, it is safe for long-term use with no known side effects.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
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
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFB03A2E), size: 22),
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

  // ── Ingredients ──────────────────────────────────────────────
  Widget _buildIngredients() {
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

  // ── Benefits ─────────────────────────────────────────────────
  Widget _buildBenefits() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Kaala Teeka?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
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

  // ── How to Use ───────────────────────────────────────────────
  Widget _buildHowToUse() {
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
        children: [
          const Text(
            'How to Use',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '1. Take 1 tablet.\n'
            '2. Crush it well into a fine powder.\n'
            '3. Put the powdered medicine in your mouth and drink water.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.8),
          ),
          const SizedBox(height: 16),
          const Text(
            'Contra-Indications',
            style: TextStyle(
              color: Color(0xFFB03A2E),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Not recommended for pregnant women and people with high acidity. '
            'Consult your physician if you have pre-existing medical conditions or are on other medication.',
            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ── Order Form ───────────────────────────────────────────────
  Widget _buildOrderForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB03A2E), width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Place Your Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Free delivery across India',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 20),

            _buildField(_nameCtrl, 'Full Name', Icons.person_outline),
            const SizedBox(height: 12),
            _buildField(
              _phoneCtrl,
              'Phone Number',
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.trim().length != 10) return 'Enter valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildField(
              _addressCtrl,
              'Full Address',
              Icons.home_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    _cityCtrl,
                    'City',
                    Icons.location_city_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildField(_stateCtrl, 'State', Icons.map_outlined),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildField(
              _pincodeCtrl,
              'Pincode',
              Icons.pin_drop_outlined,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.trim().length != 6) return 'Enter valid 6-digit pincode';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Quantity
            Row(
              children: [
                const Text(
                  'Quantity:',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Spacer(),
                _qtyButton(Icons.remove, () {
                  if (_orderQty > 1) setState(() => _orderQty--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$_orderQty',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _qtyButton(Icons.add, () => setState(() => _orderQty++)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    '₹${(_orderQty * _pricePerUnit).toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFFB03A2E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB03A2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Confirm Order – Cash on Delivery'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        filled: true,
        fillColor: const Color(0xFF0D0D0D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB03A2E)),
        ),
        errorStyle: const TextStyle(color: Color(0xFFE74C3C)),
      ),
      validator:
          validator ??
          (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFB03A2E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  // ── Footer ───────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0A0A0A),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'AMORA Ayurvedic Wellness',
            style: TextStyle(
              color: Color(0xFFB03A2E),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Plot No. 294B, 1st Floor, E Boring Canal Rd,\nSri Krishna Nagar, Kidwaipuri Patna, Bihar 800001',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manufactured by: C.A. Pharmacy Pvt. Ltd, Indore, MP',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 8),
          const Text(
            'support@amora.health  |  Ph: 75620 40204',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2024 Amora. All rights reserved.',
            style: TextStyle(color: Colors.white24, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
