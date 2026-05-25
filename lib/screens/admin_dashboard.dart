import 'package:flutter/material.dart';
import '../models/order_store.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: FirebaseService.instance.streamOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFB03A2E)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading orders: ${snapshot.error}',
                style: const TextStyle(color: Colors.white54),
              ),
            );
          }

          final orders = snapshot.data ?? [];
          final filteredOrders = _filterStatus == 'all'
              ? orders
              : orders.where((o) => o.status == _filterStatus).toList();

          return Column(
            children: [
              _buildStats(orders),
              _buildFilters(),
              Expanded(child: _buildOrderList(filteredOrders)),
            ],
          );
        },
      ),
    );
  }

  // ── Summary Stats ────────────────────────────────────────────
  Widget _buildStats(List<OrderModel> orders) {
    double totalRevenue = 0;
    Map<String, int> ordersByCity = {};

    for (final order in orders) {
      totalRevenue += order.totalAmount;
      ordersByCity[order.city] = (ordersByCity[order.city] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _statCard('Total Orders', '${orders.length}', Icons.receipt_long),
          const SizedBox(width: 10),
          _statCard(
            'Revenue',
            '₹${totalRevenue.toStringAsFixed(0)}',
            Icons.currency_rupee,
          ),
          const SizedBox(width: 10),
          _statCard(
            'Cities',
            '${ordersByCity.length}',
            Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFB03A2E), size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // ── Status Filter Tabs ───────────────────────────────────────
  Widget _buildFilters() {
    final statuses = ['all', 'pending', 'confirmed', 'shipped', 'delivered'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        itemBuilder: (_, i) {
          final s = statuses[i];
          final selected = _filterStatus == s;
          return GestureDetector(
            onTap: () => setState(() => _filterStatus = s),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFB03A2E)
                    : const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFB03A2E)
                      : const Color(0xFF2A2A2A),
                ),
              ),
              child: Text(
                s[0].toUpperCase() + s.substring(1),
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white54,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Order List ───────────────────────────────────────────────
  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, color: Colors.white24, size: 60),
            SizedBox(height: 12),
            Text(
              'No orders yet',
              style: TextStyle(color: Colors.white38, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => _OrderCard(
        order: orders[i],
        onStatusChanged: (newStatus) async {
          try {
            await FirebaseService.instance.updateOrderStatus(
              orders[i].id,
              newStatus,
            );
            OrderStore.instance.updateStatus(orders[i].id, newStatus);
            if (mounted) setState(() {});
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error updating status: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

// ── Individual Order Card ────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final void Function(String) onStatusChanged;

  const _OrderCard({required this.order, required this.onStatusChanged});

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: const TextStyle(
                    color: Color(0xFFB03A2E),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(order.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _statusColor(order.status)),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(order.status),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Customer info
          _row(Icons.person_outline, order.name),
          const SizedBox(height: 4),
          _row(Icons.phone_outlined, order.phone),
          const SizedBox(height: 4),
          _row(
            Icons.location_on_outlined,
            '${order.address}, ${order.city}, ${order.state} - ${order.pincode}',
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFF2A2A2A), height: 1),
          const SizedBox(height: 10),

          // Order details
          Row(
            children: [
              _chip('Qty: ${order.quantity}'),
              const SizedBox(width: 8),
              _chip('₹${order.totalAmount.toStringAsFixed(0)}'),
              const Spacer(),
              Text(
                _formatDate(order.orderDate),
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Update status dropdown
          Row(
            children: [
              const Text(
                'Update Status:',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: order.status,
                dropdownColor: const Color(0xFF1C1C1C),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                underline: const SizedBox(),
                items: ['pending', 'confirmed', 'shipped', 'delivered']
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s[0].toUpperCase() + s.substring(1)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) onStatusChanged(v);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.white38),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFB03A2E),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }
}
