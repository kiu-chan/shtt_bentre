import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class TrademarkStatisticsPage extends BaseStatisticsPage {
  const TrademarkStatisticsPage({super.key})
      : super(
          title: 'Thống kê nhãn hiệu',
          baseUrl: 'https://shttbentre.girc.edu.vn/api/trademarks',
          primaryColor: Colors.orange,
          showFieldChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _TrademarkStatisticsPageState();
}

class _TrademarkStatisticsPageState extends BaseStatisticsPageState<TrademarkStatisticsPage> {}