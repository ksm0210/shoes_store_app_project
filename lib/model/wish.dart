class Wish {
  int? wish_id;
  int customer_id;
  int product_id;
  DateTime created_at;

  Wish({

    required this.customer_id,
    required this.product_id,
    required this.created_at,
  });

  Wish.fromMap(Map<String, dynamic> res)
      : 
        customer_id = res['customer_id'],
        product_id = res['product_id'],
        created_at = DateTime.parse(res['created_at']);
}
