import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/pages/settings/login_page.dart';
import 'package:shtt_bentre/src/providers/language_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // _buildListTile(
          //   context: context,
          //   icon: Icons.person,
          //   iconColor: Colors.blue,
          //   title: localizations.loginOrRegister,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const LoginPage()),
          //     );
          //   },
          // ),
          _buildDivider(),
          _buildListTile(
            context: context,
            icon: Icons.language,
            iconColor: Colors.purple,
            title: localizations.language,
            trailing: _buildLanguageDropdown(context, languageProvider, localizations),
          ),
          _buildDivider(),
          _buildListTile(
            context: context,
            icon: Icons.info_outline,
            iconColor: Colors.green,
            title: localizations.appVersion,
            trailing: const Text(
              '1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56, // Matches the width of icon + spacing
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (onTap != null && trailing == null)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(
    BuildContext context,
    LanguageProvider languageProvider,
    AppLocalizations localizations,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: languageProvider.currentLanguage,
        underline: const SizedBox(),
        items: [
          _buildLanguageDropdownItem('en', localizations.english),
          _buildLanguageDropdownItem('vi', localizations.vietnamese),
        ],
        onChanged: (String? value) {
          if (value != null) {
            languageProvider.changeLanguage(value);
          }
        },
      ),
    );
  }

  DropdownMenuItem<String> _buildLanguageDropdownItem(String value, String label) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}