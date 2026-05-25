import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  static FirebaseService get instance => _instance;

  /// Save order to Firebase Firestore
  Future<void> saveOrder(OrderModel order) async {
    try {
      await _firestore
          .collection('orders')
          .doc(order.id)
          .set(order.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save order: $e');
    }
  }

  /// Update order status in Firebase
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Get all orders from Firebase
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => _parseOrderFromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: status)
          .orderBy('orderDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => _parseOrderFromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders by status: $e');
    }
  }

  /// Stream orders for real-time updates
  Stream<List<OrderModel>> streamOrders() {
    return _firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _parseOrderFromMap(doc.data()))
              .toList(),
        );
  }

  /// Stream orders by status for real-time updates
  Stream<List<OrderModel>> streamOrdersByStatus(String status) {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: status)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _parseOrderFromMap(doc.data()))
              .toList(),
        );
  }

  /// Delete order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  /// Parse OrderModel from Firestore map
  OrderModel _parseOrderFromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      pincode: data['pincode'] ?? '',
      quantity: data['quantity'] ?? 0,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      orderDate: data['orderDate'] != null
          ? DateTime.parse(data['orderDate'])
          : DateTime.now(),
      status: data['status'] ?? 'pending',
    );
  }

  /// Get orders statistics
  Future<Map<String, dynamic>> getOrderStats() async {
    try {
      final snapshot = await _firestore.collection('orders').get();

      double totalRevenue = 0;
      Map<String, int> ordersByCity = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        totalRevenue += (data['totalAmount'] ?? 0).toDouble();

        final city = data['city'] ?? 'Unknown';
        ordersByCity[city] = (ordersByCity[city] ?? 0) + 1;
      }

      return {
        'totalOrders': snapshot.size,
        'totalRevenue': totalRevenue,
        'ordersByCity': ordersByCity,
      };
    } catch (e) {
      throw Exception('Failed to fetch order stats: $e');
    }
  }
}
