import 'package:flutter/material.dart';
import 'package:shtt_bentre/src/mainData/config/map.dart';

class MapTypeSelector extends StatelessWidget {
  final MapType currentMapType;
  final Function(MapType) onChangeMapType;
  
  const MapTypeSelector({
    super.key,
    required this.currentMapType,
    required this.onChangeMapType,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).padding.top + 80,
      child: PopupMenuButton<MapType>(
        onSelected: onChangeMapType,
        offset: const Offset(0, 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),  
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                currentMapType == MapType.streets 
                  ? Icons.map
                  : currentMapType == MapType.satellite
                    ? Icons.satellite 
                    : Icons.terrain,
                size: 20,
                color: Colors.black87,
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MapType>>[
          const PopupMenuItem<MapType>(
            value: MapType.streets,
            child: Row(
              children: [
                Icon(Icons.map, size: 20),
                SizedBox(width: 12),
                Text('Đường phố'),
              ],
            ),
          ),
          const PopupMenuItem<MapType>(
            value: MapType.satellite,
            child: Row(
              children: [
                Icon(Icons.satellite, size: 20),  
                SizedBox(width: 12),
                Text('Vệ tinh'),
              ],
            ),
          ),
          const PopupMenuItem<MapType>(
            value: MapType.terrain,
            child: Row(
              children: [
                Icon(Icons.terrain, size: 20),
                SizedBox(width: 12), 
                Text('Địa hình'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}