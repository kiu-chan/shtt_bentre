import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark_detail.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrademarkDetailPage extends StatefulWidget {
  final int id;

  const TrademarkDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<TrademarkDetailPage> createState() => _TrademarkDetailPageState();
}

class _TrademarkDetailPageState extends State<TrademarkDetailPage> {
  final Database _service = Database();
  late Future<TrademarkDetailModel> _trademarkFuture;

  @override
  void initState() {
    super.initState();
    _trademarkFuture = _service.fetchTrademarkDetail(widget.id);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.trademarkDetailTitle,
          style: const TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: FutureBuilder<TrademarkDetailModel>(
        future: _trademarkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('${l10n.error}: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${l10n.error}: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _trademarkFuture = _service.fetchTrademarkDetail(widget.id);
                      });
                    },
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }

          final trademark = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (trademark.imageUrl.isNotEmpty)
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        trademark.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey.withOpacity(0.1),
                            child: Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF9C27B0).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                trademark.typeName,
                                style: const TextStyle(
                                  color: Color(0xFF7B1FA2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                trademark.status,
                                style: const TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          trademark.mark,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.confirmation_number,
                          l10n.filingNumber,
                          trademark.filingNumber,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.confirmation_number_outlined,
                          l10n.publicationNumber,
                          trademark.publicationNumber,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.verified,
                          l10n.registrationNumber,
                          trademark.registrationNumber,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.calendar_today,
                          l10n.filingDateLabel,
                          _formatDate(trademark.filingDate),
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.calendar_month,
                          l10n.registrationDate,
                          _formatDate(trademark.registrationDate),
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.date_range,
                          l10n.publicationDateLabel,
                          _formatDate(trademark.publicationDate),
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.timer_off,
                          l10n.expirationDate,
                          _formatDate(trademark.expirationDate),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.business,
                          l10n.ownerLabel,
                          trademark.owner,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.location_on,
                          l10n.addressLabel,
                          trademark.address,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.person,
                          l10n.representativeLabel,
                          trademark.representativeName,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          Icons.location_city,
                          l10n.representativeAddressLabel,
                          trademark.representativeAddress,
                        ),
                      ],
                    ),
                  ),
                ),
                if (trademark.viennaClasses.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildInfoRow(
                        Icons.category,
                        l10n.viennaClassesLabel,
                        trademark.viennaClasses,
                      ),
                    ),
                  ),
                ],
                if (trademark.markFeature != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildInfoRow(
                        Icons.format_paint,
                        l10n.markFeatureLabel,
                        trademark.markFeature!,
                      ),
                    ),
                  ),
                ],
                if (trademark.markColors != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildInfoRow(
                        Icons.palette,
                        l10n.markColorsLabel,
                        trademark.markColors!,
                      ),
                    ),
                  ),
                ],
                if (trademark.disclaimer != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildInfoRow(
                        Icons.info_outline,
                        l10n.disclaimerLabel,
                        trademark.disclaimer!,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF1E88E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF263238),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}