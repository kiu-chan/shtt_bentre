// lib/src/mainData/data/infringement/infringement.dart

class InfringementModel {
  final int id;
  final String name;
  final String content;
  final DateTime date;
  final String penaltyAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  InfringementModel({
    required this.id,
    required this.name,
    required this.content,
    required this.date,
    required this.penaltyAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InfringementModel.fromJson(Map<String, dynamic> json) {
    return InfringementModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      penaltyAmount: json['penalty_amount'] as String? ?? '0',
      status: json['status'] as String? ?? 'Đang điều tra',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String getFormattedPenaltyAmount() {
    try {
      final amount = double.parse(penaltyAmount);
      return amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},'
      );
    } catch (e) {
      return penaltyAmount;
    }
  }
}