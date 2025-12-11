class Receive {
  int? receive_id;
  int order_id;
  int store_id;
  int employee_id;
  DateTime received_at;

  Receive({
    this.receive_id,
    required this.order_id,
    required this.store_id,
    required this.employee_id,
    required this.received_at,
  });

  Receive.fromMap(Map<String, dynamic> res)
      : receive_id = res['receive_id'],
        order_id = res['order_id'],
        store_id = res['store_id'],
        employee_id = res['employee_id'],
        received_at = DateTime.parse(res['received_at']);
}
