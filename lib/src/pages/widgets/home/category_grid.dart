import 'package:flutter/material.dart';
import '../../models/category_item.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static final List<CategoryItem> categories = [
    CategoryItem(
      title: 'Sáng chế toàn văn',
      icon: Icons.description,
    ),
    CategoryItem(
      title: 'Chỉ dẫn địa lý',
      icon: Icons.location_on,
    ),
    CategoryItem(
      title: 'Bảo hộ nhãn hiệu',
      icon: Icons.verified,
    ),
    CategoryItem(
      title: 'Kiểu dáng công nghiệp',
      icon: Icons.architecture,
    ),
    CategoryItem(
      title: 'Sáng kiến',
      icon: Icons.lightbulb,
    ),
    CategoryItem(
      title: 'Sản phẩm đăng ký xây dựng',
      icon: Icons.business,
    ),
    CategoryItem(
      title: 'Nghiên cứu khoa học',
      icon: Icons.science,
    ),
    CategoryItem(
      title: 'Hội thi sáng tạo',
      icon: Icons.emoji_events,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          const Text(
            'DANH MỤC',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(categories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryItem category) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            category.icon,
            color: Colors.blue,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}