import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/about/about_page.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_models.dart';

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
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Hoạt động khoa học, công nghệ', 
        onTap: (context) {},
      ),
    ],
  ),
  MenuSection(
    title: 'Thông tin tư vấn',
    icon: Icons.info_outline,
    items: [
      MenuItem(
        title: 'Nhãn hiệu', 
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Kiểu dáng công nghiệp', 
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Sáng chế và giải pháp hữu ích', 
        onTap: (context) {},
      ),
    ],
  ),
  MenuSection(
    title: 'Tra cứu thống kê',
    icon: Icons.search,
    items: [
      MenuItem(
        title: 'Sáng chế toàn văn', 
        onTap: (context) {},
      ),
      MenuItem(
        title: 'Chỉ dẫn địa lý', 
        onTap: (context) {},
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