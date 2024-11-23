import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PatentStatisticsPage extends StatefulWidget {
  const PatentStatisticsPage({super.key});

  @override
  State<PatentStatisticsPage> createState() => _PatentStatisticsPageState();
}

class _PatentStatisticsPageState extends State<PatentStatisticsPage> {
  final List<ChartData> pieChartData = [
    ChartData(
      title: 'Không được phân loại',
      value: 60.0,
      color: Colors.amber,
    ),
    ChartData(
      title: 'Hóa học',
      value: 20.0,
      color: Colors.blue,
    ),
    ChartData(
      title: 'Kỹ thuật cơ khí',
      value: 10.0,
      color: Colors.pink[100]!,
    ),
    ChartData(
      title: 'Kỹ thuật điện',
      value: 6.7,
      color: Colors.green[200]!,
    ),
    ChartData(
      title: 'Dụng cụ',
      value: 3.3,
      color: Colors.purple[200]!,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê sáng chế'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Thống kê sáng chế theo loại lĩnh vực'),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: pieChartData.map((data) => PieChartSectionData(
                          value: data.value,
                          color: data.color,
                          title: '',
                          radius: 100,
                          showTitle: false,
                        )).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Legend Table
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
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
                  ),
                  ...pieChartData.map((data) => Container(
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
                                  color: data.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data.title,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${data.value.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Thống kê số liệu sáng chế theo đơn vị hành chính'),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  minY: 0,
                  maxY: 12,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = [
                            'Giồng\nTrôm',
                            'Bến\nTre',
                            'Mỏ Cày\nNam',
                            'Châu\nThành',
                            'Bình\nĐại',
                            'Ba\nTri',
                            'Chợ\nLách',
                            'Thạnh\nPhú'
                          ];
                          if (value.toInt() < 0 || value.toInt() >= titles.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              titles[value.toInt()],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.blue)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.blue)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2, color: Colors.blue)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7, color: Colors.blue)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 2, color: Colors.blue)]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 1, color: Colors.blue)]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 2, color: Colors.blue)]),
                    BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 1, color: Colors.blue)]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Thống kê sáng chế theo năm'),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 6,
                  baselineY: 0,
                  lineTouchData: LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1), // 1996
                        FlSpot(1, 1), // 2005
                        FlSpot(2, 1), // 2006
                        FlSpot(3, 3), // 2007
                        FlSpot(4, 1), // 2008
                        FlSpot(5, 1), // 2009
                        FlSpot(6, 1), // 2010
                        FlSpot(7, 1), // 2011
                        FlSpot(8, 1), // 2013
                        FlSpot(9, 1), // 2015
                        FlSpot(10, 4), // 2016
                        FlSpot(11, 1), // 2017
                        FlSpot(12, 1), // 2018
                        FlSpot(13, 1), // 2019
                        FlSpot(14, 3), // 2021
                        FlSpot(15, 1), // 2022
                        FlSpot(16, 5), // 2023
                        FlSpot(17, 1), // 2024
                      ],
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: Colors.blue,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue,
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const years = [
                            '1996', '2005', '2006', '2007', '2008', '2009', 
                            '2010', '2011', '2013', '2015', '2016', '2017',
                            '2018', '2019', '2021', '2022', '2023', '2024'
                          ];
                          if (value.toInt() < 0 || value.toInt() >= years.length) {
                            return const SizedBox();
                          }
                          if (value.toInt() % 2 == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                years[value.toInt()],
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ChartData {
  final String title;
  final double value;
  final Color color;

  ChartData({
    required this.title,
    required this.value,
    required this.color,
  });
}