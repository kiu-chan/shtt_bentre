import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class TrademarkStatisticsPage extends BaseStatisticsPage {
  TrademarkStatisticsPage({super.key})
      : super(
          title: 'Thống kê nhãn hiệu',
          baseUrl: MainUrl.trademarksUrl,
          primaryColor: Colors.orange,
          showFieldChart: true,
          showBarChart: true,
          showLineChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _TrademarkStatisticsPageState();
}

class _TrademarkStatisticsPageState extends BaseStatisticsPageState<TrademarkStatisticsPage> {}