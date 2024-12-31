class IndustrialDesignModel {
  final int id;
  final String name;
  final String? description;
  final String owner;
  final String address;
  final String filingNumber;
  final DateTime filingDate;
  final String publicationNumber;
  final DateTime publicationDate;
  final String registrationNumber;
  final DateTime registrationDate;
  final DateTime expirationDate;
  final String designer;
  final String? designerAddress;
  final String? locarnoClasses;
  final String representativeName;
  final String? representativeAddress;
  final String status;
  final List<String> images;

  IndustrialDesignModel({
    required this.id,
    required this.name,
    this.description,
    required this.owner,
    required this.address,
    required this.filingNumber,
    required this.filingDate,
    required this.publicationNumber,
    required this.publicationDate,
    required this.registrationNumber,
    required this.registrationDate,
    required this.expirationDate,
    required this.designer,
    this.designerAddress,
    this.locarnoClasses,
    required this.representativeName,
    this.representativeAddress,
    required this.status,
    required this.images,
  });

  factory IndustrialDesignModel.fromJson(Map<String, dynamic> json) {
    return IndustrialDesignModel(
      id: json['id'] ?? 0,
      name: json['design_info']?['name'] ?? json['name'] ?? '',
      description: json['description'],
      owner: json['design_info']?['owner'] ?? json['owner'] ?? '',
      address: json['design_info']?['address'] ?? json['address'] ?? '',
      filingNumber: json['filing_number'] ?? '',
      filingDate: _parseDate(json['filing_date']),
      publicationNumber: json['publication_number'] ?? '',
      publicationDate: _parseDate(json['publication_date']),
      registrationNumber: json['registration_number'] ?? '',
      registrationDate: _parseDate(json['registration_date']),
      expirationDate: _parseDate(json['expiration_date']),
      designer: json['designer'] ?? '',
      designerAddress: json['designer_address'],
      locarnoClasses: json['locarno_classes'],
      representativeName: json['representative_name'] ?? '',
      representativeAddress: json['representative_address'],
      status: json['status'] ?? 'Đang chờ xử lý',
      images: _parseImages(json['images']),
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      // Xử lý format DD.MM.YYYY
      final parts = dateStr.split('.');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
      // Thử parse format chuẩn
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];
    if (images is List) {
      return images
          .map((image) => image['file_path']?.toString() ?? '')
          .where((path) => path.isNotEmpty)
          .toList();
    }
    return [];
  }
}