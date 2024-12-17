import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

class BarChartWidget extends StatefulWidget {
  final List<BarChartItem> data;
  final String title;
  final double maxY;
  final double interval;
  final bool enableTooltip;
  final Color? barColor;
  final double? height;
  final bool showGridLines;
  final bool rotateLabels;

  const BarChartWidget({
    super.key,
    required this.data,
    required this.title,
    required this.maxY,
    required this.interval,
    this.enableTooltip = true,
    this.barColor,
    this.height,
    this.showGridLines = true,
    this.rotateLabels = true,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const SizedBox(height: 16),
        SizedBox(
          height: widget.height ?? 300,
          child: BarChart(
            BarChartData(
              barTouchData: _buildBarTouchData(),
              titlesData: _buildTitlesData(),
              borderData: _buildBorderData(),
              gridData: _buildGridData(),
              maxY: widget.maxY,
              minY: 0,
              barGroups: _createBarGroups(),
              alignment: BarChartAlignment.spaceAround,
            ),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
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

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      enabled: widget.enableTooltip,
      touchTooltipData: BarTouchTooltipData(
        // tooltipBgColor: Colors.black87,
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        tooltipMargin: 8,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            '${widget.data[groupIndex].label}\n',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            children: <TextSpan>[
              TextSpan(
                text: rod.toY.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
      touchCallback: (FlTouchEvent event, barTouchResponse) {
        setState(() {
          if (!event.isInterestedForInteractions ||
              barTouchResponse == null ||
              barTouchResponse.spot == null) {
            touchedIndex = -1;
            return;
          }
          touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
        });
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: widget.rotateLabels ? 40 : 30,
          getTitlesWidget: (value, meta) {
            if (value < 0 || value >= widget.data.length) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.data[value.toInt()].label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          interval: widget.interval,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: const Border(
        left: BorderSide(width: 1),
        bottom: BorderSide(width: 1),
        right: BorderSide.none,
        top: BorderSide.none,
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: widget.showGridLines,
      drawVerticalLine: false,
      horizontalInterval: widget.interval,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey[300],
          strokeWidth: 1,
        );
      },
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(widget.data.length, (index) {
      final item = widget.data[index];
      final isTouched = touchedIndex == index;
      final double width = isTouched ? 22 : 18;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.value,
            color: item.color ?? widget.barColor ?? Colors.blue,
            width: width,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: widget.maxY,
              color: Colors.grey[200],
            ),
          ),
        ],
      );
    });
  }
}