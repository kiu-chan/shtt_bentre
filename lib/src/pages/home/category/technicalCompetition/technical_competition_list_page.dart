import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/technicalCompetition/technical_competition.dart';
import 'package:shtt_bentre/src/pages/home/category/technicalCompetition/technical_competition_detail_page.dart';

class TechnicalCompetitionListPage extends StatefulWidget {
  const TechnicalCompetitionListPage({Key? key}) : super(key: key);

  @override
  _TechnicalCompetitionListPageState createState() => _TechnicalCompetitionListPageState();
}

class _TechnicalCompetitionListPageState extends State<TechnicalCompetitionListPage> {
  List<TechnicalCompetitionModel> _competitions = [];

  @override
  void initState() {
    super.initState();
    _fetchCompetitions();
  }

  Future<void> _fetchCompetitions() async {
    final response = await http.get(Uri.parse('https://shttbentre.girc.edu.vn/api/technical-innovations'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        _competitions = data.map((json) => TechnicalCompetitionModel.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load competitions');
    }
  }

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
          final competition = _competitions[index];
          return _CompetitionCard(competition: competition);
        },
      ),
    );
  }
}

class _CompetitionCard extends StatelessWidget {
  final TechnicalCompetitionModel competition;

  const _CompetitionCard({required this.competition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TechnicalCompetitionDetailPage(competition: competition),
          ),
        );
      },
      child: Card(
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
                        const Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: Color(0xFFF57C00),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          competition.resultStatus,
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
      ),
    );
  }
}