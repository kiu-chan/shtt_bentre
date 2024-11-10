import 'package:flutter/material.dart';

class MenuSection {
  final String title;
  final IconData icon;
  final List<MenuItem> items;

  MenuSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class MenuItem {
  final String title;
  final Function(BuildContext context) onTap;

  MenuItem({
    required this.title,
    required this.onTap,
  });
}