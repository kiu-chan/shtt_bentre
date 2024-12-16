import 'package:flutter/material.dart';

class ChartDataItem {
  final String title;
  final double value;
  final Color color;

  ChartDataItem({
    required this.title,
    required this.value,
    required this.color,
  });
}

class BarChartItem {
  final String label;
  final double value;

  BarChartItem({
    required this.label,
    required this.value,
  });
}

class TimeSeriesItem {
  final String year;
  final double value;

  TimeSeriesItem({
    required this.year,
    required this.value,
  });
}