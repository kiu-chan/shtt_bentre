// geo_indication_detail_model.dart
class GeoIndicationDetailModel {
  final int id;
  final String tenSanPham;
  final String? moTa;
  final String noiDung;
  final String? soDon;
  final String? soDangKy;
  final DateTime ngayDangKy;
  final String donViQuanLy;
  final String? donViUyQuyen;
  final String? quyetDinhBaoHo;
  final DateTime ngayQuyetDinh;
  final String cacXaDuocBaoHo;
  final String? diaChi;
  final int? luotXem;
  final DateTime? updatedAt;

  GeoIndicationDetailModel({
    required this.id,
    required this.tenSanPham,
    this.moTa,
    required this.noiDung,
    this.soDon,
    this.soDangKy,
    required this.ngayDangKy,
    required this.donViQuanLy,
    this.donViUyQuyen,
    this.quyetDinhBaoHo,
    required this.ngayQuyetDinh,
    required this.cacXaDuocBaoHo,
    this.diaChi,
    this.luotXem,
    this.updatedAt,
  });

  factory GeoIndicationDetailModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null) return DateTime.now();
      
      try {
        // Format: DD.MM.YYYY HH:mm:ss
        if (dateStr.contains('.') && dateStr.contains(':')) {
          final dateParts = dateStr.split(' ')[0].split('.');
          final timeParts = dateStr.split(' ')[1].split(':');
          
          if (dateParts.length == 3 && timeParts.length == 3) {
            return DateTime(
              int.parse(dateParts[2]),    // year
              int.parse(dateParts[1]),    // month
              int.parse(dateParts[0]),    // day
              int.parse(timeParts[0]),    // hour
              int.parse(timeParts[1]),    // minute
              int.parse(timeParts[2]),    // second
            );
          }
        }
        
        // Format: DD.MM.YYYY
        if (dateStr.contains('.') && !dateStr.contains(':')) {
          final parts = dateStr.split('.');
          if (parts.length == 3) {
            return DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        }

        // Fallback to standard ISO format
        return DateTime.parse(dateStr);
      } catch (e) {
        print('Error parsing date: $dateStr, error: $e');
        return DateTime.now();
      }
    }

    return GeoIndicationDetailModel(
      id: json['id'] ?? 0,
      tenSanPham: json['ten_san_pham'] ?? '',
      moTa: json['mo_ta'],
      noiDung: json['noi_dung'] ?? '',
      soDon: json['so_don'],
      soDangKy: json['so_dang_ky'],
      ngayDangKy: parseDate(json['ngay_dang_ky']),
      donViQuanLy: json['don_vi_quan_ly'] ?? '',
      donViUyQuyen: json['don_vi_uy_quyen'],
      quyetDinhBaoHo: json['quyet_dinh_bao_ho'],
      ngayQuyetDinh: parseDate(json['ngay_quyet_dinh']),
      cacXaDuocBaoHo: json['cac_xa_duoc_bao_ho'] ?? '',
      diaChi: json['dia_chi'],
      luotXem: json['luot_xem'],
      updatedAt: json['updated_at'] != null ? parseDate(json['updated_at']) : null,
    );
  }
}