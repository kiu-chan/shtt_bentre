import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_detail.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_card.dart';
import 'package:shtt_bentre/src/pages/home/category/trademark/trademark_filter_menu.dart';

class TrademarkListPage extends StatefulWidget {
 const TrademarkListPage({super.key});

 @override
 State<TrademarkListPage> createState() => _TrademarkListPageState();
}

class _TrademarkListPageState extends State<TrademarkListPage> {
 final Database _service = Database();
 final List<TrademarkModel> _trademarks = [];
 final ScrollController _scrollController = ScrollController();
 final TextEditingController _searchController = TextEditingController();
 Timer? _searchDebounce;

 bool _showBackToTopButton = false;
 bool _isLoading = false;
 bool _hasError = false;
 String? _errorMessage;
 int _currentPage = 1;
 bool _hasMoreData = true;

 String? _selectedType;
 String? _selectedYear;
 String? _selectedDistrict;
 List<Map<String, dynamic>> _availableTypes = [];
 List<String> _availableYears = [];
 List<Map<String, dynamic>> _availableDistricts = [];
 bool _isFiltered = false;

 @override
 void initState() {
   super.initState();
   _scrollController.addListener(_scrollListener);
   _searchController.addListener(_onSearchChanged);
   _loadFilterData();
   _loadInitialData();
 }

 Future<void> _loadFilterData() async {
   try {
     final types = await _service.trademark.fetchTrademarkTypes();
     final years = await _service.trademark.fetchTrademarkYears();
     final districts = await _service.trademark.fetchTrademarkDistricts();

     if (mounted) {
       setState(() {
         _availableTypes = types;
         _availableYears = years;
         _availableDistricts = districts;
       });
     }
   } catch (e) {
     print('Error loading filter data: $e');
   }
 }

 @override
 void dispose() {
   _scrollController.dispose();
   _searchController.dispose();
   _searchDebounce?.cancel();
   super.dispose();
 }

 void _onSearchChanged() {
   if (_searchDebounce?.isActive ?? false) {
     _searchDebounce!.cancel();
   }
   _searchDebounce = Timer(const Duration(milliseconds: 500), () {
     _refreshData();
   });
 }

 Future<void> _loadInitialData() async {
   if (!mounted) return;
   setState(() {
     _isLoading = true;
     _hasError = false;
     _errorMessage = null;
   });

   try {
     final trademarks = await _service.trademark.fetchTrademarks(
       search: _searchController.text,
       type: _selectedType,
       year: _selectedYear,
       district: _selectedDistrict,
     );
     
     if (!mounted) return;
     
     setState(() {
       _trademarks.clear();
       _trademarks.addAll(trademarks);
       _isLoading = false;
       _currentPage = 1;
       _hasMoreData = trademarks.isNotEmpty;
     });
   } catch (e) {
     if (!mounted) return;
     setState(() {
       _isLoading = false;
       _hasError = true;
       _errorMessage = e.toString();
     });
   }
 }

