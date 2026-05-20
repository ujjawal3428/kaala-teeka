import '../models/order_model.dart';

// Simple in-memory store. Replace with Firebase/Supabase for production.
class OrderStore {
  OrderStore._();
  static final OrderStore instance = OrderStore._();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  void addOrder(OrderModel order) {
    _orders.insert(0, order); // newest first
  }

  void updateStatus(String id, String status) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      _orders[index].status = status;
    }
  }

  double get totalRevenue =>
      _orders.fold(0, (sum, o) => sum + o.totalAmount);

  int get totalOrders => _orders.length;

  Map<String, int> get ordersByCity {
    final map = <String, int>{};
    for (final o in _orders) {
      map[o.city] = (map[o.city] ?? 0) + 1;
    }
    return map;
  }
}