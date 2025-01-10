import 'package:flutter/material.dart';
import 'guide_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatentGuidePage extends StatelessWidget {
  const PatentGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GuidePage(
      title: l10n.patentsAndUtility,
      parentId: 1,
      videoId: 1, // Thay đổi nếu có video
    );
  }
}