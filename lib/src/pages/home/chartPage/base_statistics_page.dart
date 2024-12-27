import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shtt_bentre/src/pages/home/chart/line_chart_widget.dart';
import 'package:shtt_bentre/src/pages/home/chart/bar_chart_widget.dart';
import 'package:shtt_bentre/src/pages/home/chart/pie_chart_widget.dart';

abstract class BaseStatisticsPage extends StatefulWidget {
  final String title;
  final String baseUrl;
  final Color primaryColor;
  final bool showFieldChart;

  const BaseStatisticsPage({
    super.key,
    required this.title,
    required this.baseUrl,
    required this.primaryColor,
    this.showFieldChart = false,
  });

  @override
  BaseStatisticsPageState createState();
}

abstract class BaseStatisticsPageState<T extends BaseStatisticsPage> extends State<T> {
  bool _isLoading = true;
  List<ChartDataItem>? _fieldStatistics;
  List<BarChartItem> _locationStatistics = [];
  List<TimeSeriesItem> _yearlyStatistics = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      final yearResponse = await http.get(
        Uri.parse('${widget.baseUrl}/stats/by-year'),
      );

      var responses = [yearResponse];
      
      if (!widget.baseUrl.contains('initiatives')) {
        final districtResponse = await http.get(
          Uri.parse('${widget.baseUrl}/stats/by-district'),
        );
        responses.add(districtResponse);
      }
      
      if (widget.showFieldChart) {
        final typeResponse = await http.get(
          Uri.parse('${widget.baseUrl}/stats/by-type'),
        );
        responses.add(typeResponse);
      }

      if (responses.every((response) => response.statusCode == 200)) {
        final yearData = json.decode(yearResponse.body);
        _yearlyStatistics = (yearData['data'] as List).map((item) {
          final year = item['year']?.toString() ?? '';
          final count = item['count']?.toString() ?? '0';
          return TimeSeriesItem(
            label: year,
            value: double.tryParse(count) ?? 0.0,
          );
        }).where((item) => item.label.isNotEmpty)
        .toList()
        ..sort((a, b) => int.tryParse(a.label) ?? 0
            .compareTo(int.tryParse(b.label) ?? 0));

        if (!widget.baseUrl.contains('initiatives')) {
          final districtResponse = responses[1];
          final districtData = json.decode(districtResponse.body);
          _locationStatistics = (districtData['data'] as List).map((item) {
            final districtName = item['district_name']?.toString() ?? 'Unknown';
            final percentage = item['percentage']?.toString() ?? '0';
            return BarChartItem(
              label: _formatDistrictName(districtName),
              value: double.tryParse(percentage) ?? 0.0,
            );
          }).toList();
        }

        if (widget.showFieldChart && responses.length > 2) {
          final typeData = json.decode(responses.last.body);
          _fieldStatistics = (typeData['data'] as List).map((item) {
            final type = item['type']?.toString() ?? 'Unknown';
            final percentage = item['percentage']?.toString() ?? '0';
            return ChartDataItem(
              title: type,
              value: double.tryParse(percentage) ?? 0.0,
              color: _getFieldColor(type),
            );
          }).toList();
        }

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
    name = name.replaceAll('Huyện ', '').replaceAll('Thành phố ', '');
    return name.replaceAll(' ', '\n');
  }

  void _showError(String message) {
    if (!mounted) return;
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
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: widget.primaryColor,
      elevation: 0,
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
          tooltip: 'Làm mới dữ liệu',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: widget.primaryColor.withOpacity(0.05),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showFieldChart && _fieldStatistics != null)
              _buildChartCard(
                child: _buildFieldStatistics(),
              ),
            if (widget.showFieldChart && _fieldStatistics != null)
              const SizedBox(height: 24),
            if (!widget.baseUrl.contains('initiatives'))
              _buildChartCard(
                child: _buildLocationStatistics(),
              ),
            if (!widget.baseUrl.contains('initiatives'))
              const SizedBox(height: 24),
            _buildChartCard(
              child: _buildYearlyStatistics(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  Widget _buildFieldStatistics() {
    return PieChartWidget(
      title: 'Thống kê theo loại lĩnh vực',
      data: _fieldStatistics!,
      showLegend: true,
      enableInteraction: true,
      height: 400,
    );
  }

  Widget _buildLocationStatistics() {
    return BarChartWidget(
      title: 'Thống kê theo đơn vị hành chính',
      data: _locationStatistics,
      maxY: _calculateMaxY(_locationStatistics),
      interval: 5,
      enableTooltip: true,
      showGridLines: true,
      height: 400,
      barColor: widget.primaryColor,
      rotateLabels: true,
    );
  }

  Widget _buildYearlyStatistics() {
    return LineChartWidget(
      title: 'Thống kê theo năm',
      data: _yearlyStatistics,
      maxY: _calculateMaxY(_yearlyStatistics),
      interval: 1,
      enableTooltip: true,
      showGridLines: true,
      height: 400,
      lineColor: widget.primaryColor,
      showDots: true,
      showArea: true,
      smoothLine: true,
      showEveryNthLabel: 1,
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
    return (maxValue * 1.2).ceilToDouble();
  }
}