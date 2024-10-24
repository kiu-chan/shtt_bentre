import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shtt_bentre/src/mainData/data/district.dart';
import 'package:shtt_bentre/src/mainData/data/commune.dart';
import 'package:shtt_bentre/src/mainData/data/border.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'map_page_view.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final Database _database = Database();
  final LatLng _center = LatLng(10.2433, 106.3752);
  
  double _currentZoom = 10.0;
  List<District> _districts = [];
  List<Commune> _communes = [];
  List<MapBorder> _borders = [];
  bool _isLoading = true;
  bool _isBorderLoading = false;
  bool _isCommuneLoading = false;
  bool _isBorderEnabled = false;
  bool _isCommuneEnabled = false;
  String? _selectedDistrictName;
  String? _selectedCommuneName;
  bool _isLegendVisible = true;
  bool _isRightMenuOpen = false;
  
  late AnimationController _legendAnimationController;
  late Animation<Offset> _legendSlideAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupAnimations();
  }

  void _setupAnimations() {
    _legendAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _legendSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _legendAnimationController,
      curve: Curves.easeInOut,
    ));

    _legendAnimationController.forward();
  }

  Future<void> _loadData() async {
    try {
      final districts = await _database.loadDistrictData();
      setState(() {
        _districts = districts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading districts: $e');
      setState(() => _isLoading = false);
      _showError('Không thể tải dữ liệu huyện');
    }
  }

  Future<void> _loadCommuneData() async {
    if (_communes.isEmpty && !_isCommuneLoading) {
      setState(() => _isCommuneLoading = true);
      try {
        final communes = await _database.loadCommuneData();
        setState(() {
          _communes = communes;
          _isCommuneLoading = false;
          _isCommuneEnabled = true;
        });
      } catch (e) {
        print('Error loading communes: $e');
        setState(() => _isCommuneLoading = false);
        _showError('Không thể tải dữ liệu xã');
      }
    } else {
      setState(() => _isCommuneEnabled = !_isCommuneEnabled);
    }
  }

  Future<void> _loadBorderData() async {
    if (_borders.isEmpty && !_isBorderLoading) {
      setState(() => _isBorderLoading = true);
      try {
        final borders = await _database.loadBorderData();
        setState(() {
          _borders = borders;
          _isBorderLoading = false;
          _isBorderEnabled = true;
        });
      } catch (e) {
        print('Error loading borders: $e');
        setState(() => _isBorderLoading = false);
        _showError('Không thể tải dữ liệu viền bản đồ');
      }
    } else {
      setState(() => _isBorderEnabled = !_isBorderEnabled);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  List<Polygon> _buildPolygons() {
    List<Polygon> polygons = [];
    
    // Add district polygons
    for (var district in _districts) {
      if (!district.isVisible) continue;
      
      for (var points in district.polygons) {
        polygons.add(Polygon(
          points: points,
          color: _selectedDistrictName == district.name
              ? district.color.withOpacity(0.6)
              : district.color,
          borderStrokeWidth: 2.0,
          borderColor: district.color.withOpacity(1),
          isFilled: true,
        ));
      }
    }

    // Add commune polygons if enabled
    if (_isCommuneEnabled) {
      for (var commune in _communes) {
        for (var points in commune.polygons) {
          polygons.add(Polygon(
            points: points,
            color: _selectedCommuneName == commune.name
                ? commune.color.withOpacity(0.6)
                : commune.color,
            borderStrokeWidth: 1.5,
            borderColor: commune.color.withOpacity(1),
            isFilled: true,
          ));
        }
      }
    }

    return polygons;
  }

  List<Polyline> _buildBorderLines() {
    if (!_isBorderEnabled || _borders.isEmpty) return [];

    return _borders.where((border) => border.points.isNotEmpty).map((border) {
      return Polyline(
        points: border.points,
        strokeWidth: 2.0,
        color: Colors.black,
      );
    }).toList();
  }

  void _toggleLegend() {
    setState(() {
      _isLegendVisible = !_isLegendVisible;
      if (_isLegendVisible) {
        _legendAnimationController.forward();
      } else {
        _legendAnimationController.reverse();
      }
    });
  }

  void _toggleRightMenu() {
    setState(() {
      _isRightMenuOpen = !_isRightMenuOpen;
    });
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 0.5).clamp(1.0, 18.0);
      _mapController.move(_center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 0.5).clamp(1.0, 18.0);
      _mapController.move(_center, _currentZoom);
    });
  }

  void _showDistrictInfo(String name) {
    _districts.firstWhere(
      (d) => d.name == name,
      orElse: () => _districts.first,
    );
    
    setState(() {
      _selectedDistrictName = name;
      _selectedCommuneName = null;
    });
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Huyện: $name'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCommuneInfo(Commune commune) {
    setState(() {
      _selectedCommuneName = commune.name;
    });
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Xã: ${commune.name}\n'
          'Diện tích: ${commune.area.toStringAsFixed(2)} km²\n'
          'Dân số: ${commune.population}\n'
          'Cập nhật: ${commune.updatedYear}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onMapTap(_, __) {
    setState(() {
      _selectedDistrictName = null;
      _selectedCommuneName = null;
    });
  }

  @override
  void dispose() {
    _legendAnimationController.dispose();
    _database.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapPageView(
      mapController: _mapController,
      currentZoom: _currentZoom,
      center: _center,
      districts: _districts,
      communes: _communes,
      isLoading: _isLoading,
      isLegendVisible: _isLegendVisible,
      isRightMenuOpen: _isRightMenuOpen,
      isBorderEnabled: _isBorderEnabled,
      isCommuneEnabled: _isCommuneEnabled,
      isBorderLoading: _isBorderLoading,
      isCommuneLoading: _isCommuneLoading,
      selectedDistrictName: _selectedDistrictName,
      selectedCommuneName: _selectedCommuneName,
      legendSlideAnimation: _legendSlideAnimation,
      onToggleLegend: _toggleLegend,
      onToggleRightMenu: _toggleRightMenu,
      onToggleBorder: _loadBorderData,
      onToggleCommune: _loadCommuneData,
      onZoomIn: _zoomIn,
      onZoomOut: _zoomOut,
      onShowDistrictInfo: _showDistrictInfo,
      onShowCommuneInfo: _showCommuneInfo,
      onMapTap: _onMapTap,
      polygons: _buildPolygons(),
      borderLines: _buildBorderLines(),
    );
  }
}