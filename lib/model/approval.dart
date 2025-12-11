// 결재 서류
class Approval {
  int? approval_id;
  int employee_id;
  String approval_type;    // ex: team_leader, director
  String approval_status;           // ex: pending, approved, rejected
  String approval_content;
  DateTime created_at;

  Approval({
    this.approval_id,
    required this.employee_id,
    required this.approval_type,
    required this.approval_status,
    required this.approval_content,
    required this.created_at,
  });

  Approval.fromMap(Map<String, dynamic> res)
      : approval_id = res['approval_id'],
        employee_id = res['employee_id'],
        approval_type = res['approval_type'],
        approval_status = res['approval_status'],
        approval_content = res['approval_content'],
        created_at = DateTime.parse(res['created_at']);
}
