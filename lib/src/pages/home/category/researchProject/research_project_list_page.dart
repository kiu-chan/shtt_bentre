import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/researchProject/research_project.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'package:shtt_bentre/src/pages/home/category/researchProject/research_project_card.dart';
import 'package:shtt_bentre/src/pages/home/category/researchProject/research_project_detail_page.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResearchProjectListPage extends StatefulWidget {
  const ResearchProjectListPage({super.key});

  @override
  State<ResearchProjectListPage> createState() => _ResearchProjectListPageState();
}

class _ResearchProjectListPageState extends State<ResearchProjectListPage> {
  final Database _service = Database();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Pagination state
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<ResearchProjectModel> _projects = [];
  
  // Filter state
  Timer? _debounce;
  String? _selectedType;
  String? _selectedYear;
  List<String> _availableTypes = [];
  List<String> _availableYears = [];
  bool _isFiltered = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadFilterData();
    _loadInitialData();
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

  Future<void> _loadFilterData() async {
    try {
      final types = await _service.rp.fetchAvailableFields();
      final years = await _service.rp.fetchAvailableYears();
      setState(() {
        _availableTypes = types;
        _availableYears = years;
      });
    } catch (e) {
      print('Error loading filter data: $e');
    }
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
      _projects = [];
    });

    try {
      final projects = await _service.rp.fetchResearchProjects(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        type: _selectedType,
        year: _selectedYear,
        page: _currentPage,
      );

      setState(() {
        _projects = projects;
        _hasMoreData = projects.isNotEmpty;
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
      final moreProjects = await _service.rp.fetchResearchProjects(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        type: _selectedType,
        year: _selectedYear,
        page: nextPage,
      );

      setState(() {
        if (moreProjects.isNotEmpty) {
          _projects.addAll(moreProjects);
          _currentPage = nextPage;
          _hasMoreData = moreProjects.length >= 10;
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
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.filter),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l10n.fieldLabel}:'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedType,
                      hint: Text(l10n.selectField),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ..._availableTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }),
                      ],
                      onChanged: (value) => setState(() => _selectedType = value),
                    ),
                    const SizedBox(height: 16),
                    Text('${l10n.year}:'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedYear,
                      hint: Text(l10n.selectYear),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ..._availableYears.map((year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text('Năm $year'),
                          );
                        }),
                      ],
                      onChanged: (value) => setState(() => _selectedYear = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: Text(l10n.apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      _isFiltered = _selectedType != null || _selectedYear != null;
      _loadInitialData();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedType = null;
      _selectedYear = null;
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
          hintText: l10n.searchProjectPlaceholder,
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
                    label: Text('Năm $_selectedYear'),
                    onDeleted: () {
                      setState(() {
                        _selectedYear = null;
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

  Future<void> _refreshProjects() async {
    _searchController.clear();
    _selectedType = null;
    _selectedYear = null;
    _isFiltered = false;
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
          l10n.scienceAndInnovation,
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
              onRefresh: _refreshProjects,
              child: _projects.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _projects.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _projects.length) {
                          return _buildLoadingIndicator();
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResearchProjectDetailPage(
                                  id: _projects[index].id,
                                ),
                              ),
                            );
                          },
                          child: ResearchProjectCard(project: _projects[index]),
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