

class ShoppingCart {
  int? cart_seq_id;
  int customer_id;
  int product_id;


  ShoppingCart({
    required this.customer_id,
    required this.product_id
  });

  ShoppingCart.fromMap(Map<String,dynamic> json) :
  customer_id = json['customer_id'],
  product_id = json['product_id'];
}