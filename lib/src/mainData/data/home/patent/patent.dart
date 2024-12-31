class PatentModel {
  final String id;
  final String title;
  final String field;
  final String owner;
  final String status;
  final String address;
  final DateTime date;

  PatentModel({
    required this.id,
    required this.title,
    required this.field,
    required this.owner,
    required this.status,
    required this.address,
    required this.date,
  });

  factory PatentModel.fromJson(Map<String, dynamic> json) {
    return PatentModel(
      // Sửa lại chỗ này, lấy id từ trường id
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      field: json['type'] ?? '',
      owner: json['applicant'] ?? '',
      status: json['status'] ?? '',
      address: json['applicant_address'] ?? '',
      date: _parseDate(json['filing_date']),
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      final parts = dateStr.split('.');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return DateTime.now();
    }
  }
}