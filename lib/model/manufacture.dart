class Manufacture {
  int? manufacture_id;
  String manufacture_name;
  String manufacture_address;
  String manufacture_contact;
  String business_number;
  DateTime created_at;

  Manufacture({
    this.manufacture_id,
    required this.manufacture_name,
    required this.manufacture_address,
    required this.manufacture_contact,
    required this.business_number,
    required this.created_at,
  });

  Manufacture.fromMap(Map<String, dynamic> res)
      : manufacture_id = res['manufacture_id'],
        manufacture_name = res['manufacture_name'],
        manufacture_address = res['manufacture_address'],
        manufacture_contact = res['manufacture_contact'],
        business_number = res['business_number'],
        created_at = DateTime.parse(res['created_at']);
}
