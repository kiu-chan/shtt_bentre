import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chart/%20line_chart_widget.dart';
import 'package:shtt_bentre/src/pages/home/chart/bar_chart_widget.dart';
import 'dart:convert';

import 'package:shtt_bentre/src/pages/home/chart/pie_chart_widget.dart';

class PatentStatisticsPage extends StatefulWidget {
  const PatentStatisticsPage({super.key});

  @override
  State<PatentStatisticsPage> createState() => _PatentStatisticsPageState();
}

class _PatentStatisticsPageState extends State<PatentStatisticsPage> {
  bool _isLoading = true;
  late List<ChartDataItem> _fieldStatistics;
  late List<BarChartItem> _locationStatistics;
  late List<TimeSeriesItem> _yearlyStatistics;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Initialize data
      _fieldStatistics = [
        ChartDataItem(
          title: 'Không được phân loại',
          value: 60.0,
          color: Colors.amber,
        ),
        ChartDataItem(
          title: 'Hóa học',
          value: 20.0,
          color: Colors.blue,
        ),
        ChartDataItem(
          title: 'Kỹ thuật cơ khí',
          value: 10.0,
          color: Colors.pink[100]!,
        ),
        ChartDataItem(
          title: 'Kỹ thuật điện',
          value: 6.7,
          color: Colors.green[200]!,
        ),
        ChartDataItem(
          title: 'Dụng cụ',
          value: 3.3,
          color: Colors.purple[200]!,
        ),
      ];

      _locationStatistics = [
        BarChartItem(label: 'Giồng\nTrôm', value: 5.0),
        BarChartItem(label: 'Bến\nTre', value: 10.0),
        BarChartItem(label: 'Mỏ Cày\nNam', value: 2.0),
        BarChartItem(label: 'Châu\nThành', value: 7.0),
        BarChartItem(label: 'Bình\nĐại', value: 2.0),
        BarChartItem(label: 'Ba\nTri', value: 1.0),
        BarChartItem(label: 'Chợ\nLách', value: 2.0),
        BarChartItem(label: 'Thạnh\nPhú', value: 1.0),
      ];

      _yearlyStatistics = [
        TimeSeriesItem(label: '1996', value: 1),
        TimeSeriesItem(label: '2005', value: 1),
        TimeSeriesItem(label: '2006', value: 1),
        TimeSeriesItem(label: '2007', value: 3),
        TimeSeriesItem(label: '2008', value: 1),
        TimeSeriesItem(label: '2009', value: 1),
        TimeSeriesItem(label: '2010', value: 1),
        TimeSeriesItem(label: '2011', value: 1),
        TimeSeriesItem(label: '2013', value: 1),
        TimeSeriesItem(label: '2015', value: 1),
        TimeSeriesItem(label: '2016', value: 4),
        TimeSeriesItem(label: '2017', value: 1),
        TimeSeriesItem(label: '2018', value: 1),
        TimeSeriesItem(label: '2019', value: 1),
        TimeSeriesItem(label: '2021', value: 3),
        TimeSeriesItem(label: '2022', value: 1),
        TimeSeriesItem(label: '2023', value: 5),
        TimeSeriesItem(label: '2024', value: 1),
      ];

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Có lỗi khi tải dữ liệu');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê sáng chế'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildFieldStatistics(),
                    const SizedBox(height: 32),
                    _buildLocationStatistics(),
                    const SizedBox(height: 32),
                    _buildYearlyStatistics(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFieldStatistics() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChartWidget(
          title: 'Thống kê sáng chế theo loại lĩnh vực',
          data: _fieldStatistics,
          showLegend: true,
          enableInteraction: true,
          height: 400,
        ),
      ),
    );
  }

  Widget _buildLocationStatistics() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChartWidget(
          title: 'Thống kê số liệu sáng chế theo đơn vị hành chính',
          data: _locationStatistics,
          maxY: 12,
          interval: 2,
          enableTooltip: true,
          showGridLines: true,
          height: 400,
          barColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildYearlyStatistics() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChartWidget(
          title: 'Thống kê sáng chế theo năm',
          data: _yearlyStatistics,
          maxY: 6,
          interval: 1,
          enableTooltip: true,
          showGridLines: true,
          height: 400,
          lineColor: Colors.blue,
          showDots: true,
          showArea: true,
          smoothLine: true,
          showEveryNthLabel: 2,
        ),
      ),
    );
  }

  Future<void> _exportData() async {
    try {
      final data = {
        'field_statistics': _fieldStatistics
            .map((item) => {
                  'title': item.title,
                  'value': item.value,
                })
            .toList(),
        'location_statistics': _locationStatistics
            .map((item) => {
                  'location': item.label,
                  'count': item.value,
                })
            .toList(),
        'yearly_statistics': _yearlyStatistics
            .map((item) => {
                  'year': item.label,
                  'count': item.value,
                })
            .toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      
      // In thực tế, bạn có thể lưu file hoặc chia sẻ dữ liệu
      print(jsonString);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xuất dữ liệu thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showError('Có lỗi khi xuất dữ liệu');
    }
  }
}