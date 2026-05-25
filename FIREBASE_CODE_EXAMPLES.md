# Firebase Integration - Code Examples & Reference

## 📝 Table of Contents
1. [Basic Usage](#basic-usage)
2. [Advanced Usage](#advanced-usage)
3. [Error Handling](#error-handling)
4. [Real-time Updates](#real-time-updates)
5. [Database Queries](#database-queries)

---

## Basic Usage

### Saving a New Order

```dart
import 'package:kaala_teeka_app/services/firebase_service.dart';

// When user places an order
final order = OrderModel(
  id: 'KT-${DateTime.now().millisecondsSinceEpoch}',
  name: 'John Doe',
  phone: '9876543210',
  address: '123 Main Street',
  city: 'Delhi',
  state: 'New Delhi',
  pincode: '110001',
  quantity: 2,
  totalAmount: 598.0,
  orderDate: DateTime.now(),
);

// Save to Firebase
await FirebaseService.instance.saveOrder(order);
```

### Updating Order Status

```dart
// Admin updates order status
await FirebaseService.instance.updateOrderStatus(
  'KT-1234567890',
  'shipped'
);
```

### Fetching All Orders

```dart
// Get all orders (one-time fetch)
final orders = await FirebaseService.instance.getAllOrders();

for (var order in orders) {
  print('Order ${order.id}: ${order.name} - ₹${order.totalAmount}');
}
```

---

## Advanced Usage

### Real-time Order Updates

```dart
// In your StatefulWidget
@override
Widget build(BuildContext context) {
  return StreamBuilder<List<OrderModel>>(
    stream: FirebaseService.instance.streamOrders(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      
      final orders = snapshot.data ?? [];
      
      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(orders[index].name),
            subtitle: Text('₹${orders[index].totalAmount}'),
          );
        },
      );
    },
  );
}
```

### Filter Orders by Status

```dart
// Get only pending orders
final pendingOrders = await FirebaseService.instance
  .getOrdersByStatus('pending');

// Get only shipped orders
final shippedOrders = await FirebaseService.instance
  .getOrdersByStatus('shipped');
```

### Stream Orders by Status

```dart
// Real-time stream of pending orders
final pendingOrdersStream = 
  FirebaseService.instance.streamOrdersByStatus('pending');

pendingOrdersStream.listen((orders) {
  print('Pending orders: ${orders.length}');
});
```

### Get Statistics

```dart
// Fetch order statistics
final stats = await FirebaseService.instance.getOrderStats();

final totalOrders = stats['totalOrders'];      // int
final totalRevenue = stats['totalRevenue'];    // double
final ordersByCity = stats['ordersByCity'];    // Map<String, int>

print('Total Orders: $totalOrders');
print('Total Revenue: ₹$totalRevenue');
print('Orders by City: $ordersByCity');
```

---

## Error Handling

### Try-Catch Pattern

```dart
try {
  await FirebaseService.instance.saveOrder(order);
  
  // Show success message
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('✅ Order saved successfully!'),
      backgroundColor: Colors.green,
    ),
  );
} catch (e) {
  // Show error message
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('❌ Error: $e'),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Proper Async/Await

```dart
// GOOD: Using async/await
Future<void> updateStatus() async {
  try {
    await FirebaseService.instance.updateOrderStatus(orderId, 'delivered');
  } catch (e) {
    print('Error: $e');
  }
}

// Also acceptable: Using .then().catchError()
updateOrderStatus()
  .then((_) => print('Status updated'))
  .catchError((e) => print('Error: $e'));
```

---

## Real-time Updates

### Multiple Streams in One Widget

```dart
// Display all orders and show count of pending orders
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      // All orders
      Expanded(
        flex: 3,
        child: StreamBuilder<List<OrderModel>>(
          stream: FirebaseService.instance.streamOrders(),
          builder: (context, snapshot) {
            final orders = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, i) => OrderTile(order: orders[i]),
            );
          },
        ),
      ),
      
      // Pending orders badge
      Expanded(
        flex: 1,
        child: StreamBuilder<List<OrderModel>>(
          stream: FirebaseService.instance
            .streamOrdersByStatus('pending'),
          builder: (context, snapshot) {
            final pending = snapshot.data?.length ?? 0;
            return Container(
              color: Colors.orange,
              child: Center(
                child: Text(
                  'Pending: $pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
```

---

## Database Queries

### Query Examples for Future Use

```dart
// Example: Once Firestore gets more complex queries
// (Add these methods to FirebaseService as needed)

// Get orders from a specific city
Future<List<OrderModel>> getOrdersByCity(String city) async {
  final snapshot = await _firestore
    .collection('orders')
    .where('city', isEqualTo: city)
    .get();
  
  return snapshot.docs
    .map((doc) => _parseOrderFromMap(doc.data()))
    .toList();
}

// Get orders placed in last 24 hours
Future<List<OrderModel>> getRecentOrders() async {
  final yesterday = DateTime.now().subtract(Duration(days: 1));
  
  final snapshot = await _firestore
    .collection('orders')
    .where('orderDate', isGreaterThan: yesterday)
    .orderBy('orderDate', descending: true)
    .get();
  
  return snapshot.docs
    .map((doc) => _parseOrderFromMap(doc.data()))
    .toList();
}

// Get orders above a certain amount
Future<List<OrderModel>> getHighValueOrders(double minAmount) async {
  final snapshot = await _firestore
    .collection('orders')
    .where('totalAmount', isGreaterThan: minAmount)
    .orderBy('totalAmount', descending: true)
    .get();
  
  return snapshot.docs
    .map((doc) => _parseOrderFromMap(doc.data()))
    .toList();
}
```

---

## Common Patterns

### Delete an Order

```dart
// Admin wants to delete an order
await FirebaseService.instance.deleteOrder('KT-1234567890');
```

### Batch Operations

```dart
// Update multiple orders to shipped status
final orders = await FirebaseService.instance.getAllOrders();

for (final order in orders.where((o) => o.status == 'confirmed')) {
  await FirebaseService.instance
    .updateOrderStatus(order.id, 'shipped');
}
```

### Handle Network Errors

```dart
try {
  await FirebaseService.instance.saveOrder(order);
} on FirebaseException catch (e) {
  print('Firebase Error: ${e.code} - ${e.message}');
} on SocketException catch (e) {
  print('Network Error: No internet connection');
} catch (e) {
  print('Unknown Error: $e');
}
```

---

## Testing Firebase Integration

### Manual Testing Checklist

```
☐ Fill order form with valid data
☐ Click "Confirm Order"
☐ See success dialog
☐ Check Firebase Console → orders collection
☐ Verify new document created with correct data
☐ Navigate to Admin Dashboard
☐ See orders appear in real-time
☐ Click status dropdown on an order
☐ Select different status (e.g., "shipped")
☐ Check Firebase Console for status update
☐ Confirm Admin Dashboard updates automatically
```

### Debug Logging

```dart
// Add to FirebaseService for debugging
void _debugLog(String message) {
  print('[Firebase] $message');
}

// Usage
_debugLog('Saving order: ${order.id}');
await _firestore.collection('orders').doc(order.id).set(order.toMap());
_debugLog('Order saved successfully');
```

---

## Performance Tips

### Optimize Queries

```dart
// ❌ BAD: Downloads entire collection
final allOrders = await _firestore.collection('orders').get();
final pending = allOrders.docs
  .where((doc) => doc['status'] == 'pending')
  .toList();

// ✅ GOOD: Filter on server side
final pending = await _firestore
  .collection('orders')
  .where('status', isEqualTo: 'pending')
  .get();
```

### Pagination for Large Datasets

```dart
// Load orders in batches
Future<List<OrderModel>> getOrdersPaginated(int page, int pageSize) async {
  final snapshot = await _firestore
    .collection('orders')
    .orderBy('orderDate', descending: true)
    .limit(pageSize)
    .offset(page * pageSize)
    .get();
  
  return snapshot.docs
    .map((doc) => _parseOrderFromMap(doc.data()))
    .toList();
}
```

---

## Security Best Practices

### For Production

```javascript
// Update Firestore rules for production
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /orders/{document=**} {
      // Only authenticated users can read
      allow read: if request.auth != null;
      
      // Only admins can write/update
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid))
        .data.role == 'admin';
    }
  }
}
```

---

## Troubleshooting

### Orders not saving?

```dart
// Add logging to debug
Future<void> saveOrder(OrderModel order) async {
  try {
    print('Attempting to save order: ${order.id}');
    await _firestore.collection('orders').doc(order.id).set(
      order.toMap(),
      SetOptions(merge: true),
    );
    print('✓ Order saved successfully');
  } catch (e) {
    print('✗ Error saving order: $e');
    rethrow;
  }
}
```

### Real-time updates not working?

```dart
// Verify stream is connected
FirebaseService.instance.streamOrders().listen(
  (orders) => print('Received ${orders.length} orders'),
  onError: (error) => print('Stream error: $error'),
  onDone: () => print('Stream completed'),
);
```

---

## Resources

- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Console](https://console.firebase.google.com)
- [Flutter Firebase](https://firebase.flutter.dev/)
- [Cloud Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)

---

**Need help?** Check the other Firebase documentation files in your project! 📚
