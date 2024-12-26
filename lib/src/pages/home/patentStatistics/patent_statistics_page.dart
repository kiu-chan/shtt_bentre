import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chart/line_chart_widget.dart';
import 'package:shtt_bentre/src/pages/home/chart/bar_chart_widget.dart';
import 'package:shtt_bentre/src/pages/home/chart/pie_chart_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      setState(() => _isLoading = true);

      // Fetch data from all three endpoints
      final typeResponse = await http.get(Uri.parse(
          'https://shttbentre.girc.edu.vn/api/patents/stats/by-type'));
      final yearResponse = await http.get(Uri.parse(
          'https://shttbentre.girc.edu.vn/api/patents/stats/by-year'));
      final districtResponse = await http.get(Uri.parse(
          'https://shttbentre.girc.edu.vn/api/patents/stats/by-district'));

      if (typeResponse.statusCode == 200 &&
          yearResponse.statusCode == 200 &&
          districtResponse.statusCode == 200) {
        
        // Parse field statistics
        final typeData = json.decode(typeResponse.body);
        _fieldStatistics = (typeData['data'] as List).map((item) {
          return ChartDataItem(
            title: item['type'],
            value: double.parse(item['percentage']),
            color: _getFieldColor(item['type']),
          );
        }).toList();

        // Parse location statistics
        final districtData = json.decode(districtResponse.body);
        _locationStatistics = (districtData['data'] as List).map((item) {
          return BarChartItem(
            label: _formatDistrictName(item['district_name']),
            value: double.parse(item['percentage']),
          );
        }).toList();

        // Parse yearly statistics and sort by year
        final yearData = json.decode(yearResponse.body);
        _yearlyStatistics = (yearData['data'] as List).map((item) {
          return TimeSeriesItem(
            label: item['year'],
            value: item['count'].toDouble(),
          );
        }).toList()..sort((a, b) => int.parse(a.label).compareTo(int.parse(b.label)));

        setState(() => _isLoading = false);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Có lỗi khi tải dữ liệu: ${e.toString()}');
    }
  }

  Color _getFieldColor(String fieldType) {
    switch (fieldType) {
      case 'Không được phân loại':
        return Colors.amber;
      case 'Hóa học':
        return Colors.blue;
      case 'Kỹ thuật cơ khí':
        return Colors.pink[100]!;
      case 'Kỹ thuật điện':
        return Colors.green[200]!;
      case 'Dụng cụ':
        return Colors.purple[200]!;
      default:
        return Colors.grey;
    }
  }

  String _formatDistrictName(String name) {
    // Remove 'Huyện ' or 'Thành phố ' prefix and split into two lines
    name = name.replaceAll('Huyện ', '').replaceAll('Thành phố ', '');
    return name.replaceAll(' ', '\n');
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
            onPressed: _loadData,
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
          maxY: _calculateMaxY(_locationStatistics),
          interval: 5,
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
          maxY: _calculateMaxY(_yearlyStatistics),
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

  double _calculateMaxY(List<dynamic> items) {
    double maxValue = 0;
    for (var item in items) {
      if (item is TimeSeriesItem && item.value > maxValue) {
        maxValue = item.value;
      } else if (item is BarChartItem && item.value > maxValue) {
        maxValue = item.value;
      }
    }
    return (maxValue * 1.2).ceilToDouble(); // Add 20% padding
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