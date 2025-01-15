import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shtt_bentre/src/mainData/database/home/patents.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatentDetailPage extends StatefulWidget {
 final String id;

 const PatentDetailPage({
   super.key,
   required this.id,
 });

 @override
 State<PatentDetailPage> createState() => _PatentDetailPageState();
}

class _PatentDetailPageState extends State<PatentDetailPage> {
 final PatentsDatabase _database = PatentsDatabase();
 late Future<Map<String, dynamic>> _patentFuture;

 @override
 void initState() {
   super.initState();
   _patentFuture = _database.fetchPatentDetail(widget.id);
 }

 String _formatContent(String? content) {
   if (content == null) return '';
   
   return content
       .replaceAll('&aacute;', 'á')
       .replaceAll('&agrave;', 'à')
       .replaceAll('&atilde;', 'ã')
       .replaceAll('&eacute;', 'é')
       .replaceAll('&egrave;', 'è')
       .replaceAll('&etilde;', 'ẽ')
       .replaceAll('&iacute;', 'í')
       .replaceAll('&igrave;', 'ì')
       .replaceAll('&itilde;', 'ĩ')
       .replaceAll('&oacute;', 'ó')
       .replaceAll('&ograve;', 'ò')
       .replaceAll('&otilde;', 'õ')
       .replaceAll('&uacute;', 'ú')
       .replaceAll('&ugrave;', 'ù')
       .replaceAll('&utilde;', 'ũ')
       .replaceAll('&yacute;', 'ý')
       .replaceAll('&ygrave;', 'ỳ')
       .replaceAll('\\u0026', '&')
       .replaceAll('\\u003E', '>')
       .replaceAll('\\u003C', '<');
 }

 String _getStatusText(String status) {
   final l10n = AppLocalizations.of(context)!;
   switch (status.toLowerCase()) {
     case 'đã cấp bằng':
       return l10n.patentStatusGranted;
     case 'hết hiệu lực':
       return l10n.patentStatusExpired;  
     case 'chờ xử lý':
       return l10n.patentStatusPending;
     default:
       return status;
   }
 }

