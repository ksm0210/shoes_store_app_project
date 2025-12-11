// 제조사 정보들class 
class Manufacture {
  final int manufacture_id;
  final String  manufacture_name;
  final String  manufacture_address;
  final String  manufacture_phone;
  final String  manufacture_accountNumber;

  Manufacture({
    required this. manufacture_id,
    required this. manufacture_name,
    required this. manufacture_address,
    required this. manufacture_phone,
    required this. manufacture_accountNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      ' manufacture_id':  manufacture_id,
      ' manufacture_name':  manufacture_name,
      ' manufacture_address':  manufacture_address,
      ' manufacture_phone':  manufacture_phone,
      ' manufacture_accountNumber':  manufacture_accountNumber,
    };
  }

  factory Manufacture.fromMap(Map<String, dynamic> map) {
    return Manufacture(
       manufacture_id: map[' manufacture_id'],
       manufacture_name: map[' manufacture_name'],
       manufacture_address: map[' manufacture_address'],
       manufacture_phone: map[' manufacture_phone'],
       manufacture_accountNumber: map[' manufacture_accountNumber'],
    );
  }
}
