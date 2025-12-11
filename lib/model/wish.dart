class Wish {
  int? wish_id;
  int customer_id;
  int product_id;
  DateTime created_at;

  Wish({
    this.wish_id,
    required this.customer_id,
    required this.product_id,
    required this.created_at,
  });

  Wish.fromMap(Map<String, dynamic> res)
      : wish_id = res['wish_id'],
        customer_id = res['customer_id'],
        product_id = res['product_id'],
        created_at = DateTime.parse(res['created_at']);
}
