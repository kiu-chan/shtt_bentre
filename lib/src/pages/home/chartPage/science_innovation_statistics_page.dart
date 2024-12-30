import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class ScienceInnovationStatisticsPage extends BaseStatisticsPage {
  ScienceInnovationStatisticsPage({super.key})
      : super(
          title: 'Thống kê nghiên cứu khoa học và đổi mới sáng tạo',
          baseUrl: MainUrl.scienceInnovationsUrl,
          primaryColor: Colors.indigo,
          showFieldChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _ScienceInnovationStatisticsPageState();
}

class _ScienceInnovationStatisticsPageState extends BaseStatisticsPageState<ScienceInnovationStatisticsPage> {}