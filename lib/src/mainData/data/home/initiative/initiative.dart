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
    try {
      return InitiativeModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        author: json['author']?.toString() ?? '',
        owner: json['owner']?.toString() ?? '',
        field: json['fields']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        recognitionYear: int.tryParse(json['recognition_year']?.toString() ?? '0') ?? 0,
        status: json['status'] == '3' ? 'Được phê duyệt' : 'Chờ phê duyệt',
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      print('Error parsing InitiativeModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}