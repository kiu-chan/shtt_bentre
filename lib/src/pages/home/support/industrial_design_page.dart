import 'package:flutter/material.dart';
import 'guide_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndustrialDesignPage extends StatelessWidget {
  const IndustrialDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GuidePage(
      title: l10n.industrialDesign,
      parentId: 5,
      videoId: 5, // Thay đổi nếu có video
    );
  }
}