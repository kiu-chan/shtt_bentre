// lib/src/pages/map/search/map_search.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shtt_bentre/src/mainData/config/url.dart';

class MapSearchBar extends StatefulWidget {
  final Function(double latitude, double longitude, String name) onLocationSelected;
  final bool isRightMenuOpen;
  final VoidCallback onToggleLegend;
  final VoidCallback onToggleRightMenu;
  final bool isLegendVisible;

  const MapSearchBar({
    super.key,
    required this.onLocationSelected,
    required this.isRightMenuOpen,
    required this.onToggleLegend,
    required this.onToggleRightMenu,
    required this.isLegendVisible,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Đóng danh sách kết quả khi mất focus
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _searchResults = []);
        }
      });
    }
  }

  // API Calls
  Future<List<dynamic>> _searchIndustrialDesigns(String query) async {
    try {
      final url = '${MainUrl.apiUrl}/industrial-design-locations-with-name?name=$query';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ? data['data'] : [];
      }
    } catch (e) {
      print('Error searching industrial designs: $e');
    }
    return [];
  }

  Future<List<dynamic>> _searchTrademarks(String query) async {
    try {
      final url = '${MainUrl.apiUrl}/trademark-locations-with-name?name=$query';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ? data['data'] : [];
      }
    } catch (e) {
      print('Error searching trademarks: $e');
    }
    return [];
  }

  Future<List<dynamic>> _searchPatents(String query) async {
    try {
      final url = '${MainUrl.apiUrl}/patent-locations-with-name?name=$query';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ? data['data'] : [];
      }
    } catch (e) {
      print('Error searching patents: $e');
    }
    return [];
  }

  // Search Handling
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _searchIndustrialDesigns(query),
        _searchTrademarks(query),
        _searchPatents(query),
      ]);

      if (mounted) {
        setState(() {
          _searchResults = [
            ...results[0].map((item) => {...item, 'type': 'industrial_design'}),
            ...results[1].map((item) => {...item, 'type': 'trademark'}),
            ...results[2].map((item) => {...item, 'type': 'patent'}),
          ];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Search error: $e');
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchResults = []);
    _focusNode.unfocus();
  }

  void _handleResultTap(Map<String, dynamic> result) {
    final coordinates = result['coordinates'];
    if (coordinates != null) {
      widget.onLocationSelected(
        double.parse(coordinates['latitude'].toString()),
        double.parse(coordinates['longitude'].toString()),
        result['name'] ?? '',
      );
      _clearSearch();
    }
  }

  // UI Components
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm địa điểm...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: _clearSearch,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              widget.isLegendVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.purple,
            ),
            onPressed: widget.onToggleLegend,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              widget.isRightMenuOpen ? Icons.menu_open : Icons.menu,
              color: Colors.blue,
            ),
            onPressed: widget.onToggleRightMenu,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

Widget _buildSearchResults() {
    if (!_isLoading && _searchResults.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: _searchResults.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final Map<String, dynamic> result = Map<String, dynamic>.from(_searchResults[index] as Map);
                  final String type = result['type'] as String;
                  final String name = result['name'] as String? ?? '';
                  
                  return ListTile(
                    onTap: () => _handleResultTap(result),
                    title: Text(
                      name,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      type == 'industrial_design'
                          ? 'Kiểu dáng công nghiệp'
                          : type == 'trademark'
                              ? 'Nhãn hiệu'
                              : 'Bằng sáng chế',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    leading: Icon(
                      type == 'industrial_design'
                          ? Icons.design_services
                          : type == 'trademark'
                              ? Icons.bookmark
                              : Icons.lightbulb,
                      color: type == 'industrial_design'
                          ? Colors.purple
                          : type == 'trademark'
                              ? Colors.blue
                              : Colors.green,
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: widget.isRightMenuOpen ? 316 : 16,
            bottom: 8,
          ),
          child: Row(
            children: [
              Expanded(child: _buildSearchBar()),
              const SizedBox(width: 8),
              _buildActionButtons(),
            ],
          ),
        ),
        if (_isLoading || _searchResults.isNotEmpty)
          Container(
            margin: EdgeInsets.only(
              right: widget.isRightMenuOpen ? 316 : 0,
            ),
            child: _buildSearchResults(),
          ),
      ],
    );
  }
}