import 'package:flutter/material.dart';
import 'guide_page.dart';

class PatentGuidePage extends StatelessWidget {
  const PatentGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GuidePage(
      title: 'Sáng chế và giải pháp hữu ích',
      parentId: 1,
      videoId: 1, // Thay đổi nếu có video
    );
  }
}