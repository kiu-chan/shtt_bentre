import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/geo_indication/geo_indication_list_page.dart';
import 'package:shtt_bentre/src/pages/home/industrialDesign/industrial_design_list_page.dart';
import 'package:shtt_bentre/src/pages/home/initiative/initiative_list_page.dart';
import 'package:shtt_bentre/src/pages/home/patent/patent_list_page.dart';
import 'package:shtt_bentre/src/pages/home/productRegistration/product_registration_list_page.dart';
import 'package:shtt_bentre/src/pages/home/researchProject/research_project_list_page.dart';
import 'package:shtt_bentre/src/pages/home/technicalCompetition/technical_competition_list_page.dart';
import 'package:shtt_bentre/src/pages/home/trademark/trademark_list_page.dart';
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
              return _buildCategoryItem(context, categories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem category) {
    return InkWell(
      onTap: () => _handleCategoryTap(context, category.title),
      child: Column(
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
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
      ),
    );
  }

  void _handleCategoryTap(BuildContext context, String categoryTitle) {
    switch (categoryTitle) {
      case 'Sáng chế toàn văn':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PatentListPage()),
        );
        break;
      case 'Chỉ dẫn địa lý':
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const GeoIndicationListPage()),
        );
        break;
      case 'Bảo hộ nhãn hiệu':
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const TrademarkListPage()),
        );
        break;
      case 'Kiểu dáng công nghiệp':
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const IndustrialDesignListPage()),
        );
        break;
      case 'Sáng kiến':
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const InitiativeListPage()),
        );
        break;
      case 'Sản phẩm đăng ký xây dựng':
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const ProductRegistrationListPage()),
        );
        break;
      case 'Nghiên cứu khoa học':
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const ResearchProjectListPage()),
        );
        break;
      case 'Hội thi sáng tạo':
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const TechnicalCompetitionListPage()),
        );
        break;
    }
  }
}