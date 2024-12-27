import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class InitiativeStatisticsPage extends BaseStatisticsPage {
  const InitiativeStatisticsPage({super.key})
      : super(
          title: 'Thống kê sáng kiến',
          baseUrl: 'https://shttbentre.girc.edu.vn/api/initiatives',
          primaryColor: Colors.amber,
          showFieldChart: false, // Không có API by-type nên set false
        );

  @override
  BaseStatisticsPageState createState() => _InitiativeStatisticsPageState();
}

class _InitiativeStatisticsPageState extends BaseStatisticsPageState<InitiativeStatisticsPage> {}