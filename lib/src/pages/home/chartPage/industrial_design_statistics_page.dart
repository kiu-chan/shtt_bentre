import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class IndustrialDesignStatisticsPage extends BaseStatisticsPage {
  const IndustrialDesignStatisticsPage({super.key})
      : super(
          title: 'Thống kê kiểu dáng công nghiệp',
          baseUrl: 'https://shttbentre.girc.edu.vn/api/industrial-designs',
          primaryColor: Colors.purple,
          showFieldChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _IndustrialDesignStatisticsPageState();
}

class _IndustrialDesignStatisticsPageState extends BaseStatisticsPageState<IndustrialDesignStatisticsPage> {
}