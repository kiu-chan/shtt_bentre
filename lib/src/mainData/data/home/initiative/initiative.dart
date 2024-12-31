class InitiativeModel {
  final String id;
  final String name;
  final String author;
  final String owner;
  final String field;
  final String address;
  final int recognitionYear;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  InitiativeModel({
    required this.id,
    required this.name,
    required this.author,
    required this.owner,
    required this.field,
    required this.address,
    required this.recognitionYear,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InitiativeModel.fromJson(Map<String, dynamic> json) {
    return InitiativeModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      owner: json['owner'] ?? '',
      field: json['fields'] ?? '',
      address: json['address'] ?? '',
      recognitionYear: json['recognition_year'] ?? 0,
      status: json['status'] == '3' ? 'Được phê duyệt' : 'Chờ phê duyệt',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}