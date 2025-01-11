import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shtt_bentre/src/pages/home/chart/chart_types.dart';

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

  // Danh sách màu cố định cho biểu đồ
  static const List<Color> chartColors = [
    // Màu cơ bản
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.brown,
    Colors.deepOrange,
    
    // Biến thể sáng
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.lime,
    Colors.blueGrey,
    
    // Sắc thái khác của màu xanh
    Color(0xFF1E88E5), // Blue[600]
    Color(0xFF1976D2), // Blue[700]
    Color(0xFF0277BD), // LightBlue[800]
    Color(0xFF00838F), // Cyan[800]
    Color(0xFF00695C), // Teal[800]
    
    // Sắc thái khác của màu đỏ/cam
    Color(0xFFE53935), // Red[600]
    Color(0xFFD84315), // DeepOrange[800]
    Color(0xFFF4511E), // DeepOrange[600]
    Color(0xFFFB8C00), // Orange[800]
    Color(0xFFFF8F00), // Amber[800]
    
    // Sắc thái khác của màu tím/hồng
    Color(0xFF8E24AA), // Purple[600]
    Color(0xFF5E35B1), // DeepPurple[600]
    Color(0xFF3949AB), // Indigo[600]
    Color(0xFFD81B60), // Pink[600]
    Color(0xFFC2185B), // Pink[700]
    
    // Sắc thái khác của màu xanh lá
    Color(0xFF2E7D32), // Green[800]
    Color(0xFF388E3C), // Green[700]
    Color(0xFF00897B), // Teal[600]
    Color(0xFF00796B), // Teal[700]
    Color(0xFF0097A7), // Cyan[700]
    
    // Màu trung tính
    Colors.grey,
    Colors.blueGrey,
    Color(0xFF455A64), // BlueGrey[700]
    Color(0xFF616161), // Grey[700]
    Color(0xFF424242), // Grey[800]
  ];

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int? touchedIndex;

  // Helper method để lấy màu theo index
  Color _getColorForIndex(int index) {
    return PieChartWidget.chartColors[index % PieChartWidget.chartColors.length];
  }

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
                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              });
                            }
                          : null,
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    sections: _generateSections(),
                  ),
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

  List<PieChartSectionData> _generateSections() {
    return List.generate(widget.data.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final item = widget.data[index];

      return PieChartSectionData(
        color: _getColorForIndex(index),  // Sử dụng màu từ danh sách cố định
        value: item.value,
        title: '${item.value.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: const [Shadow(color: Colors.black26, blurRadius: 2)],
        ),
        badgePositionPercentageOffset: .98,
      );
    });
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

  Widget _buildLegendTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildLegendHeader(),
          ...List.generate(widget.data.length, (index) => 
            _buildLegendRow(widget.data[index], _getColorForIndex(index)),
          ),
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

  Widget _buildLegendRow(ChartDataItem item, Color color) {
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
                    color: color,  // Sử dụng màu được truyền vào
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