 Future<void> _loadMoreData() async {
   if (_isLoading || !_hasMoreData) return;

   setState(() {
     _isLoading = true;
   });

   try {
     final nextPage = _currentPage + 1;
     final moreTrademarks = await _service.trademark.fetchTrademarks(
       page: nextPage,
       search: _searchController.text,
       type: _selectedType,
       year: _selectedYear,
       district: _selectedDistrict,
     );
     
     if (!mounted) return;

     setState(() {
       if (moreTrademarks.isEmpty) {
         _hasMoreData = false;
       } else {
         _trademarks.addAll(moreTrademarks);
         _currentPage = nextPage;
       }
       _isLoading = false;
     });
   } catch (e) {
     if (!mounted) return;
     setState(() {
       _isLoading = false;
       final l10n = AppLocalizations.of(context)!;
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('${l10n.loadMoreError} ${e.toString()}'),
           action: SnackBarAction(
             label: l10n.retry,
             onPressed: _loadMoreData,
           ),
         ),
       );
     });
   }
 }

 void _scrollListener() {
   setState(() {
     _showBackToTopButton = _scrollController.offset >= 400;
   });

   if (_scrollController.position.pixels >=
       _scrollController.position.maxScrollExtent - 200) {
     _loadMoreData();
   }
 }

 void _scrollToTop() {
   _scrollController.animateTo(
     0,
     duration: const Duration(milliseconds: 500),
     curve: Curves.easeInOut,
   );
 }

 Future<void> _refreshData() async {
   setState(() {
     _currentPage = 1;
     _hasMoreData = true;
     _loadInitialData();
   });
 }

 void _showFilterDialog() {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return StatefulBuilder(
         builder: (context, setState) {
           return TrademarkFilterMenu(
             selectedType: _selectedType,
             selectedYear: _selectedYear,
             selectedDistrict: _selectedDistrict,
             availableTypes: _availableTypes,
             availableYears: _availableYears,
             availableDistricts: _availableDistricts,
             onTypeChanged: (value) => setState(() => _selectedType = value),
             onYearChanged: (value) => setState(() => _selectedYear = value),
             onDistrictChanged: (value) => setState(() => _selectedDistrict = value),
             onApply: () {
               Navigator.pop(context);
               _applyFilters();
             },
             onCancel: () => Navigator.pop(context),
           );
         },
       );
     },
   );
 }

 void _applyFilters() {
   setState(() {
     _isFiltered = _selectedType != null || 
                   _selectedYear != null || 
                   _selectedDistrict != null;
     _refreshData();
   });
 }

 void _resetFilters() {
   setState(() {
     _selectedType = null;
     _selectedYear = null;
     _selectedDistrict = null;
     _isFiltered = false;
     _refreshData();
   });
 }

 void _onTrademarkTap(TrademarkModel trademark) {
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => TrademarkDetailPage(id: trademark.id),
     ),
   );
 }

 Widget _buildSearchBar() {
   final l10n = AppLocalizations.of(context)!;
   return Container(
     padding: const EdgeInsets.all(16),
     color: Colors.white,
     child: TextField(
       controller: _searchController,
       decoration: InputDecoration(
         hintText: l10n.trademarkSearchHint,
         prefixIcon: const Icon(Icons.search, color: Color(0xFF1E88E5)),
         suffixIcon: _searchController.text.isNotEmpty
             ? IconButton(
                 icon: const Icon(Icons.clear),
                 onPressed: () {
                   _searchController.clear();
                   FocusScope.of(context).unfocus();
                 },
               )
             : null,
         filled: true,
         fillColor: const Color(0xFFF5F7FA),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: BorderSide.none,
         ),
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: BorderSide.none,
         ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 1),
         ),
       ),
     ),
   );
 }

 Widget _buildActiveFilters() {
   if (!_isFiltered) return const SizedBox.shrink();

   final l10n = AppLocalizations.of(context)!;
   return Container(
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
     child: Row(
       children: [
         Text(
           l10n.filtering,
           style: const TextStyle(
             fontWeight: FontWeight.bold,
             color: Color(0xFF1E88E5),
           ),
         ),
         const SizedBox(width: 8),
         Expanded(
           child: Wrap(
             spacing: 8,
             children: [
               if (_selectedType != null)
                 Chip(
                   label: Text(_selectedType!),
                   onDeleted: () {
                     setState(() {
                       _selectedType = null;
                       _applyFilters();
                     });
                   },
                 ),
               if (_selectedYear != null)
                 Chip(
                   label: Text('${l10n.year} $_selectedYear'),
                   onDeleted: () {
                     setState(() {
                       _selectedYear = null;
                       _applyFilters();
                     });
                   },
                 ),
               if (_selectedDistrict != null)
                 Chip(
                   label: Text(_selectedDistrict!),
                   onDeleted: () {
                     setState(() {
                       _selectedDistrict = null;
                       _applyFilters();
                     });
                   },
                 ),
             ],
           ),
         ),
         TextButton(
           onPressed: _resetFilters,
           child: Text(l10n.clearFilter),
         ),
       ],
     ),
   );
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
         l10n.trademark,
         style: const TextStyle(
           color: Color(0xFF1E88E5),
           fontWeight: FontWeight.bold,
           fontSize: 20,
         ),
       ),
       centerTitle: true,
       iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
       actions: [
         Stack(
           children: [
             IconButton(
               icon: const Icon(Icons.filter_list),
               onPressed: _showFilterDialog,
             ),
             if (_isFiltered)
               Positioned(
                 right: 8,
                 top: 8,
                 child: Container(
                   padding: const EdgeInsets.all(4),
                   decoration: const BoxDecoration(
                     color: Colors.red,
                     shape: BoxShape.circle,
                   ),
                   constraints: const BoxConstraints(
                     minWidth: 8,
                     minHeight: 8,
                   ),
                 ),
               ),
           ],
         ),
       ],
     ),
     body: Column(
       children: [
         _buildSearchBar(),
         _buildActiveFilters(),
         Expanded(
           child: RefreshIndicator(
             onRefresh: _refreshData,
             child: _isLoading && _trademarks.isEmpty
                 ? const Center(child: CircularProgressIndicator())
                 : _hasError
                     ? Center(
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
                               '${l10n.errorOccurred} ${_errorMessage ?? l10n.unknownError}',
                               style: const TextStyle(color: Colors.red),
                               textAlign: TextAlign.center,
                             ),
                             const SizedBox(height: 16),
                             ElevatedButton(
                               onPressed: _refreshData,
                               child: Text(l10n.tryAgain),
                             ),
                           ],
                         ),
                       )
                     : _trademarks.isEmpty
                         ? Center(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(
                                   Icons.search_off,
                                   size: 64,
                                   color: Colors.grey[400],
                                 ),
                                 const SizedBox(height: 16),
                                 Text(
                                   _searchController.text.isNotEmpty || _isFiltered
                                       ? l10n.noMatchingResults
                                       : l10n.noTrademarkData,
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.grey[600],
                                   ),
                                   textAlign: TextAlign.center,
                                 ),
                               ],
                             ),
                           )
                         : ListView.builder(
                             controller: _scrollController,
                             padding: const EdgeInsets.all(16),
                             itemCount: _trademarks.length + (_hasMoreData ? 1 : 0),
                             itemBuilder: (context, index) {
                               if (index == _trademarks.length) {
                                 return _isLoading
                                     ? const Center(child: CircularProgressIndicator())
                                     : const SizedBox();
                               }
                               return GestureDetector(
                                 onTap: () => _onTrademarkTap(_trademarks[index]),
                                 child: TrademarkCard(trademark: _trademarks[index]),
                               );
                             },
                           ),
           ),
         ),
       ],
     ),
     floatingActionButton: _showBackToTopButton
         ? FloatingActionButton(
             onPressed: _scrollToTop,
             backgroundColor: const Color(0xFF1E88E5),
             child: const Icon(Icons.arrow_upward),
           )
         : null,
   );
 }
}