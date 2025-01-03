import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrialDesign/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrialDesign/industrial_design_detail.dart';
import 'package:shtt_bentre/src/mainData/data/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/database/database_exception.dart';

class IndustrialDesignService {
 static String industrialDesignUrl = MainUrl.industrialDesignUrl;

  Future<List<IndustrialDesignModel>> fetchIndustrialDesigns({
    String? search,
    String? type,
    String? year,
    String? district,
  }) async {
    try {
      List<IndustrialDesignModel> results = [];
      Set<int> uniqueIds = {};

      if (search != null && search.isNotEmpty) {
        // Tìm theo tên
        final resultsByName = await _fetchWithParams({'name': search});
        for (var design in resultsByName) {
          if (uniqueIds.add(design.id)) {
            results.add(design);
          }
        }

        // Tìm theo chủ sở hữu
        final resultsByOwner = await _fetchWithParams({'owner': search});
        for (var design in resultsByOwner) {
          if (uniqueIds.add(design.id)) {
            results.add(design);
          }
        }

        // Tìm theo địa chỉ
        final resultsByAddress = await _fetchWithParams({'address': search});
        for (var design in resultsByAddress) {
          if (uniqueIds.add(design.id)) {
            results.add(design);
          }
        }

        // Tìm theo số đơn
        final resultsByFilingNumber = await _fetchWithParams({'filing_number': search});
        for (var design in resultsByFilingNumber) {
          if (uniqueIds.add(design.id)) {
            results.add(design);
          }
        }
      } else {
        // Nếu không có search term, chỉ áp dụng các bộ lọc
        var queryParams = <String, String>{};
        if (type != null) queryParams['type'] = type;
        if (year != null) queryParams['year'] = year;
        if (district != null) queryParams['district'] = district;
        
        results = await _fetchWithParams(queryParams);
        return results;
      }

      // Nếu có kết quả search và có bộ lọc, thực hiện lọc thêm
      if (type != null || year != null || district != null) {
        // Gọi API để lấy kết quả theo type
        if (type != null) {
          final resultsByType = await _fetchWithParams({'type': type});
          results = results.where((design) => 
            resultsByType.any((typeDesign) => typeDesign.id == design.id)
          ).toList();
        }

        // Lọc theo năm
        if (year != null) {
          results = results.where((design) => 
            design.filingDate.year.toString() == year
          ).toList();
        }

        // Lọc theo district
        if (district != null) {
          results = results.where((design) => 
            design.address.toLowerCase().contains(district.toLowerCase())
          ).toList();
        }
      }

      return results;

    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Unexpected error: $e');
    }
  }

  Future<List<IndustrialDesignModel>> _fetchWithParams(Map<String, String> queryParams) async {
    try {
      final uri = Uri.parse(industrialDesignUrl).replace(queryParameters: queryParams);
      
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw DatabaseException('Timeout when fetching industrial designs');
        },
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          
          if (jsonResponse['status'] != 'success') {
            throw DatabaseException('API returned unsuccessful status: ${jsonResponse['status']}');
          }
          
          if (jsonResponse['data'] == null) {
            return [];
          }
          
          if (jsonResponse['data'] is! List) {
            throw DatabaseException('API returned invalid data format: expected List but got ${jsonResponse['data'].runtimeType}');
          }

          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) {
            try {
              return IndustrialDesignModel.fromJson(json);
            } catch (e) {
              throw DatabaseException('Error parsing industrial design: $e');
            }
          }).toList();
        } on FormatException catch (e) {
          throw DatabaseException('Invalid JSON format: $e');
        }
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode >= 500) {
        throw DatabaseException('Server error: ${response.statusCode}');
      } else {
        throw DatabaseException('Failed to load industrial designs: ${response.statusCode}');
      }
    } on SocketException {
      throw DatabaseException('No internet connection');
    } catch (e) {
      if (e is DatabaseException) rethrow;
      throw DatabaseException('Unexpected error: $e');
    }
  }

 Future<IndustrialDesignDetailModel> fetchIndustrialDesignDetail(String id) async {
   try {
     final response = await http.get(
       Uri.parse('$industrialDesignUrl/$id'),
     ).timeout(
       const Duration(seconds: 30),
       onTimeout: () {
         throw DatabaseException('Timeout when fetching industrial design detail');
       },
     );

     if (response.statusCode == 200) {
       try {
         final Map<String, dynamic> jsonResponse = json.decode(response.body);
         
         if (jsonResponse['status'] != 'success') {
           throw DatabaseException('API returned unsuccessful status: ${jsonResponse['status']}');
         }
         
         if (jsonResponse['data'] == null) {
           throw DatabaseException('API returned null data');
         }

         return IndustrialDesignDetailModel.fromJson(jsonResponse['data']);
       } on FormatException catch (e) {
         throw DatabaseException('Invalid JSON format: $e');
       }
     } else if (response.statusCode == 404) {
       throw DatabaseException('Industrial design with ID $id not found');
     } else if (response.statusCode >= 500) {
       throw DatabaseException('Server error: ${response.statusCode}');
     } else {
       throw DatabaseException('Failed to load industrial design detail: ${response.statusCode}');
     }
   } on SocketException {
     throw DatabaseException('No internet connection');
   } catch (e) {
     if (e is DatabaseException) rethrow;
     throw DatabaseException('Unexpected error: $e');
   }
 }

 Future<List<IndustrialDesignMapModel>> loadIndustrialDesignLocations() async {
   try {
     final response = await http.get(
       Uri.parse(MainUrl.industrialLocationsDesignUrl)
     );

     if (response.statusCode == 200) {
       final Map<String, dynamic> jsonResponse = json.decode(response.body);
       if (jsonResponse['success'] == true || jsonResponse['data'] is List) {
         final List<dynamic> data = jsonResponse['data'];
         return data.map((json) => IndustrialDesignMapModel.fromJson(json)).toList();
       }
     }
     print('Response status: ${response.statusCode}');
     print('Response body: ${response.body}');
     return [];
   } catch (e) {
     print('Error loading industrial design locations: $e');
     return [];
   }
 }

 Future<List<Map<String, dynamic>>> fetchDesignTypes() async {
   try {
     final response = await http.get(
       Uri.parse('$industrialDesignUrl/stats/by-type'),
     );

     if (response.statusCode == 200) {
       final Map<String, dynamic> jsonResponse = json.decode(response.body);
       if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
         return List<Map<String, dynamic>>.from(jsonResponse['data']);
       }
     }
     return [];
   } catch (e) {
     print('Error fetching design types: $e');
     return [];
   }
 }

 Future<List<String>> fetchDesignYears() async {
   try {
     final response = await http.get(
       Uri.parse('$industrialDesignUrl/stats/by-year'),
     );

     if (response.statusCode == 200) {
       final Map<String, dynamic> jsonResponse = json.decode(response.body);
       if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
         return List<String>.from(
           jsonResponse['data'].map((item) => item['year'].toString()),
         );
       }
     }
     return [];
   } catch (e) {
     print('Error fetching design years: $e');
     return [];
   }
 }

 Future<List<Map<String, dynamic>>> fetchDesignDistricts() async {
   try {
     final response = await http.get(
       Uri.parse('$industrialDesignUrl/stats/by-district'),
     );

     if (response.statusCode == 200) {
       final Map<String, dynamic> jsonResponse = json.decode(response.body);
       if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
         return List<Map<String, dynamic>>.from(jsonResponse['data']);
       }
     }
     return [];
   } catch (e) {
     print('Error fetching design districts: $e');
     return [];
   }
 }
}