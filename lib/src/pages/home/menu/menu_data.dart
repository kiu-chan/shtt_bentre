import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/pages/home/about/about_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/geographical_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/industrial_design_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/initiative_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/product_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/science_innovation_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/trademark_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/menu/menu_models.dart';
import 'package:shtt_bentre/src/pages/home/news/news_list_page.dart';
import 'package:shtt_bentre/src/pages/home/chartPage/patent_statistics_page.dart';
import 'package:shtt_bentre/src/pages/home/support/industrial_design_page.dart';
import 'package:shtt_bentre/src/pages/home/support/patent_guide_page.dart';
import 'package:shtt_bentre/src/pages/home/support/trademarkt_guideg_page.dart';

List<MenuSection> getLocalizedMenuSections(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return [
    MenuSection(
      title: l10n.introduction,  // 'Giới thiệu' in Vietnamese
      icon: Icons.info,
      items: [
        MenuItem(
          title: l10n.aboutUs,  // 'Về chúng tôi' in Vietnamese
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
      title: l10n.newsAndEvents,  // 'Tin tức sự kiện' in Vietnamese
      icon: Icons.newspaper,
      items: [
        MenuItem(
          title: l10n.news,  // 'Tin tức' in Vietnamese
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
      title: l10n.consultingInformation,  // 'Thông tin tư vấn' in Vietnamese
      icon: Icons.info_outline,
      items: [
        MenuItem(
          title: l10n.trademark,  // 'Nhãn hiệu' in Vietnamese
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
          title: l10n.industrialDesign,  // 'Kiểu dáng công nghiệp' in Vietnamese
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
          title: l10n.patentsAndUtility,  // 'Sáng chế và giải pháp hữu ích' in Vietnamese
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
      title: l10n.statistics,  // 'Thống kê' in Vietnamese
      icon: Icons.search,
      items: [
        MenuItem(
          title: l10n.fullTextPatent,  // 'Sáng chế toàn văn' in Vietnamese
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatentStatisticsPage(),
              ),
            );
          },
        ),
        MenuItem(
          title: l10n.geographicalIndication,  // 'Chỉ dẫn địa lý' in Vietnamese
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeographicalStatisticsPage(),
              ),
            );
          },
        ),
        MenuItem(
          title: l10n.trademarkProtection,  // 'Bảo hộ nhãn hiệu' in Vietnamese
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrademarkStatisticsPage(),
              ),
            );
          },
        ),
        MenuItem(
          title: l10n.industrialDesignStats,  // 'Kiểu dáng công nghiệp' in Vietnamese
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndustrialDesignStatisticsPage(),
              ),
            );
          },
        ),
        MenuItem(
          title: l10n.initiative,  // 'Sáng kiến' in Vietnamese
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InitiativeStatisticsPage(),
              ),
            );
          },
        ),
        MenuItem(
          title: l10n.brandDevelopment,  // 'Sản phẩm đăng ký xây dựng, phát triển thương hiệu' in Vietnamese
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductStatisticsPage(),
              ),
            );
          },
        ),
        MenuItem(
          title: l10n.scientificResearch,  // 'Nghiên cứu khoa học và đổi mới sáng tạo' in Vietnamese
          onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScienceInnovationStatisticsPage(),
              ),
            );
          },
        ),
      ],
    ),
  ];
}