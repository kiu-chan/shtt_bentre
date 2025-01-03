import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/data/home/technicalCompetition/technical_competition.dart';
import 'package:shtt_bentre/src/pages/home/category/technicalCompetition/technical_competition_card.dart';

class TechnicalCompetitionListPage extends StatefulWidget {
  const TechnicalCompetitionListPage({super.key});

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
          return CompetitionCard(competition: competition);
        },
      ),
    );
  }
}

