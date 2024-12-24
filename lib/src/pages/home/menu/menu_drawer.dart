import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_data.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_models.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              children: menuSections.map((section) {
                return _buildMenuSection(context, section);
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          _buildContactInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      width: double.infinity,
      color: Colors.blue,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MENU',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, MenuSection section) {
    return ExpansionTile(
      leading: Icon(section.icon),
      title: Text(
        section.title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: section.items.map((item) {
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 72, right: 16),
          title: Text(
            item.title,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
          onTap: () => item.onTap(context),
        );
      }).toList(),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Liên hệ hỗ trợ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Điện thoại: +8490 403 11 03',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Email: girc.tuaf@gmail.com',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}