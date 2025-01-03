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
  final ScrollController _scrollController = ScrollController();

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
      body: FutureBuilder<IndustrialDesignDetailModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);
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
                    '${l10n.error} ${snapshot.error}',
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
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: design.images.isNotEmpty ? 300 : 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
                flexibleSpace: FlexibleSpaceBar(
                  background: design.images.isNotEmpty
                      ? Image.network(
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
                        )
                      : Container(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              design.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  design.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263238),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSection(
                      title: l10n.overviewSection,
                      icon: Icons.info_outline,
                      children: [
                        _buildInfoItem(l10n.applicationNumber, design.filingNumber),
                        _buildInfoItem(l10n.filingDateLabel, _formatDate(design.filingDate)),
                        _buildInfoItem(l10n.publicationNumberLabel, design.publicationNumber),
                        _buildInfoItem(l10n.publicationDateLabel, _formatDate(design.publicationDate)),
                        _buildInfoItem(l10n.registrationNumber, design.registrationNumber),
                        _buildInfoItem(l10n.registrationDate, _formatDate(design.registrationDate)),
                        _buildInfoItem(l10n.expirationDate, _formatDate(design.expirationDate)),
                      ],
                    ),
                    _buildSection(
                      title: l10n.ownersSection,
                      icon: Icons.people_outline,
                      children: [
                        _buildInfoItem(l10n.ownerLabel, design.owner),
                        _buildInfoItem(l10n.addressLabel, design.address),
                        _buildInfoItem(l10n.inventorLabel, design.designer),
                        if (design.designerAddress != null)
                          _buildInfoItem(l10n.designerAddressLabel, design.designerAddress!),
                      ],
                    ),
                    _buildSection(
                      title: l10n.classificationSection,
                      icon: Icons.category_outlined,
                      children: [
                        _buildInfoItem(l10n.locarnoClassesLabel, design.locarnoClasses),
                        if (design.description != null)
                          _buildInfoItem(l10n.descriptionLabel, design.description!),
                      ],
                    ),
                    if (design.images.length > 1) ...[
                      Padding(
                        padding: const EdgeInsets.all(16),
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
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: design.images.length - 1,
                                itemBuilder: (context, index) {
                                  final image = design.images[index + 1];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        '${MainUrl.storageUrl}/${image.filePath}',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 120,
                                            height: 120,
                                            color: Colors.grey.withOpacity(0.1),
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey.withOpacity(0.3),
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
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF1E88E5),
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
          ),
          const Divider(height: 1),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: children.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) => children[index],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
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