class OrderModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final int quantity;
  final double totalAmount;
  final DateTime orderDate;
  String status; // 'pending', 'confirmed', 'shipped', 'delivered'

  OrderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.quantity,
    required this.totalAmount,
    required this.orderDate,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
