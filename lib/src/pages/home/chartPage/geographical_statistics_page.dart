import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class GeographicalStatisticsPage extends BaseStatisticsPage {
  GeographicalStatisticsPage({super.key})
      : super(
          title: 'Thống kê chỉ dẫn địa lý',
          baseUrl: MainUrl.geoIndicationUrl,
          primaryColor: Colors.green,
          showFieldChart: false,
        );

  @override
  BaseStatisticsPageState createState() => _GeographicalStatisticsPageState();
}

class _GeographicalStatisticsPageState extends BaseStatisticsPageState<GeographicalStatisticsPage> {}