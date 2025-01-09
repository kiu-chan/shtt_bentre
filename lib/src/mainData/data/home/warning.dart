// lib/src/mainData/data/warning.dart

class WarningModel {
  final int id;
  final int? userId;
  final int? adminId;
  final String type;
  final String title;
  final String? description;
  final String? attachmentPath;
  final String? assetType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  WarningModel({
    required this.id,
    this.userId,
    this.adminId,
    required this.type,
    required this.title,
    this.description,
    this.attachmentPath,
    this.assetType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WarningModel.fromJson(Map<String, dynamic> json) {
    return WarningModel(
      id: json['id'] as int,
      userId: json['user_id'] as int?,
      adminId: json['admin_id'] as int?,
      type: json['type'] as String? ?? 'unknown',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      attachmentPath: json['attachment_path'] as String?,
      assetType: json['asset_type'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}