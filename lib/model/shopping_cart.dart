class ShoppingCart {
  int? cart_id;
  int customer_id;
  int product_id;
  String? title;
  int price;
  String? image;
  String size;
  int qty;
  DateTime created_at;
  DateTime updated_at;

  ShoppingCart({
    this.cart_id,
    required this.customer_id,
    required this.product_id,
    this.title,
    required this.price,
    this.image,
    required this.size,
    required this.qty,
    required this.created_at,
    required this.updated_at,
  });

  ShoppingCart.fromMap(Map<String, dynamic> json)
    : customer_id = json['customer_id'],
      cart_id = json['cart_id'],
      product_id = json['product_id'],
      title = json['title'],
      price = json['price'],
      image = json['image'],
      size = json['size'],
      qty = json['qty'],
      created_at = DateTime.parse(json['created_at']),
      updated_at = DateTime.parse(json['updated_at']);
}
