// 직원정보들
class Employee {
  int? employee_id;
  String employee_password;
  String employee_type;
  String employee_name;
  String? employee_address;
  String? employee_email;
  String? employee_phone;
  int? manager_id;
  DateTime created_at;

  Employee(
    {

      required this.employee_password,
      required this.employee_type,
      required this.employee_name,
      this.employee_address,
      this.employee_email,
      this.employee_phone,
      this.manager_id,
      required this.created_at
    }
  );

  Employee.fromMap(Map<String,dynamic> res)
  : 
    employee_password = res['employee_password'],
    employee_type = res['employee_type'],
    employee_name = res['employee_name'],
    employee_address = res['employee_address'],
    employee_email = res['employee_email'],
    employee_phone = res['employee_phone'],
    manager_id = res['manager_id'],
    created_at = DateTime.parse(res['created_at']);

}