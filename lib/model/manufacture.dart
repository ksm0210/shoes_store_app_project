class Manufacture {
  int? manufacture_id;
  String manufacture_name;
  String? manufacture_address;
  String? manufacture_contact;
  String? business_number;
  DateTime created_at;

  Manufacture({

    required this.manufacture_name,
    this.manufacture_address,
    this.manufacture_contact,
    this.business_number,
    required this.created_at,
  });

  Manufacture.fromMap(Map<String, dynamic> res)
      : 
        manufacture_name = res['manufacture_name'],
        manufacture_address = res['manufacture_address'],
        manufacture_contact = res['manufacture_contact'],
        business_number = res['business_number'],
        created_at = DateTime.now();
}
