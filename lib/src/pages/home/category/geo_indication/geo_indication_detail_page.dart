import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:shtt_bentre/src/mainData/config/format.dart';
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
    return DateFormat(Format.dateFormat).format(date);
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat(Format.dateTimeFormat).format(date);
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
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF4CAF50).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            l10n.geoIndications,
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          detail.tenSanPham,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildBasicInfo(detail, l10n),
                      ],
                    ),
                  ),
                ),
                if (detail.moTa != null && detail.moTa!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDescriptionSection(detail.moTa!, l10n),
                ],
                if (detail.noiDung.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildContentSection(detail.noiDung, l10n),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfo(GeoIndicationDetailModel detail, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          Icons.numbers,
          l10n.applicationNumber,
          detail.soDon ?? '',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.verified,
          l10n.registrationNumber,
          detail.soDangKy ?? '',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.calendar_today,
          l10n.registrationDate,
          _formatDate(detail.ngayDangKy),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.business,
          l10n.managementUnit,
          detail.donViQuanLy,
        ),
        if (detail.donViUyQuyen != null) ...[
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.assignment_ind,
            l10n.authorizedUnit,
            detail.donViUyQuyen!,
          ),
        ],
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.gavel,
          l10n.protectionDecision,
          detail.quyetDinhBaoHo ?? '',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.event,
          l10n.decisionDate,
          _formatDate(detail.ngayQuyetDinh),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          Icons.location_on,
          l10n.protectedCommunes,
          detail.cacXaDuocBaoHo,
        ),
        if (detail.updatedAt != null) ...[
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.update,
            l10n.updatedAt,
            _formatDateTime(detail.updatedAt),
          ),
        ],
      ],
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

  Widget _buildDescriptionSection(String description, AppLocalizations l10n) {
    return Card(
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
                  Icons.description,
                  color: Color(0xFF1E88E5),
                ),
                const SizedBox(width: 8),
                Text(
                  'Mô tả',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Html(
              data: _formatHtmlContent(description),
              style: {
                "body": Style(
                  fontSize: FontSize(15),
                  lineHeight: const LineHeight(1.6),
                  color: const Color(0xFF455A64),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.justify,
                ),
                "figure": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "img": Style(
                  width: Width.auto(),
                  height: Height.auto(),
                  margin: Margins.only(top: 12, bottom: 12),
                  alignment: Alignment.center,
                  display: Display.block,
                ),
                "p": Style(
                  margin: Margins.only(bottom: 16),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(String content, AppLocalizations l10n) {
    return Card(
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
                  Icons.article,
                  color: Color(0xFF1E88E5),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Html(
              data: _formatHtmlContent(content),
              style: {
                "body": Style(
                  fontSize: FontSize(15),
                  lineHeight: const LineHeight(1.6),
                  color: const Color(0xFF455A64),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}