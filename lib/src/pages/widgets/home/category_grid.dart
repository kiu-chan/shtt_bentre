import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/pages/home/category/geo_indication/geo_indication_list_page.dart';
import 'package:shtt_bentre/src/pages/home/category/industrialDesign/industrial_design_list_page.dart';
import 'package:shtt_bentre/src/pages/home/category/initiative/initiative_list_page.dart';
import 'package:shtt_bentre/src/pages/home/category/patent/patent_list_page.dart';
import 'package:shtt_bentre/src/pages/home/category/productRegistration/product_registration_list_page.dart';
import 'package:shtt_bentre/src/pages/home/category/researchProject/research_project_list_page.dart';
import 'package:shtt_bentre/src/pages/home/category/technicalCompetition/technical_competition_list_page.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_list_page.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    final categories = [
      _Category(
        title: localizations.inventions,
        icon: Icons.description,
        route: const PatentListPage(),
      ),
      _Category(
        title: localizations.geoIndications,
        icon: Icons.location_on,
        route: const GeoIndicationListPage(),
      ),
      _Category(
        title: localizations.trademarks,
        icon: Icons.verified, 
        route: const TrademarkListPage(),
      ),
      _Category(
        title: localizations.industrialDesigns,
        icon: Icons.architecture,
        route: const IndustrialDesignListPage(),
      ),
      _Category(
        title: localizations.initiatives,
        icon: Icons.lightbulb,
        route: const InitiativeListPage(),
      ),
      _Category(
        title: localizations.productRegistrations,
        icon: Icons.business,
        route: const ProductRegistrationListPage(),
      ),
      _Category(
        title: localizations.researchProjects,
        icon: Icons.science,
        route: const ResearchProjectListPage(),
      ),
      _Category(
        title: localizations.technicalCompetitions,
        icon: Icons.emoji_events,
        route: const TechnicalCompetitionListPage(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Text(
            localizations.categories.toUpperCase(),  
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryItem(category: category);
            },
          ),
        ],
      ),
    );
  }
}

class _Category {
  final String title;
  final IconData icon;
  final Widget route;

  _Category({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => category.route));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              category.icon,
              color: Colors.blue,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}