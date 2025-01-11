import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrialDesign/industrial_design_detail.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndustrialDesignDetailPage extends StatefulWidget {
  final String id;

  const IndustrialDesignDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<IndustrialDesignDetailPage> createState() => _IndustrialDesignDetailPageState();
}

class _IndustrialDesignDetailPageState extends State<IndustrialDesignDetailPage> {
  final Database _service = Database();
  late Future<IndustrialDesignDetailModel> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _service.fetchIndustrialDesignDetail(widget.id);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'đã cấp bằng':
        return const Color(0xFF4CAF50);
      case 'hết hạn':
        return const Color(0xFF9E9E9E);
      case 'từ chối':
        return const Color(0xFFF44336);
      case 'đang chờ xử lý':
        return const Color(0xFFFFA726);
      default:
        return const Color(0xFF9E9E9E);
    }
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
          l10n.industrialDesign,
          style: const TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: FutureBuilder<IndustrialDesignDetailModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
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
                        _detailFuture = _service.fetchIndustrialDesignDetail(widget.id);
                      });
                    },
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }

          final design = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (design.images.isNotEmpty)
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          '${MainUrl.storageUrl}/${design.images[0].filePath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.withOpacity(0.1),
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            design.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        shadowColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Color(0xFFFAFAFA)],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(design.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _getStatusColor(design.status).withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  design.status,
                                  style: TextStyle(
                                    color: _getStatusColor(design.status),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildInfoSection(
                                l10n.overviewSection,
                                Icons.info_outline,
                                [
                                  _buildInfoItem(l10n.applicationNumber, design.filingNumber),
                                  _buildInfoItem(l10n.filingDateLabel, _formatDate(design.filingDate)),
                                  _buildInfoItem(l10n.publicationNumberLabel, design.publicationNumber),
                                  _buildInfoItem(l10n.publicationDateLabel, _formatDate(design.publicationDate)),
                                  _buildInfoItem(l10n.registrationNumber, design.registrationNumber),
                                  _buildInfoItem(l10n.registrationDate, _formatDate(design.registrationDate)),
                                  _buildInfoItem(l10n.expirationDate, _formatDate(design.expirationDate)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildInfoSection(
                                l10n.ownersSection,
                                Icons.people_outline,
                                [
                                  _buildInfoItem(l10n.ownerLabel, design.owner),
                                  _buildInfoItem(l10n.addressLabel, design.address),
                                  _buildInfoItem(l10n.inventorLabel, design.designer),
                                  if (design.designerAddress != null)
                                    _buildInfoItem(l10n.designerAddressLabel, design.designerAddress!),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildInfoSection(
                                l10n.classificationSection,
                                Icons.category_outlined,
                                [
                                  _buildInfoItem(l10n.locarnoClassesLabel, design.locarnoClasses),
                                  if (design.description != null)
                                    _buildInfoItem(l10n.descriptionLabel, design.description!),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (design.images.length > 1) ...[
                        const SizedBox(height: 24),
                        Card(
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, Color(0xFFFAFAFA)],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.photo_library_outlined,
                                      color: Color(0xFF1E88E5),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.otherImagesLabel,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E88E5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: design.images.length - 1,
                                    itemBuilder: (context, index) {
                                      final image = design.images[index + 1];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            '${MainUrl.storageUrl}/${image.filePath}',
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 200,
                                                height: 200,
                                                color: Colors.grey.withOpacity(0.1),
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                  size: 48,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF1E88E5),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF263238),
            ),
          ),
        ],
      ),
    );
  }
}