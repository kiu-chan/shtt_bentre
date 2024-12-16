import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shtt_bentre/src/mainData/data/map/border.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/mainData/database/databases.dart';
import 'map_page_view.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final Database _database = Database();
  final LatLng _center = LatLng(10.2433, 106.3752);
  
  // Các biến điều khiển map
  double _currentZoom = 10.0;
  List<District> _districts = [];
  List<Commune> _communes = [];
  List<MapBorder> _borders = [];
  List<Patent> _patents = [];
  
  // Các biến trạng thái loading
  bool _isLoading = true;
  bool _isBorderLoading = false;
  bool _isCommuneLoading = false;
  bool _isPatentLoading = false;
  bool _isDataLoading = false;
  
  // Các biến trạng thái hiển thị
  bool _isBorderEnabled = false;
  bool _isCommuneEnabled = false;
  bool _isDistrictEnabled = true;
  bool _isPatentEnabled = false;
  
  // Các biến lựa chọn
  String? _selectedDistrictName;
  String? _selectedCommuneName;
  Patent? _selectedPatent;
  
  // Các biến điều khiển UI
  bool _isLegendVisible = true;
  bool _isRightMenuOpen = false;
  bool _isLegendAnimating = false;
  
  // Các biến điều khiển animation
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
      if (!mounted) return;
      
      setState(() {
        _districts = districts;
        _isLoading = false;
      });
      
      // Tự động load dữ liệu bằng sáng chế sau khi load districts
      _loadPatentData();
    } catch (e) {
      print('Lỗi khi tải dữ liệu huyện: $e');
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      _showError(AppLocalizations.of(context)!.cannotLoadDistrictData);
    }
  }

  Future<void> _loadCommuneData() async {
    if (_isLegendAnimating || _isDataLoading) return;
    
    if (_communes.isEmpty && !_isCommuneLoading) {
      setState(() {
        _isDataLoading = true;
        _isCommuneLoading = true;
      });
      
      try {
        final communes = await _database.loadCommuneData();
        if (!mounted) return;
        
        setState(() {
          _communes = communes;
          _isCommuneLoading = false;
          _isCommuneEnabled = true;
          _isDataLoading = false;
        });
      } catch (e) {
        print('Lỗi khi tải dữ liệu xã: $e');
        if (!mounted) return;
        
        setState(() {
          _isCommuneLoading = false;
          _isDataLoading = false;
        });
        _showError(AppLocalizations.of(context)!.cannotLoadCommuneData);
      }
    } else {
      if (_isLegendAnimating) return;
      setState(() => _isCommuneEnabled = !_isCommuneEnabled);
    }
  }

  Future<void> _loadBorderData() async {
    if (_isLegendAnimating || _isDataLoading) return;
    
    if (_borders.isEmpty && !_isBorderLoading) {
      setState(() {
        _isDataLoading = true;
        _isBorderLoading = true;
      });
      
      try {
        final borders = await _database.loadBorderData();
        if (!mounted) return;
        
        setState(() {
          _borders = borders;
          _isBorderLoading = false;
          _isBorderEnabled = true;
          _isDataLoading = false;
        });
      } catch (e) {
        print('Lỗi khi tải dữ liệu đường biên: $e');
        if (!mounted) return;
        
        setState(() {
          _isBorderLoading = false;
          _isDataLoading = false;
        });
        _showError(AppLocalizations.of(context)!.cannotLoadBorderData);
      }
    } else {
      if (_isLegendAnimating) return;
      setState(() => _isBorderEnabled = !_isBorderEnabled);
    }
  }

  Future<void> _loadPatentData() async {
    if (_isLegendAnimating || _isDataLoading) return;
    
    if (_patents.isEmpty && !_isPatentLoading) {
      setState(() {
        _isDataLoading = true;
        _isPatentLoading = true;
      });
      
      try {
        final patents = await _database.loadPatentData();
        if (!mounted) return;
        
        setState(() {
          _patents = patents;
          _isPatentLoading = false;
          _isPatentEnabled = true;
          _isDataLoading = false;
        });
      } catch (e) {
        print('Lỗi khi tải dữ liệu bằng sáng chế: $e');
        if (!mounted) return;
        
        setState(() {
          _isPatentLoading = false;
          _isDataLoading = false;
        });
        _showError('Không thể tải dữ liệu bằng sáng chế');
      }
    } else {
      if (_isLegendAnimating) return;
      setState(() => _isPatentEnabled = !_isPatentEnabled);
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

  void _toggleLegend() {
    if (_isLegendAnimating || _isDataLoading) return;
    
    setState(() {
      _isLegendVisible = !_isLegendVisible;
      _isLegendAnimating = true;
      
      if (_isLegendVisible) {
        _legendAnimationController.forward().then((_) {
          if (mounted) {
            setState(() => _isLegendAnimating = false);
          }
        });
      } else {
        _legendAnimationController.reverse().then((_) {
          if (mounted) {
            setState(() => _isLegendAnimating = false);
          }
        });
      }
    });
  }

  void _toggleRightMenu() {
    if (_isLegendAnimating) return;
    setState(() => _isRightMenuOpen = !_isRightMenuOpen);
  }

  void _toggleDistrict() {
    if (_isLegendAnimating) return;
    setState(() {
      _isDistrictEnabled = !_isDistrictEnabled;
      for (var district in _districts) {
        district.isVisible = _isDistrictEnabled;
      }
    });
  }

  void _toggleDistrictVisibility(int index) {
    if (_isLegendAnimating) return;
    if (index >= 0 && index < _districts.length) {
      setState(() {
        _districts[index].isVisible = !_districts[index].isVisible;
      });
    }
  }

  List<Polygon> _buildPolygons() {
    List<Polygon> polygons = [];
    
    // Thêm polygons cho huyện
    if (_isDistrictEnabled) {
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
    }

    // Thêm polygons cho xã
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
    if (_isLegendAnimating) return;
    setState(() {
      _selectedDistrictName = name;
      _selectedCommuneName = null;
      _selectedPatent = null;
    });
    
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.districtLabel}: $name'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCommuneInfo(Commune commune) {
    if (_isLegendAnimating) return;
    setState(() {
      _selectedCommuneName = commune.name;
      _selectedDistrictName = null;
      _selectedPatent = null;
    });
    
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.communeLabel}: ${commune.name}\n'
          '${l10n.area}: ${commune.area.toStringAsFixed(2)} ${l10n.areaUnit}\n'
          '${l10n.population}: ${commune.population}\n'
          '${l10n.update}: ${commune.updatedYear}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showPatentInfo(Patent patent) {
    if (_isLegendAnimating) return;
    setState(() {
      _selectedPatent = patent;
      _selectedDistrictName = null;
      _selectedCommuneName = null;
    });
  }

  void _onMapTap(_, __) {
    if (_isLegendAnimating) return;
    setState(() {
      _selectedDistrictName = null;
      _selectedCommuneName = null;
      _selectedPatent = null;
    });
  }

  @override
  void dispose() {
    _legendAnimationController.dispose();
    _mapController.dispose();
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
      patents: _patents,
      isLoading: _isLoading,
      isLegendVisible: _isLegendVisible,
      isRightMenuOpen: _isRightMenuOpen,
      isBorderEnabled: _isBorderEnabled,
      isCommuneEnabled: _isCommuneEnabled,
      isDistrictEnabled: _isDistrictEnabled,
      isPatentEnabled: _isPatentEnabled,
      isBorderLoading: _isBorderLoading,
      isCommuneLoading: _isCommuneLoading,
      isPatentLoading: _isPatentLoading,
      selectedDistrictName: _selectedDistrictName,
      selectedCommuneName: _selectedCommuneName,
      selectedPatent: _selectedPatent,
      legendSlideAnimation: _legendSlideAnimation,
      onToggleLegend: !_isLegendAnimating && !_isDataLoading ? _toggleLegend : null,
      onToggleRightMenu: _toggleRightMenu,
      onToggleBorder: !_isLegendAnimating && !_isDataLoading ? _loadBorderData : null,
      onToggleCommune: !_isLegendAnimating && !_isDataLoading ? _loadCommuneData : null,
      onToggleDistrict: !_isLegendAnimating ? _toggleDistrict : null,
      onTogglePatent: !_isLegendAnimating && !_isDataLoading ? _loadPatentData : null,
      onToggleDistrictVisibility: _toggleDistrictVisibility,
      onZoomIn: _zoomIn,
      onZoomOut: _zoomOut,
      onShowDistrictInfo: _showDistrictInfo,
      onShowCommuneInfo: _showCommuneInfo,
      onShowPatentInfo: _showPatentInfo,
      onMapTap: _onMapTap,
      polygons: _buildPolygons(),
      borderLines: _buildBorderLines(),
    );
  }
}