import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_data.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final menuSections = getLocalizedMenuSections(context);
    
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: menuSections.map((section) {
                return _buildMenuSection(context, section);
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          _buildContactInfo(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appTitle,  // Add this to ARB files: "SHTT BẾN TRE"
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.appSubtitle,  // Add this to ARB files: "HỆ THỐNG QUẢN LÝ SỞ HỮU TRÍ TUỆ"
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, MenuSection section) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        leading: Icon(
          section.icon,
          color: Colors.blue[700],
          size: 24,
        ),
        title: Text(
          section.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        childrenPadding: EdgeInsets.zero,
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        children: section.items.map((item) {
          return InkWell(
            onTap: () => item.onTap(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 64,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.headset_mic,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.contactSupport,  // Add this to ARB files: "Liên hệ hỗ trợ"
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                '+8490 403 11 03',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.email,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                'girc.tuaf@gmail.com',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}