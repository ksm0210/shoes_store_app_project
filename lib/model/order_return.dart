class OrderReturn {
  int? receive_seq;
  int order_id;
  int customer_id;
  int? employee_id;
  int product_id;
  int order_store_id;
  int order_quantity;
  int order_total_price;
  String order_status;       // 요청, 배송중, 완료
  DateTime order_created_at;
  DateTime created_at;

  OrderReturn({
    required this.order_id,
    required this.customer_id,
    this.employee_id,
    required this.product_id,
    required this.order_store_id,
    required this.order_quantity,
    required this.order_total_price,
    required this.order_status,
    required this.order_created_at,
    required this.created_at,
  });

  OrderReturn.fromMap(Map<String, dynamic> res)
      :
        order_id = res['order_id'],
        customer_id = res['customer_id'],
        employee_id = res['employee_id'],
        product_id = res['product_id'],
        order_store_id = res['order_store_id'],
        order_quantity = res['order_quantity'],
        order_total_price = res['order_total_price'],
        order_status = res['order_status'],
        order_created_at = DateTime.parse(res['created_at']),
        created_at = DateTime.now();
}
