class PatentModel {
  final String id;
  final String title;
  final String field;
  final String image;
  final String owner;
  final String status;
  final String address;
  final DateTime date;

  PatentModel({
    required this.id,
    required this.title,
    required this.field,
    required this.image,
    required this.owner,
    required this.status,
    required this.address,
    required this.date,
  });
}