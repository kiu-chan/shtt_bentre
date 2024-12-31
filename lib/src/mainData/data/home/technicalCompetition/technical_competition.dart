class TechnicalCompetitionModel {
  final int id;
  final String name;
  final String field;
  final String organization;
  final String submissionDate;
  final int year;
  final String rank;
  final String resultStatus;

  TechnicalCompetitionModel({
    required this.id,
    required this.name,
    required this.field,
    required this.organization,
    required this.submissionDate,
    required this.year,
    required this.rank,
    required this.resultStatus,
  });

  factory TechnicalCompetitionModel.fromJson(Map<String, dynamic> json) {
    return TechnicalCompetitionModel(
      id: json['id'],
      name: json['name'],
      field: json['field'],
      organization: json['unit_name'],
      submissionDate: json['submission_date'],
      year: json['year'],
      rank: json['result_status'],
      resultStatus: getResultStatus(json['result_status']),
    );
  }

  static String getResultStatus(String code) {
    switch (code) {
      case 'd':
        return 'Đặc biệt';
      case '123':
        return 'Giải ${code[0]}';
      case 'xh':
        return 'Xuất sắc';
      default:
        return 'Không có giải';
    }
  }
}