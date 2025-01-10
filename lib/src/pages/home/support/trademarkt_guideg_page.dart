import 'package:flutter/material.dart';
import 'guide_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrademarkGuidePage extends StatelessWidget {
  const TrademarkGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GuidePage(
      title: l10n.trademarkGuide,
      parentId: 4,
      videoId: 4,
    );
  }
}