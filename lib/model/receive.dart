class Receive {

  int order_id;
  int store_id;
  int employee_id;
  DateTime received_at;

  Receive({

    required this.order_id,
    required this.store_id,
    required this.employee_id,
    required this.received_at,
  });

  Receive.fromMap(Map<String, dynamic> res)
      : 
        order_id = res['order_id'],
        store_id = res['store_id'],
        employee_id = res['employee_id'],
        received_at = DateTime.parse(res['received_at']);
}
