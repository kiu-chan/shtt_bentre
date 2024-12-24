class ResearchProjectModel {
  final String id;
  final String type;
  final String projectName;
  final String researcher;
  final String organization;
  final DateTime startDate;
  final String image;
  final String status;

  ResearchProjectModel({
    required this.id,
    required this.type,
    required this.projectName,
    required this.researcher,
    required this.organization,
    required this.startDate,
    required this.image,
    required this.status,
  });

  factory ResearchProjectModel.fromJson(Map<String, dynamic> json) {
    return ResearchProjectModel(
      id: json['id'].toString(),
      type: json['type'] ?? '',
      projectName: json['name'] ?? '',
      researcher: json['leader_name'] ?? '',
      organization: json['institution'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      image: json['image'] ?? '',
      status: json['status'] == '1' ? 'Đang thực hiện' : 'Đã được cấp bằng',
    );
  }
}