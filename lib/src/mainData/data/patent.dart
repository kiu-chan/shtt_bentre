import 'package:latlong2/latlong.dart';

class Patent {
  final int id;
  final int districtId;
  final int? communeId;
  final String title;
  final String inventor;
  final String inventorAddress;
  final String applicant;
  final String applicantAddress;
  final LatLng location;
  final int typeId;
  final int userId;

  Patent({
    required this.id,
    required this.districtId,
    this.communeId,
    required this.title,
    required this.inventor,
    required this.inventorAddress,
    required this.applicant,
    required this.applicantAddress,
    required this.location,
    required this.typeId,
    required this.userId,
  });

  factory Patent.fromRow(List<dynamic> row) {
    try {
      String geomText = row[3] as String;
      
      // Xử lý chuỗi POINT an toàn hơn
      final pointRegex = RegExp(r'POINT\(([0-9.-]+)\s+([0-9.-]+)\)');
      final match = pointRegex.firstMatch(geomText.replaceAll('SRID=4326;', ''));
      
      if (match == null || match.groupCount != 2) {
        throw FormatException('Invalid POINT format: $geomText');
      }

      final longitude = double.parse(match.group(1)!);
      final latitude = double.parse(match.group(2)!);

      // Xử lý các trường có thể null
      final title = row[6] as String? ?? 'Không có tiêu đề';
      final inventor = row[7] as String? ?? 'Không có thông tin';
      final inventorAddress = row[8] as String? ?? 'Không có địa chỉ';
      final applicant = row[9] as String? ?? 'Không có thông tin';
      final applicantAddress = row[10] as String? ?? 'Không có địa chỉ';
      
      return Patent(
        id: row[0] as int,
        districtId: row[1] as int,
        communeId: row[2] as int?,
        location: LatLng(latitude, longitude),
        userId: row[4] as int,
        typeId: row[5] as int,
        title: title,
        inventor: inventor,
        inventorAddress: inventorAddress,
        applicant: applicant,
        applicantAddress: applicantAddress,
      );
    } catch (e) {
      print('Error parsing patent data: $e');
      print('Raw data: $row');
      rethrow;
    }
  }
}