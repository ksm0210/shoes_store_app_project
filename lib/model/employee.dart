// 직원정보들
class Employee {
  int? employee_id;
  String employee_password;
  Enum employee_type;
  String employee_name;
  String employee_address;
  String employee_email;
  String employee_phone;
  String manager_id;
  DateTime created_at;

  Employee(
    {
      this.employee_id,
      required this.employee_password,
      required this.employee_type,
      required this.employee_name,
      required this.employee_address,
      required this.employee_email,
      required this.employee_phone,
      required this.manager_id,
      required this.created_at
    }
  );

  Employee.fromMap(Map<String,dynamic> res)
  : employee_id = res['employee_id'],         
    employee_password = res['employee_password'],
    employee_type = res['employee_type'],
    employee_name = res['employee_name'],
    employee_address = res['employee_address'],
    employee_email = res['employee_email'],
    employee_phone = res['employee_phone'],
    manager_id = res['manager_id'],
    created_at = DateTime.now();

}