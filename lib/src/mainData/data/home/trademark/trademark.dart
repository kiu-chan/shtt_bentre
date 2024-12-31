class TrademarkModel {
  final int id;
  final String filingNumber;
  final String mark;
  final String owner;
  final String address;
  final String imageUrl;
  final DateTime filingDate;
  final String status;
  final String type;
  final String typeName;

  TrademarkModel({
    required this.id,
    required this.filingNumber,
    required this.mark,
    required this.owner,
    required this.address,
    required this.imageUrl,
    required this.filingDate,
    required this.status,
    required this.type,
    required this.typeName,
  });

  factory TrademarkModel.fromJson(Map<String, dynamic> json) {
    return TrademarkModel(
      id: json['id'] ?? 0,
      filingNumber: json['filing_number']?.toString() ?? '',
      mark: json['mark']?.toString() ?? '',
      owner: json['owner']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      imageUrl: '', // API response doesn't include image_url
      filingDate: _parseDate(json['filing_date']?.toString()),
      status: json['status']?.toString() ?? '',
      type: '', // API response doesn't include type
      typeName: '', // API response doesn't include type_name
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    
    try {
      // Parse UTC timestamp format from API
      if (dateStr.contains('T')) {
        return DateTime.parse(dateStr);
      }
      return DateTime.now();
    } catch (e) {
      print('Error parsing date: $dateStr - ${e.toString()}');
      return DateTime.now();
    }
  }
}