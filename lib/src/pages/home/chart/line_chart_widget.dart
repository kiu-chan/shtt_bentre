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
    return FlGridData(
      show: widget.showGridLines,
      drawVerticalLine: false,
      horizontalInterval: widget.interval,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.black.withOpacity(0.05),
          strokeWidth: 1,
          dashArray: [5, 5],
        );
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            // Hiển thị 5 mốc đều nhau trên trục x
            final dataLength = widget.data.length;
            final interval = (dataLength - 1) / 4; // Chia thành 4 khoảng để có 5 điểm
            final currentIndex = value.toInt();
            
            // Chỉ hiển thị label tại các điểm mốc
            if (currentIndex == 0 || // Điểm đầu
                currentIndex == dataLength - 1 || // Điểm cuối
                (currentIndex % interval).round() == 0) { // Các điểm ở giữa
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.data[currentIndex].label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: widget.interval,
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