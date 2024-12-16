import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

class LineChartWidget extends StatefulWidget {
  final List<TimeSeriesItem> data;
  final String title;
  final double maxY;
  final double interval;
  final bool enableTooltip;
  final Color? lineColor;
  final double? height;
  final bool showGridLines;
  final bool showDots;
  final bool showArea;
  final bool smoothLine;
  final bool rotateLabels;
  final int? showEveryNthLabel;

  const LineChartWidget({
    Key? key,
    required this.data,
    required this.title,
    required this.maxY,
    required this.interval,
    this.enableTooltip = true,
    this.lineColor,
    this.height,
    this.showGridLines = true,
    this.showDots = true,
    this.showArea = false,
    this.smoothLine = true,
    this.rotateLabels = false,
    this.showEveryNthLabel,
  }) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
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
          child: LineChart(
            LineChartData(
              lineTouchData: _buildLineTouchData(),
              gridData: _buildGridData(),
              titlesData: _buildTitlesData(),
              borderData: _buildBorderData(),
              lineBarsData: [_createLineData()],
              minX: 0,
              maxX: (widget.data.length - 1).toDouble(),
              minY: 0,
              maxY: widget.maxY,
            ),
            // swapAnimationDuration: const Duration(milliseconds: 250),
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

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: widget.enableTooltip,
      touchTooltipData: LineTouchTooltipData(
        // tooltipBgColor: Colors.black87,
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            final dataPoint = widget.data[spot.x.toInt()];
            return LineTooltipItem(
              '${dataPoint.label}\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: spot.y.toStringAsFixed(1),
                  style: TextStyle(
                    color: widget.lineColor ?? Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList();
        },
      ),
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        setState(() {
          if (!event.isInterestedForInteractions ||
              touchResponse == null ||
              touchResponse.lineBarSpots == null ||
              touchResponse.lineBarSpots!.isEmpty) {
            touchedIndex = -1;
            return;
          }
          touchedIndex = touchResponse.lineBarSpots!.first.x.toInt();
        });
      },
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: widget.showGridLines,
      drawHorizontalLine: true,
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

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: widget.rotateLabels ? 40 : 30,
          interval: widget.showEveryNthLabel?.toDouble(),
          getTitlesWidget: (value, meta) {
            if (value < 0 || value >= widget.data.length) {
              return const SizedBox();
            }

            // Show every Nth label if specified
            if (widget.showEveryNthLabel != null &&
                value.toInt() % widget.showEveryNthLabel! != 0) {
              return const SizedBox();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.data[value.toInt()].label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28, // Reduced from previous value
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
                textAlign: TextAlign.right,
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
      border: Border(
        left: const BorderSide(width: 1),
        bottom: const BorderSide(width: 1),
        right: BorderSide.none,
        top: BorderSide.none,
      ),
    );
  }

  LineChartBarData _createLineData() {
    final spots = List.generate(widget.data.length, (index) {
      return FlSpot(index.toDouble(), widget.data[index].value);
    });

    return LineChartBarData(
      spots: spots,
      isCurved: widget.smoothLine,
      preventCurveOverShooting: true,
      color: widget.lineColor ?? Colors.blue,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: widget.showDots,
        getDotPainter: (spot, percent, barData, index) {
          final isTouched = index == touchedIndex;
          return FlDotCirclePainter(
            radius: isTouched ? 6 : 4,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: widget.lineColor ?? Colors.blue,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: widget.showArea,
        color: (widget.lineColor ?? Colors.blue).withOpacity(0.15),
      ),
    );
  }
}