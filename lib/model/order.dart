class Order {
  int? order_id;
  int customer_id;
  int product_id;
  String? product_name;
  String? product_mainImageUrl;
  int order_store_id;
  int order_quantity;
  int order_total_price;
  String order_status;       // 요청, 배송중, 완료
  DateTime created_at;

  Order({
    this.product_name,
    this.product_mainImageUrl,
    required this.customer_id,
    required this.product_id,
    required this.order_store_id,
    required this.order_quantity,
    required this.order_total_price,
    required this.order_status,
    required this.created_at,
  });

  Order.fromMap(Map<String, dynamic> res)
      :
        customer_id = res['customer_id'],
        product_id = res['product_id'],
        product_name = res['product_name']!=null?res['product_name']:'empty',
        product_mainImageUrl = res['product_mainImageUrl']!=null?res['product_mainImageUrl']:'empty',
        order_store_id = res['order_store_id'],
        order_quantity = res['order_quantity'],
        order_total_price = res['order_total_price'],
        order_status = res['order_status'],
        created_at = DateTime.parse(res['created_at']);
}
