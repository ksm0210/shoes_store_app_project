class Store {
  int? store_id;
  String store_address;
  String store_phone;
  String store_name;
  String store_zipcode;
  double? store_lat;
  double? store_lng;
  String? store_city;
  String? store_state;
  DateTime created_at;

  Store(
    {
      this.store_id,
      required this.store_address,
      required this.store_phone,
      required this.store_name,
      required this.store_zipcode,
      this.store_lat,
      this.store_lng,
      this.store_city,
      this.store_state,
      required this.created_at
    }
  );

  Store.fromMap(Map<String,dynamic> res)
  : 
    store_id = res['store_id'],
    store_address = res['store_address'],
    store_phone = res['store_phone'],
    store_name = res['store_name'],
    store_zipcode = res['store_zipcode'],
    store_lat = res['store_lat'],
    store_lng = res['store_lng'],
    store_city = res['store_city'],
    store_state = res['store_state'],
    created_at = DateTime.parse(res['created_at']);

}