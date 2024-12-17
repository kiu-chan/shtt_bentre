import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';

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
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 70,
          right: isRightMenuOpen ? 316 : 16,
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

class PatentInfoCard extends StatelessWidget {
  final Patent selectedPatent;
  final Function(dynamic, dynamic) onMapTap;
  final bool isRightMenuOpen;

  const PatentInfoCard({
    super.key,
    required this.selectedPatent,
    required this.onMapTap,
    required this.isRightMenuOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 70,
          right: isRightMenuOpen ? 316 : 16,
        ),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(),
                _buildPatentInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Thông tin bằng sáng chế',
          style: TextStyle(
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

  Widget _buildPatentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedPatent.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Tác giả: ${selectedPatent.inventor}'),
        Text('Địa chỉ: ${selectedPatent.inventorAddress}'),
        const SizedBox(height: 8),
        Text('Người nộp đơn: ${selectedPatent.applicant}'),
        Text('Địa chỉ: ${selectedPatent.applicantAddress}'),
      ],
    );
  }
}