import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

class PieChartWidget extends StatefulWidget {
  final List<ChartDataItem> data;
  final String title;
  final bool enableInteraction;
  final bool showLegend;
  final double? height;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.title,
    this.enableInteraction = true,
    this.showLegend = true,
    this.height,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: widget.height ?? 300,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: widget.enableInteraction
                          ? (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex =
                                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                              });
                            }
                          : null,
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    sections: _generateSections(),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
            ),
          ],
        ),
        if (widget.showLegend) ...[
          const SizedBox(height: 16),
          _buildLegendTable(),
        ],
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    return List.generate(widget.data.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final item = widget.data[index];

      return PieChartSectionData(
        color: item.color,
        value: item.value,
        title: '${item.value.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: const [
            Shadow(
              color: Colors.black26,
              blurRadius: 2,
            ),
          ],
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  Widget _buildLegendTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildLegendHeader(),
          ...widget.data.map((item) => _buildLegendRow(item)),
        ],
      ),
    );
  }

  Widget _buildLegendHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Lĩnh vực',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              'Tỷ lệ (%)',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(ChartDataItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${item.value.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}