import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';

class CommuneInfoCard extends StatelessWidget {
  final String selectedCommuneName;
  final List<Commune> communes;
  final Function(dynamic, dynamic) onMapTap;
  final bool isRightMenuOpen;

  const CommuneInfoCard({
    super.key,
    required this.selectedCommuneName,
    required this.communes,
    required this.onMapTap,
    required this.isRightMenuOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: 70,
          right: isRightMenuOpen ? 158 : 0,
        ),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const Divider(),
                _buildCommuneInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.detailedInformation,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => onMapTap(null, null),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildCommuneInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: communes
          .where((c) => c.name == selectedCommuneName)
          .map((commune) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commune.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                      '${AppLocalizations.of(context)!.area}: ${commune.area.toStringAsFixed(2)} km²'),
                  Text(
                      '${AppLocalizations.of(context)!.population}: ${commune.population}'),
                  Text(
                      '${AppLocalizations.of(context)!.update}: ${commune.updatedYear}'),
                ],
              ))
          .toList(),
    );
  }
}