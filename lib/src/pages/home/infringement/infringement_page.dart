// lib/src/pages/infringement/infringement_page.dart

import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/data/home/infringement.dart';
import 'dart:async';
import 'package:shtt_bentre/src/mainData/database/home/infringement.dart';
import 'package:shtt_bentre/src/pages/home/infringement/infringement_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfringementPage extends StatefulWidget {
  const InfringementPage({super.key});

  @override
  State<InfringementPage> createState() => _InfringementPageState();
}

class _InfringementPageState extends State<InfringementPage> {
  final TextEditingController _searchController = TextEditingController();
  final InfringementService _service = InfringementService();
  late Future<List<InfringementModel>> _infringementsFuture;
  Timer? _debounce;
  String? _selectedStatus;
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _loadInfringements();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadInfringements();
    });
  }

  void _loadInfringements() {
    setState(() {
      _infringementsFuture = _service.fetchInfringements(
        search: _searchController.text,
        status: _selectedStatus,
      );
    });
  }

  void _showFilterDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.filter),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.status),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedStatus,
                    hint: Text(l10n.selectStatus),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(l10n.all),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Đang điều tra',
                        child: Text(l10n.investigatingStatus),
                      ),
                    ],
                    onChanged: (value) => setState(() => _selectedStatus = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    this.setState(() {
                      _isFiltered = _selectedStatus != null;
                      _loadInfringements();
                    });
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

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _searchController.clear();
      _isFiltered = false;
      _loadInfringements();
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
          hintText: l10n.searchInfringement,
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
                if (_selectedStatus != null)
                  Chip(
                    label: Text(_selectedStatus!),
                    onDeleted: () {
                      setState(() {
                        _selectedStatus = null;
                        _isFiltered = false;
                        _loadInfringements();
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

  Future<void> _refreshInfringements() async {
    _loadInfringements();
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
          l10n.violation,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
              onRefresh: _refreshInfringements,
              child: FutureBuilder<List<InfringementModel>>(
                future: _infringementsFuture,
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
                            onPressed: _refreshInfringements,
                            child: Text(l10n.tryAgain),
                          ),
                        ],
                      ),
                    );
                  }

                  final infringements = snapshot.data ?? [];

                  if (infringements.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchController.text.isNotEmpty || _isFiltered
                                ? Icons.search_off
                                : Icons.gavel,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty || _isFiltered
                                ? l10n.noMatchingViolations
                                : l10n.noViolationsYet,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: infringements.length,
                    itemBuilder: (context, index) {
                      return InfringementCard(
                        infringement: infringements[index],
                      );
                    },
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