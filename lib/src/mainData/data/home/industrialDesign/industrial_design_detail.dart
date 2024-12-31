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
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      images: (json['images'] as List?)
          ?.map((img) => IndustrialDesignImage.fromJson(img))
          .toList() ?? [],
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime.now();
    }

    try {
      // Handle format "dd.MM.yyyy"
      if (dateStr.contains('.')) {
        final parts = dateStr.split('.');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      }

      // Handle format "25.10.1991"
      final pattern = RegExp(r'^(\d{2})\.(\d{2})\.(\d{4})$');
      final match = pattern.firstMatch(dateStr);
      if (match != null) {
        return DateTime(
          int.parse(match.group(3)!), // year
          int.parse(match.group(2)!), // month
          int.parse(match.group(1)!), // day
        );
      }

      // Try standard ISO format as fallback
      return DateTime.parse(dateStr);
    } catch (e) {
      print('Error parsing date "$dateStr": $e');
      return DateTime.now();
    }
  }

  static DateTime? _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return null;
    }

    try {
      // Handle format "dd.MM.yyyy HH:mm:ss"
      final pattern = RegExp(r'^(\d{2})\.(\d{2})\.(\d{4})\s+(\d{2}):(\d{2}):(\d{2})$');
      final match = pattern.firstMatch(dateTimeStr);
      if (match != null) {
        return DateTime(
          int.parse(match.group(3)!), // year
          int.parse(match.group(2)!), // month
          int.parse(match.group(1)!), // day
          int.parse(match.group(4)!), // hour
          int.parse(match.group(5)!), // minute
          int.parse(match.group(6)!), // second
        );
      }

      // Try standard ISO format as fallback
      return DateTime.parse(dateTimeStr);
    } catch (e) {
      print('Error parsing datetime "$dateTimeStr": $e');
      return null;
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