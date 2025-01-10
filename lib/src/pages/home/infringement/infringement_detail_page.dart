// lib/src/pages/infringement/infringement_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/infringement.dart';
import 'package:shtt_bentre/src/mainData/database/home/infringement.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfringementDetailPage extends StatefulWidget {
  final int id;

  const InfringementDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<InfringementDetailPage> createState() => _InfringementDetailPageState();
}

class _InfringementDetailPageState extends State<InfringementDetailPage> {
  final InfringementService _service = InfringementService();
  late Future<InfringementModel> _infringementFuture;

  @override
  void initState() {
    super.initState();
    _loadInfringementDetail();
  }

  void _loadInfringementDetail() {
    setState(() {
      _infringementFuture = _service.fetchInfringementDetail(widget.id);
    });
  }

  Color _getStatusColor(String status) {
    if (status.toLowerCase() == 'đang điều tra') {
      return const Color(0xFFFFA726);
    }
    return const Color(0xFF4CAF50);
  }

  String _formatHtmlContent(String content) {
    return content
        .replaceAll('\\u003C', '<')
        .replaceAll('\\u003E', '>')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '')
        .replaceAll('\\', '');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          l10n.violationDetails,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<InfringementModel>(
        future: _infringementFuture,
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
                    onPressed: _loadInfringementDetail,
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }

          final infringement = snapshot.data!;

          return SingleChildScrollView(
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
                                color: _getStatusColor(infringement.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(infringement.status)
                                      .withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                infringement.status,
                                style: TextStyle(
                                  color: _getStatusColor(infringement.status),
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
                                color: const Color(0xFF1E88E5).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF1E88E5).withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '${infringement.getFormattedPenaltyAmount()} VNĐ',
                                style: const TextStyle(
                                  color: Color(0xFF1E88E5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          infringement.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          '${l10n.violationContent}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Html(
                          data: _formatHtmlContent(infringement.content),
                          style: {
                            "body": Style(
                              fontSize: FontSize(14),
                              lineHeight: const LineHeight(1.5),
                              color: const Color(0xFF455A64),
                            ),
                            "a": Style(
                              color: const Color(0xFF1E88E5),
                              textDecoration: TextDecoration.none,
                            ),
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${l10n.date}: ${DateFormat('dd/MM/yyyy').format(infringement.date)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.update,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${l10n.lastUpdated}: ${DateFormat('dd/MM/yyyy HH:mm').format(infringement.updatedAt)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}