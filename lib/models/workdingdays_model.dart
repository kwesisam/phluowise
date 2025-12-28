class WorkingDay {
  final String id;
  final String day;
  final String time;
  final String companyId;
  final String branchId;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkingDay({
    required this.id,
    required this.day,
    required this.time,
    required this.companyId,
    required this.branchId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkingDay.fromMap(Map<String, dynamic> json) {
    return WorkingDay(
      id: json['\$id'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      companyId: json['company_id'] as String,
      branchId: json['branch_id'] as String,
      createdAt: DateTime.parse(json['\$createdAt']),
      updatedAt: DateTime.parse(json['\$updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'time': time,
      'company_id': companyId,
      'branch_id': branchId,
    };
  }
}
