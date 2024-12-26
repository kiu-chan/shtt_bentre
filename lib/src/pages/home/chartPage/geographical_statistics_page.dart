import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class GeographicalStatisticsPage extends BaseStatisticsPage {
  const GeographicalStatisticsPage({super.key})
      : super(
          title: 'Thống kê chỉ dẫn địa lý',
          baseUrl: 'https://shttbentre.girc.edu.vn/api/geographical-indications',
          primaryColor: Colors.green,
          showFieldChart: false,
        );

  @override
  BaseStatisticsPageState createState() => _GeographicalStatisticsPageState();
}

class _GeographicalStatisticsPageState extends BaseStatisticsPageState<GeographicalStatisticsPage> {}