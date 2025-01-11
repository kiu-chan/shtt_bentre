import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class ProductStatisticsPage extends BaseStatisticsPage {
  ProductStatisticsPage({super.key})
      : super(
          title: 'Thống kê sản phẩm xây dựng, phát triển thương hiệu',
          baseUrl: MainUrl.productsUrl,
          primaryColor: Colors.cyan,
          showFieldChart: false,
          showLineChart: true,
          showBarChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _ProductStatisticsPageState();
}

class _ProductStatisticsPageState extends BaseStatisticsPageState<ProductStatisticsPage> {}