 Color _getStatusColor(String status) {
   switch (status.toLowerCase()) {
     case 'đã cấp bằng':
       return const Color(0xFF4CAF50);
     case 'hết hiệu lực':
       return const Color(0xFFF44336);
     case 'chờ xử lý':
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
         l10n.patentDetailTitle,
         style: const TextStyle(
           color: Color(0xFF1E88E5),
           fontWeight: FontWeight.bold,
           fontSize: 20,
         ),
       ),
       centerTitle: true,
       iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
     ),
     body: FutureBuilder<Map<String, dynamic>>(
       future: _patentFuture,
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
                       _patentFuture = _database.fetchPatentDetail(widget.id);
                     });
                   },
                   child: Text(l10n.tryAgain),
                 ),
               ],
             ),
           );
         }

         final patent = snapshot.data!;
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
                       Row(
                         children: [
                           Container(
                             padding: const EdgeInsets.symmetric(
                               horizontal: 12,
                               vertical: 6,
                             ),
                             decoration: BoxDecoration(
                               color: const Color(0xFF1E88E5).withOpacity(0.1),
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(
                                 color: const Color(0xFF1E88E5).withOpacity(0.2),
                                 width: 1,
                               ),
                             ),
                             child: Text(
                               patent['type'] ?? '',
                               style: const TextStyle(
                                 color: Color(0xFF1565C0),
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
                               color: _getStatusColor(patent['status']).withOpacity(0.1),
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(
                                 color: _getStatusColor(patent['status']).withOpacity(0.2),
                               ),
                             ),
                             child: Text(
                               _getStatusText(patent['status']),
                               style: TextStyle(
                                 color: _getStatusColor(patent['status']),
                                 fontSize: 12,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 20),
                       Text(
                         patent['title'] ?? '',
                         style: const TextStyle(
                           fontSize: 24,
                           fontWeight: FontWeight.bold,
                           color: Color(0xFF263238),
                           height: 1.3,
                         ),
                       ),
                       const SizedBox(height: 24),
                       _buildInfoSection(
                         l10n.patentRegistrationInfo,
                         Icons.description_outlined,
                         [
                           _buildInfoRow(Icons.numbers, l10n.filingNumber, patent['filing_number'] ?? ''),
                           _buildInfoRow(Icons.category, l10n.applicationType, patent['application_type'] ?? ''),
                           _buildInfoRow(Icons.calendar_today, l10n.filingDate, patent['filing_date'] ?? ''),
                           _buildInfoRow(Icons.public, l10n.publicationNumber, patent['publication_number'] ?? ''),
                           _buildInfoRow(Icons.event, l10n.publicationDate, patent['publication_date'] ?? ''),
                           _buildInfoRow(Icons.class_, l10n.ipcClasses, patent['ipc_classes'] ?? ''),
                         ],
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
                       _buildInfoSection(
                         l10n.patentOwnerInfo,
                         Icons.people_outline,
                         [
                           _buildInfoRow(Icons.person, l10n.applicant, patent['applicant'] ?? ''),
                           _buildInfoRow(Icons.location_on, l10n.applicantAddress, patent['applicant_address'] ?? ''),
                           _buildInfoRow(Icons.engineering, l10n.inventor, patent['inventor'] ?? ''),
                           _buildInfoRow(Icons.home_work, l10n.inventorAddress, patent['inventor_address'] ?? ''),
                           if (patent['other_inventor'] != null && patent['other_inventor'].toString().isNotEmpty)
                             _buildInfoRow(Icons.group, l10n.coInventor, patent['other_inventor']),
                         ],
                       ),
                     ],
                   ),
                 ),
               ),

               if (patent['abstract'] != null && patent['abstract'].toString().isNotEmpty) ...[
                 const SizedBox(height: 16),
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
                               Icons.description_outlined,
                               color: Color(0xFF1E88E5),
                             ),
                             const SizedBox(width: 8),
                             Text(
                               l10n.abstract,
                               style: const TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                                 color: Color(0xFF1E88E5),
                               ),
                             ),
                           ],
                         ),
                         const SizedBox(height: 16),
                         Html(
                           data: _formatContent(patent['abstract']),
                           style: {
                             "body": Style(
                               fontSize: FontSize(15),
                               lineHeight: const LineHeight(1.6),
                               color: const Color(0xFF455A64),
                               margin: Margins.zero,
                               padding: HtmlPaddings.zero,
                               textAlign: TextAlign.justify,
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
                 ),
               ],

               if (patent['images'] != null && (patent['images'] as List).isNotEmpty) ...[
                 const SizedBox(height: 16),
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
                               l10n.images,
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
                             itemCount: (patent['images'] as List).length,
                             itemBuilder: (context, index) {
                               final image = patent['images'][index];
                               return Padding(
                                 padding: const EdgeInsets.only(right: 12),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(12),
                                   child: Image.network(
                                     image['file_url'],
                                     width: 200,
                                     height: 200,
                                     fit: BoxFit.cover,
                                     errorBuilder: (context, error, stackTrace) {
                                       return Container(
                                         width: 200,
                                         height: 200,
                                         color: Colors.grey[200],
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             const Icon(
                                               Icons.broken_image,
                                               size: 48,
                                               color: Colors.grey,
                                             ),
                                             const SizedBox(height: 8),
                                             Text(
                                               l10n.noImageAvailable,
                                               style: const TextStyle(
                                                 color: Colors.grey,
                                                 fontSize: 12,
                                               ),
                                             ),
                                           ],
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
       const SizedBox(height: 20),
       ...children,
     ],
   );
 }

 Widget _buildInfoRow(IconData icon, String label, String value) {
   return Padding(
     padding: const EdgeInsets.only(bottom: 16),
     child: Row(
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
     ),
   );
 }
}