import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/base_statistics_page.dart';

class IndustrialDesignStatisticsPage extends BaseStatisticsPage {
  const IndustrialDesignStatisticsPage({super.key})
      : super(
          title: 'Thống kê kiểu dáng công nghiệp',
          baseUrl: 'https://shttbentre.girc.edu.vn/api/industrial-designs',
          primaryColor: Colors.purple,
          showFieldChart: true,
        );

  @override
  BaseStatisticsPageState createState() => _IndustrialDesignStatisticsPageState();
}

class _IndustrialDesignStatisticsPageState extends BaseStatisticsPageState<IndustrialDesignStatisticsPage> {
  @override
  Color _getFieldColor(String fieldType) {
    switch (fieldType) {
      case 'Bao bì':
        return Colors.blue;
      case 'Xây dựng':
        return Colors.green;
      case 'Công cụ và Máy móc':
        return Colors.orange;
      case 'Nội thất và Hàng gia dụng':
        return Colors.purple;
      case 'Sức khỏe Dược phẩm và Mỹ phẩm':
        return Colors.red;
      case 'Nông sản và Chế biến thực phẩm':
        return Colors.teal;
      case 'Giao thông':
        return Colors.amber;
      case 'Công nghệ thông tin và truyền thông (ICT) và công nghệ nghe nhìn':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}