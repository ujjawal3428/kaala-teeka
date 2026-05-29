import 'package:flutter/material.dart';
import '../theme.dart';

class OrderForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController stateCtrl;
  final TextEditingController pincodeCtrl;
  final int orderQty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Future<void> Function()? onSubmit;

  const OrderForm({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.pincodeCtrl,
    required this.orderQty,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    const double pricePerUnit = 299.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KaalaTeekaTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KaalaTeekaTheme.primary, width: 1),
      ),
      child: Form(
        key: formKey,
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
            _buildField(nameCtrl, 'Full Name', Icons.person_outline),
            const SizedBox(height: 12),
            _buildField(
              phoneCtrl,
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
              addressCtrl,
              'Full Address',
              Icons.home_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    cityCtrl,
                    'City',
                    Icons.location_city_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildField(stateCtrl, 'State', Icons.map_outlined),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildField(
              pincodeCtrl,
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
            Row(
              children: [
                const Text(
                  'Quantity:',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Spacer(),
                _qtyButton(Icons.remove, onDecrement),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$orderQty',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _qtyButton(Icons.add, onIncrement),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KaalaTeekaTheme.background,
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
                    '₹${(orderQty * pricePerUnit).toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: KaalaTeekaTheme.primary,
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
                onPressed: () async => await onSubmit?.call(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KaalaTeekaTheme.primary,
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
        fillColor: KaalaTeekaTheme.background,
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
          borderSide: const BorderSide(color: KaalaTeekaTheme.primary),
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
          color: KaalaTeekaTheme.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
