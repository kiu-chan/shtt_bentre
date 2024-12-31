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
      id: json['id']?.toString() ?? '',  // Thêm ? và ?? để xử lý null
      type: json['type']?.toString() ?? '',
      projectName: json['name']?.toString() ?? '',
      researcher: json['leader_name']?.toString() ?? '',
      organization: json['institution']?.toString() ?? '',
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      image: json['image']?.toString() ?? '',
      status: (json['status']?.toString() == '1') ? 'Đang thực hiện' : 'Đã được cấp bằng',
    );
  }
}