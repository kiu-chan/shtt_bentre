import 'package:flutter/material.dart';

class TechnicalCompetitionModel {
  final String id;
  final String name;
  final String field;
  final String organization;
  final int year;
  final String status;

  TechnicalCompetitionModel({
    required this.id,
    required this.name,
    required this.field,
    required this.organization,
    required this.year,
    required this.status,
  });
}

class TechnicalCompetitionListPage extends StatelessWidget {
  const TechnicalCompetitionListPage({super.key});

  List<TechnicalCompetitionModel> get _competitions => [
    TechnicalCompetitionModel(
      id: '1',
      name: 'Tái chế rác thải nhựa trong ngành nuôi trồng thủy sản ứng dụng trong lĩnh vực xây dựng',
      field: 'Nông nghiệp',
      organization: 'Nguyễn Văn C',
      year: 2024,
      status: 'd',
    ),
    TechnicalCompetitionModel(
      id: '2',
      name: 'Xây dựng quy trình tích hợp giáo dục phát triển bền vững trong dạy học hóa học theo định hướng giáo dục Stem',
      field: 'xh',
      organization: 'Nguyễn Văn B',
      year: 2024,
      status: '123',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hội thi sáng tạo kỹ thuật',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _competitions.length,
        itemBuilder: (context, index) {
          return _CompetitionCard(competition: _competitions[index]);
        },
      ),
    );
  }
}

class _CompetitionCard extends StatelessWidget {
  final TechnicalCompetitionModel competition;

  const _CompetitionCard({
    required this.competition,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFFAFAFA)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF673AB7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF673AB7).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    competition.field,
                    style: const TextStyle(
                      color: Color(0xFF512DA8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFF9800).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 16,
                        color: const Color(0xFFF57C00),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Giải ${competition.status}',
                        style: const TextStyle(
                          color: Color(0xFFF57C00),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              competition.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 20,
                    color: const Color(0xFF1E88E5).withOpacity(0.8),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Đơn vị: ${competition.organization}',
                      style: const TextStyle(
                        color: Color(0xFF455A64),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: const Color(0xFF1E88E5).withOpacity(0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Năm thi: ${competition.year}',
                    style: const TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}