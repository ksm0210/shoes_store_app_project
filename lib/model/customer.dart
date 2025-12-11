// 고객정보
class Customer {
  // 고객정보
  int? customer_id;
  String customer_password;
  String customer_name;
  String customer_email;
  int? customer_lat;
  int? customer_lng;
  String customer_city;
  String customer_state;
  DateTime created_at;
  

  Customer(
    {
      this.customer_id,
      required this.customer_password,
      required this.customer_name,
      required this.customer_email,
      required this.customer_city,
      required this.customer_state,
      this.customer_lat,
      this.customer_lng,
      required this.created_at

    }
  );

    Customer.fromMap(Map<String,dynamic> res)
  : customer_id = res['customer_id'],         
    customer_name = res['customer_name'],
    phone = res['phone'],
    address = res['address'],
    relation = res['relation'],
    image = res['image'];
}
}