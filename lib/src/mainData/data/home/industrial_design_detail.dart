class IndustrialDesignDetailModel {
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
  final String locarnoClasses;
  final String representativeName;
  final String? representativeAddress;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<IndustrialDesignImage> images;

  IndustrialDesignDetailModel({
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
    required this.locarnoClasses,
    required this.representativeName,
    this.representativeAddress,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.images,
  });

  factory IndustrialDesignDetailModel.fromJson(Map<String, dynamic> json) {
    return IndustrialDesignDetailModel(
      name: json['name'] ?? '',
      description: json['description'],
      owner: json['owner'] ?? '',
      address: json['address'] ?? '',
      filingNumber: json['filing_number'] ?? '',
      filingDate: _parseDate(json['filing_date']),
      publicationNumber: json['publication_number'] ?? '',
      publicationDate: _parseDate(json['publication_date']),
      registrationNumber: json['registration_number'] ?? '',
      registrationDate: _parseDate(json['registration_date']),
      expirationDate: _parseDate(json['expiration_date']),
      designer: json['designer'] ?? '',
      designerAddress: json['designer_address'],
      locarnoClasses: json['locarno_classes'] ?? '',
      representativeName: json['representative_name'] ?? '',
      representativeAddress: json['representative_address'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      images: (json['images'] as List?)
          ?.map((img) => IndustrialDesignImage.fromJson(img))
          .toList() ?? [],
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateTime.parse(dateStr.replaceAll('.', '-'));
    } catch (e) {
      return DateTime.now();
    }
  }
}

class IndustrialDesignImage {
  final String filePath;
  final String fileName;

  IndustrialDesignImage({
    required this.filePath,
    required this.fileName,
  });

  factory IndustrialDesignImage.fromJson(Map<String, dynamic> json) {
    return IndustrialDesignImage(
      filePath: json['file_path'] ?? '',
      fileName: json['file_name'] ?? '',
    );
  }
}