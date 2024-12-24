import 'package:intl/intl.dart';

class GeoIndicationModel {
  final int stt;
  final String? soDon;
  final String tenSanPham;
  final String donViQuanLy;
  final String danhSachXa;
  final String? donViUyQuyen;
  final DateTime ngayCap;

  GeoIndicationModel({
    required this.stt,
    this.soDon,
    required this.tenSanPham,
    required this.donViQuanLy,
    required this.danhSachXa,
    this.donViUyQuyen,
    required this.ngayCap,
  });

  factory GeoIndicationModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String dateStr) {
      try {
        // Try parsing DD.MM.YYYY format
        final parts = dateStr.split('.');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
        // Fallback to standard ISO format
        return DateTime.parse(dateStr);
      } catch (e) {
        print('Error parsing date: $dateStr');
        // Return a default date if parsing fails
        return DateTime.now();
      }
    }

    return GeoIndicationModel(
      stt: json['stt'] ?? 0,
      soDon: json['so_don'],
      tenSanPham: json['ten_san_pham'] ?? '',
      donViQuanLy: json['don_vi_quan_ly'] ?? '',
      danhSachXa: json['danh_sach_xa'] ?? '',
      donViUyQuyen: json['don_vi_uy_quyen'],
      ngayCap: parseDate(json['ngay_cap'] ?? ''),
    );
  }
}