import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/technicalCompetition/technical_competition.dart';
import 'package:shtt_bentre/src/mainData/database/home/technical_competition.dart';
import 'package:shtt_bentre/src/pages/home/category/technicalCompetition/technical_competition_card.dart';
import 'package:shtt_bentre/src/pages/home/category/technicalCompetition/technical_competition_filter_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TechnicalCompetitionListPage extends StatefulWidget {
  const TechnicalCompetitionListPage({super.key});

  @override
  State<TechnicalCompetitionListPage> createState() => _TechnicalCompetitionListPageState();
}

class _TechnicalCompetitionListPageState extends State<TechnicalCompetitionListPage> {
  final TechnicalCompetitionService _service = TechnicalCompetitionService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Pagination state
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<TechnicalCompetitionModel> _competitions = [];
  
  Timer? _debounce;
  List<Map<String, dynamic>> _availableYears = [];
  List<Map<String, dynamic>> _availableFields = [];
  List<Map<String, dynamic>> _availableRanks = [];
  
  String? _selectedYear;
  String? _selectedField;
  String? _selectedRank;
  bool _isFiltered = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadFilterData();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMoreData) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _competitions = [];
    });

    try {
      final competitions = await _service.fetchCompetitions(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        field: _selectedField,
        year: _selectedYear,
        rank: _selectedRank,
        page: _currentPage,
      );

      setState(() {
        _competitions = competitions;
        _hasMoreData = competitions.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMoreData = false;
      });
      print('Error loading initial data: $e');
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final moreCompetitions = await _service.fetchCompetitions(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        field: _selectedField,
        year: _selectedYear,
        rank: _selectedRank,
        page: nextPage,
      );

      setState(() {
        if (moreCompetitions.isNotEmpty) {
          _competitions.addAll(moreCompetitions);
          _currentPage = nextPage;
          _hasMoreData = moreCompetitions.length >= 10;
        } else {
          _hasMoreData = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMoreData = false;
      });
      print('Error loading more data: $e');
    }
  }

  Future<void> _loadFilterData() async {
    try {
      final years = await _service.fetchCompetitionsByYear();
      final fields = await _service.fetchCompetitionsByField();
      final ranks = await _service.fetchCompetitionsByRank();
      
      setState(() {
        _availableYears = years;
        _availableFields = fields;
        _availableRanks = ranks;
      });
    } catch (e) {
      print('Error loading filter data: $e');
    }
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadInitialData();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TechnicalCompetitionFilterMenu(
          selectedYear: _selectedYear,
          selectedField: _selectedField,
          selectedRank: _selectedRank,
          availableYears: _availableYears,
          availableFields: _availableFields,
          availableRanks: _availableRanks,
          onYearChanged: (value) => setState(() => _selectedYear = value),
          onFieldChanged: (value) => setState(() => _selectedField = value),
          onRankChanged: (value) => setState(() => _selectedRank = value),
          onApply: () {
            Navigator.pop(context);
            _applyFilters();
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      _isFiltered = _selectedYear != null || 
                   _selectedField != null || 
                   _selectedRank != null;
      _loadInitialData();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedYear = null;
      _selectedField = null;
      _selectedRank = null;
      _isFiltered = false;
      _searchController.clear();
      _loadInitialData();
    });
  }

  Widget _buildSearchBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.searchCompetitionPlaceholder,
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
            '${l10n.filtering}:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                if (_selectedYear != null)
                  Chip(
                    label: Text('Năm $_selectedYear'),
                    onDeleted: () {
                      setState(() {
                        _selectedYear = null;
                        _loadInitialData();
                      });
                    },
                  ),
                if (_selectedField != null)
                  Chip(
                    label: Text(_selectedField!),
                    onDeleted: () {
                      setState(() {
                        _selectedField = null;
                        _loadInitialData();
                      });
                    },
                  ),
                if (_selectedRank != null)
                  Chip(
                    label: Text(_selectedRank!),
                    onDeleted: () {
                      setState(() {
                        _selectedRank = null;
                        _loadInitialData();
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

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off : Icons.inbox,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(l10n.noMatchingResults,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    _searchController.clear();
    _selectedYear = null;
    _selectedField = null;
    _selectedRank = null;
    _isFiltered = false;
    _isSearching = false;
    await _loadFilterData();
    await _loadInitialData();
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
          l10n.technicalCompetitions,
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
              child: _competitions.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _competitions.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _competitions.length) {
                          return _buildLoadingIndicator();
                        }
                        return CompetitionCard(
                          competition: _competitions[index],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}