import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/about/about_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/geographical_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_models.dart';
import 'package:shtt_bentre/src/pages/home/news/news_list_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/patent_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/support/industrial_design_page.dart';
import 'package:shtt_bentre/src/pages/home/support/patent_guide_page.dart';
import 'package:shtt_bentre/src/pages/home/support/trademarkt_guideg_page.dart';

final List<MenuSection> menuSections = [
  MenuSection(
    title: 'Giới thiệu',
    icon: Icons.info,
    items: [
      MenuItem(
        title: 'Về chúng tôi',
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutPage(),
            ),
          );
        },
      ),
    ],
  ),
  MenuSection(
    title: 'Tin tức sự kiện',
    icon: Icons.newspaper,
    items: [
      MenuItem(
        title: 'Tin tức', 
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewsListPage(),
            ),
          );
        },
      ),
    ],
  ),
  MenuSection(
    title: 'Thông tin tư vấn',
    icon: Icons.info_outline,
    items: [
      MenuItem(
        title: 'Nhãn hiệu', 
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TrademarkGuidePage(),
            ),
          );
        },
      ),
      MenuItem(
        title: 'Kiểu dáng công nghiệp', 
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IndustrialDesignPage(),
            ),
          );
        },
      ),
      MenuItem(
        title: 'Sáng chế và giải pháp hữu ích', 
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PatentGuidePage(),
            ),
          );
        },
      ),
    ],
  ),
  MenuSection(
    title: 'Thống kê',
    icon: Icons.search,
    items: [
      MenuItem(
        title: 'Sáng chế toàn văn', 
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PatentStatisticsPage(),
            ),
          );
        },
      ),
      MenuItem(
        title: 'Chỉ dẫn địa lý', 
        onTap: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GeographicalStatisticsPage(),
            ),
          );
        },
      ),
      MenuItem(
        title: 'Bảo hộ nhãn hiệu', 
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Kiểu dáng công nghiệp', 
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Sáng kiến', 
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Sản phẩm đăng ký xây dựng, phát triển thương hiệu',
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Nghiên cứu khoa học và đổi mới sáng tạo',
        onTap: (context) {},
      ),
    ],
  ),
];