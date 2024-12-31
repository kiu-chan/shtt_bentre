class ProductRegistrationModel {
  final String id;
  final String name;
  final String owner;
  final String representative;
  final String address;
  final String contact;
  final DateTime createdAt;
  final String? status;
  final String slug;

  ProductRegistrationModel({
    required this.id,
    required this.name,
    required this.owner,
    required this.representative,
    required this.address,
    required this.contact,
    required this.createdAt,
    this.status,
    required this.slug,
  });

  factory ProductRegistrationModel.fromJson(Map<String, dynamic> json) {
    return ProductRegistrationModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      representative: json['representatives'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
      slug: json['slug'] ?? '',
    );
  }
}