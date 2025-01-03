import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/researchProject/research_project.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/researchProject/research_project_card.dart';
import 'package:shtt_bentre/src/pages/home/category/researchProject/research_project_detail_page.dart';

class ResearchProjectListPage extends StatefulWidget {
  const ResearchProjectListPage({super.key});

  @override
  State<ResearchProjectListPage> createState() => _ResearchProjectListPageState();
}

class _ResearchProjectListPageState extends State<ResearchProjectListPage> {
  final Database _service = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'NCKH & ĐMST',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: FutureBuilder<List<ResearchProjectModel>>(
        future: _service.fetchResearchProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          }
            
          final projects = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResearchProjectDetailPage(id: projects[index].id),
                    ),
                  );
                },
                child: ResearchProjectCard(project: projects[index]),
              );
            },
          );
        },
      ),
    );
  }
}

