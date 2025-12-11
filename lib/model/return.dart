class ReturnItem {
  int? return_id;
  int order_id;
  int customer_id;
  String return_reason;
  String return_status;        // 요청, 승인, 거부
  DateTime created_at;

  ReturnItem({
    this.return_id,
    required this.order_id,
    required this.customer_id,
    required this.return_reason,
    required this.return_status,
    required this.created_at,
  });

  ReturnItem.fromMap(Map<String, dynamic> res)
      : return_id = res['return_id'],
        order_id = res['order_id'],
        customer_id = res['customer_id'],
        return_reason = res['return_reason'],
        return_status = res['return_status'],
        created_at = DateTime.parse(res['created_at']);
}
