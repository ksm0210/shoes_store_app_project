// 고객정보
class Customer {
  // 고객정보
  int? customer_id;
  String customer_password;
  String customer_name;
  String? customer_email;
  double? customer_lat;
  double? customer_lng;
  String? customer_city;
  String? customer_state;
  DateTime? created_at;
  

  Customer(
    {

      required this.customer_password,
      required this.customer_name,
      this.customer_email,
      this.customer_city,
      this.customer_state,
      this.customer_lat,
      this.customer_lng,
      this.created_at

    }
  );

    Customer.fromMap(Map<String,dynamic> res)
  :    
    customer_password = res['customer_password'],
    customer_name = res['customer_name'],
    customer_email = res['customer_email'],
    customer_city = res['customer_city'],
    customer_state = res['customer_state'],
    customer_lat = res['customer_lat'],
    customer_lng = res['customer_lng'],
    created_at = DateTime.parse(res['created_at']);

}