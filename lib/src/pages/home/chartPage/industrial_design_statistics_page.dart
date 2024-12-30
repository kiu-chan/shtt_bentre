import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class IndustrialDesignStatisticsPage extends BaseStatisticsPage {
  IndustrialDesignStatisticsPage({super.key})
      : super(
          title: 'Thống kê kiểu dáng công nghiệp',
          baseUrl: MainUrl.industrialDesignUrl,
          primaryColor: Colors.purple,
          showFieldChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _IndustrialDesignStatisticsPageState();
}

class _IndustrialDesignStatisticsPageState extends BaseStatisticsPageState<IndustrialDesignStatisticsPage> {
}