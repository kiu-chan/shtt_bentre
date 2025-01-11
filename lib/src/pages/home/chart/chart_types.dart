import 'package:flutter/material.dart';

class ChartDataItem {
  final String title;
  final double value;
  final Color? color;

  ChartDataItem({
    required this.title,
    required this.value,
    this.color,
  });
}

class BarChartItem {
  final String label;
  final double value;
  final Color? color;

  BarChartItem({
    required this.label,
    required this.value,
    this.color,
  });
}

class TimeSeriesItem {
  final String label;
  final double value;
  final DateTime? date;

  TimeSeriesItem({
    required this.label,
    required this.value,
    this.date,
  });
}