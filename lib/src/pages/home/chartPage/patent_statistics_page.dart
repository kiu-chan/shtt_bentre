import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class PatentStatisticsPage extends BaseStatisticsPage {
  const PatentStatisticsPage({super.key})
      : super(
          title: 'Thống kê sáng chế',
          baseUrl: 'https://shttbentre.girc.edu.vn/api/patents',
          primaryColor: Colors.blue,
          showFieldChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _PatentStatisticsPageState();
}

class _PatentStatisticsPageState extends BaseStatisticsPageState<PatentStatisticsPage> {}