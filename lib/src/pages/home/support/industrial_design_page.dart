import 'package:flutter/material.dart';
import 'guide_page.dart';

class IndustrialDesignPage extends StatelessWidget {
  const IndustrialDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GuidePage(
      title: 'Kiểu dáng công nghiệp',
      parentId: 5,
      videoId: 5, // Thay đổi nếu có video
    );
  }
}