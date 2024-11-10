import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_models.dart';

final List<MenuSection> menuSections = [
  MenuSection(
    title: 'Tin tức sự kiện',
    icon: Icons.newspaper,
    items: [
      MenuItem(title: 'Tin tức', onTap: () {}),
      MenuItem(title: 'Hoạt động khoa học, công nghệ', onTap: () {}),
    ],
  ),
  MenuSection(
    title: 'Thông tin tư vấn',
    icon: Icons.info_outline,
    items: [
      MenuItem(title: 'Nhãn hiệu', onTap: () {}),
      MenuItem(title: 'Kiểu dáng công nghiệp', onTap: () {}),
      MenuItem(title: 'Sáng chế và giải pháp hữu ích', onTap: () {}),
    ],
  ),
  MenuSection(
    title: 'Tra cứu thống kê',
    icon: Icons.search,
    items: [
      MenuItem(title: 'Sáng chế toàn văn', onTap: () {}),
      MenuItem(title: 'Chỉ dẫn địa lý', onTap: () {}),
      MenuItem(title: 'Bảo hộ nhãn hiệu', onTap: () {}),
      MenuItem(title: 'Kiểu dáng công nghiệp', onTap: () {}),
      MenuItem(title: 'Sáng kiến', onTap: () {}),
      MenuItem(
        title: 'Sản phẩm đăng ký xây dựng, phát triển thương hiệu',
        onTap: () {},
      ),
      MenuItem(
        title: 'Nghiên cứu khoa học và đổi mới sáng tạo',
        onTap: () {},
      ),
    ],
  ),
];