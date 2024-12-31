import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication_detail_model.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GeoIndicationDetailPage extends StatefulWidget {
  final int stt;

  const GeoIndicationDetailPage({
    super.key,
    required this.stt,
  });

  @override
  State<GeoIndicationDetailPage> createState() => _GeoIndicationDetailPageState();
}

class _GeoIndicationDetailPageState extends State<GeoIndicationDetailPage> {
  final Database _service = Database();
  late Future<GeoIndicationDetailModel> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _service.fetchGeoIndicationDetail(widget.stt);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  String _formatHtmlContent(String? content) {
    if (content == null || content.isEmpty) return '';

    return content
        .replaceAll('&Agrave;', 'À')
        .replaceAll('&agrave;', 'à')
        .replaceAll('&Aacute;', 'Á')
        .replaceAll('&aacute;', 'á')
        .replaceAll('&Acirc;', 'Â')
        .replaceAll('&acirc;', 'â')
        .replaceAll('&Atilde;', 'Ã')
        .replaceAll('&atilde;', 'ã')
        .replaceAll('&Egrave;', 'È')
        .replaceAll('&egrave;', 'è')
        .replaceAll('&Eacute;', 'É')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&Ecirc;', 'Ê')
        .replaceAll('&ecirc;', 'ê')
        .replaceAll('&Igrave;', 'Ì')
        .replaceAll('&igrave;', 'ì')
        .replaceAll('&Iacute;', 'Í')
        .replaceAll('&iacute;', 'í')
        .replaceAll('&Ograve;', 'Ò')
        .replaceAll('&ograve;', 'ò')
        .replaceAll('&Oacute;', 'Ó')
        .replaceAll('&oacute;', 'ó')
        .replaceAll('&Ocirc;', 'Ô')
        .replaceAll('&ocirc;', 'ô')
        .replaceAll('&Otilde;', 'Õ')
        .replaceAll('&otilde;', 'õ')
        .replaceAll('&Ugrave;', 'Ù')
        .replaceAll('&ugrave;', 'ù')
        .replaceAll('&Uacute;', 'Ú')
        .replaceAll('&uacute;', 'ú')
        .replaceAll('&Yacute;', 'Ý')
        .replaceAll('&yacute;', 'ý')
        .replaceAll('\\u0026', '&')
        .replaceAll('\\u003E', '>')
        .replaceAll('\\u003C', '<')
        .replaceAll('\\"', '"')
        .replaceAll('\\r\\n', '\n')
        .replaceAll('\\n', '\n')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
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
          l10n.geoIndicationDetail,
          style: const TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: FutureBuilder<GeoIndicationDetailModel>(
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
                        _detailFuture = _service.fetchGeoIndicationDetail(widget.stt);
                      });
                    },
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            );
          }

          final detail = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection(l10n.productName, detail.tenSanPham),
                        if (detail.soDon != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoSection(l10n.applicationNumber, detail.soDon!),
                        ],
                        if (detail.soDangKy != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoSection(l10n.registrationNumber, detail.soDangKy!),
                        ],
                        const SizedBox(height: 16),
                        _buildInfoSection(l10n.registrationDate, _formatDate(detail.ngayDangKy)),
                        const SizedBox(height: 16),
                        _buildInfoSection(l10n.managementUnit, detail.donViQuanLy),
                        if (detail.donViUyQuyen != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoSection(l10n.authorizedUnit, detail.donViUyQuyen!),
                        ],
                        if (detail.quyetDinhBaoHo != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoSection(l10n.protectionDecision, detail.quyetDinhBaoHo!),
                        ],
                        const SizedBox(height: 16),
                        _buildInfoSection(l10n.decisionDate, _formatDate(detail.ngayQuyetDinh)),
                        const SizedBox(height: 16),
                        _buildInfoSection(l10n.protectedCommunes, detail.cacXaDuocBaoHo),
                        if (detail.updatedAt != null) ...[
                          const SizedBox(height: 16),
                          _buildInfoSection(l10n.updatedAt, _formatDateTime(detail.updatedAt)),
                        ],
                      ],
                    ),
                  ),
                ),
                if (detail.moTa != null && detail.moTa!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mô tả:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Html(
                            data: _formatHtmlContent(detail.moTa),
                            style: {
                              "body": Style(
                                fontSize: FontSize(14),
                                lineHeight: LineHeight(1.5),
                                color: const Color(0xFF455A64),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (detail.noiDung.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.message,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Html(
                            data: _formatHtmlContent(detail.noiDung),
                            style: {
                              "body": Style(
                                fontSize: FontSize(14),
                                lineHeight: LineHeight(1.5),
                                color: const Color(0xFF455A64),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1E88E5),
            fontSize: 14,
            fontWeight: FontWeight.bold,
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
    );
  }
}