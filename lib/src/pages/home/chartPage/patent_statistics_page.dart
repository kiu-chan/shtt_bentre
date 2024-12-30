import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class PatentStatisticsPage extends BaseStatisticsPage {
  PatentStatisticsPage({super.key})
      : super(
          title: 'Thống kê sáng chế',
          baseUrl: MainUrl.patentUrl,
          primaryColor: Colors.blue,
          showFieldChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _PatentStatisticsPageState();
}

class _PatentStatisticsPageState extends BaseStatisticsPageState<PatentStatisticsPage> {}