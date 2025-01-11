import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shtt_bentre/src/pages/home/chart/chart_types.dart';
import 'dart:math' as math;

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
    super.key,
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
  });

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
        const SizedBox(height: 24),
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
              clipData: const FlClipData.all(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: widget.enableTooltip,
      touchTooltipData: LineTouchTooltipData(
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            final dataPoint = widget.data[spot.x.toInt()];
            return LineTooltipItem(
              '${dataPoint.label}\n',
              const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: spot.y.toStringAsFixed(1),
                  style: TextStyle(
                    color: widget.lineColor?.withOpacity(0.9) ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
    // Tính khoảng cách cho lưới dọc và ngang với kiểm tra giá trị tối thiểu
    final yInterval = math.max(widget.maxY / 4, 1.0); // Đảm bảo interval tối thiểu là 1
    final xInterval = math.max((widget.data.length - 1) / 4, 1.0); // Đảm bảo interval tối thiểu là 1

    return FlGridData(
      show: widget.showGridLines,
      drawVerticalLine: true, // Hiển thị cả lưới dọc
      horizontalInterval: yInterval,
      verticalInterval: xInterval,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.black.withOpacity(0.1),
          strokeWidth: 1,
          dashArray: [5, 5],
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.black.withOpacity(0.1),
          strokeWidth: 1,
          dashArray: [5, 5],
        );
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    // Đảm bảo interval luôn lớn hơn 0
    final xInterval = math.max((widget.data.length - 1) / 4, 1.0);
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: xInterval,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= widget.data.length) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.data[index].label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
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
          reservedSize: 40,
          interval: math.max(widget.maxY / 4, 1.0), // Đảm bảo interval tối thiểu là 1
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
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
        left: BorderSide(color: Colors.black.withOpacity(0.1)),
        bottom: BorderSide(color: Colors.black.withOpacity(0.1)),
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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (widget.lineColor ?? Colors.blue).withOpacity(0.15),
            (widget.lineColor ?? Colors.blue).withOpacity(0.05),
          ],
        ),
      ),
    );
  }
}