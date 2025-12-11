class Order {
  final int order_id;
  final String order_userId;
  final int order_productId;
  final int order_qty;
  final int order_price;
  final String order_orderDate;
  final String order_receiveStore; // 대리점 선택

  Order({
    required this.order_id,
    required this.order_userId,
    required this.order_productId,
    required this.order_qty,
    required this.order_price,
    required this.order_orderDate,
    required this.order_receiveStore,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_id': order_id,
      'order_userId': order_userId,
      'order_productId': order_productId,
      'order_qty': order_qty,
      'order_price': order_price,
      'order_orderDate': order_orderDate,
      'order_receiveStore': order_receiveStore,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      order_id: map['order_id'],
      order_userId: map['order_userId'],
      order_productId: map['order_productId'],
      order_qty: map['order_qty'],
      order_price: map['order_price'],
      order_orderDate: map['order_orderDate'],
      order_receiveStore: map['order_receiveStore'],
    );
  }
}
