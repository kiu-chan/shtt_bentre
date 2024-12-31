import 'package:shtt_bentre/src/mainData/data/home/about.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication.dart';
import 'package:shtt_bentre/src/mainData/data/home/geoIndication/geo_indication_detail_model.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrialDesign/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/home/industrialDesign/industrial_design_detail.dart';
import 'package:shtt_bentre/src/mainData/data/home/initiative/initiative.dart';
import 'package:shtt_bentre/src/mainData/data/home/patent/patent.dart';
import 'package:shtt_bentre/src/mainData/data/home/product/product.dart';
import 'package:shtt_bentre/src/mainData/data/home/researchProject/research_project.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark.dart';
import 'package:shtt_bentre/src/mainData/data/home/trademark/trademark_detail.dart';
import 'package:shtt_bentre/src/mainData/data/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/data/map/commune.dart';
import 'package:shtt_bentre/src/mainData/data/map/district.dart';
import 'package:shtt_bentre/src/mainData/data/map/border.dart';
import 'package:shtt_bentre/src/mainData/data/patent.dart';
import 'package:shtt_bentre/src/mainData/data/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/home/about.dart';
import 'package:shtt_bentre/src/mainData/database/home/geo_indication.dart';
import 'package:shtt_bentre/src/mainData/database/home/industrial_design.dart';
import 'package:shtt_bentre/src/mainData/database/home/initiative.dart';
import 'package:shtt_bentre/src/mainData/database/home/news.dart';
import 'package:shtt_bentre/src/mainData/database/home/patents.dart';
import 'package:shtt_bentre/src/mainData/database/home/product.dart';
import 'package:shtt_bentre/src/mainData/database/home/research_project.dart';
import 'package:shtt_bentre/src/mainData/database/home/trademark.dart';
import 'package:shtt_bentre/src/mainData/database/map/mapData.dart';
import 'package:shtt_bentre/src/mainData/database/map/pointsData.dart';

class Database {
  static final Database _instance = Database._internal();

  factory Database() {
    return _instance;
  }

  Database._internal();

  MapData map = MapData();
  Pointsdata points = Pointsdata();
  AboutData abouts  = AboutData();
  GeoIndicationService geo = GeoIndicationService();
  IndustrialDesignService industrialDesign = IndustrialDesignService();
  InitiativeService initiative = InitiativeService();
  NewsService news = NewsService();
  PatentsDatabase patent = PatentsDatabase();
  ResearchProjectService rp = ResearchProjectService();
  TrademarkService trademark = TrademarkService();
  ProductRegistrationService product = ProductRegistrationService();

  Future<List<Commune>> loadCommuneData() async {
    return await map.loadCommuneData();
  }

  Future<List<District>> loadDistrictData() async {
    return await map.loadDistrictData();
  }

  Future<List<MapBorder>> loadBorderData() async {
    return await map.loadBorderData();
  }

  Future<List<Patent>> loadPatentData() async {
    return await points.loadPatentData();
  }

  Future<List<TrademarkMapModel>> loadTrademarkLocations() async {
    return await points.loadTrademarkLocations();
  }

  Future<AboutModel> fetchAboutData() async {
    return await abouts.fetchAboutData();
  }

  Future<List<GeoIndicationModel>> fetchGeoIndications() async {
    return await geo.fetchGeoIndications();
  }

  Future<GeoIndicationDetailModel> fetchGeoIndicationDetail(int stt) async {
    return await geo.fetchGeoIndicationDetail(stt);
  }

  Future<List<IndustrialDesignModel>> fetchIndustrialDesigns() async {
    return await industrialDesign.fetchIndustrialDesigns();
  }

  Future<IndustrialDesignDetailModel> fetchIndustrialDesignDetail(String id) async {
    return await industrialDesign.fetchIndustrialDesignDetail(id);
  }

  Future<List<IndustrialDesignMapModel>> loadIndustrialDesignLocations() async {
    return await industrialDesign.loadIndustrialDesignLocations();
  }

  Future<List<InitiativeModel>> fetchInitiatives() async {
    return await initiative.fetchInitiatives();
  }

  Future<Map<String, dynamic>> fetchInitiativeDetail(String id) async {
    return await initiative.fetchInitiativeDetail(id);
  }

  Future<List<Map<String, dynamic>>> fetchNews() async {
    return await news.fetchNews();
  }

  Future<Map<String, dynamic>> fetchNewsDetail(String id) async {
    return await news.fetchNewsDetail(id);
  }

  Future<List<PatentModel>> fetchPatents() async {
    return await patent.fetchPatents();
  }

  Future<Map<String, dynamic>> fetchPatentDetail(String id) async {
    return await patent.fetchPatentDetail(id);
  }

  Future<List<ResearchProjectModel>> fetchResearchProjects() async {
    return await rp.fetchResearchProjects();
  }

  Future<ResearchProjectModel> fetchResearchProjectDetail(String id) async {
    return await rp.fetchResearchProjectDetail(id);
  }

  Future<List<TrademarkModel>> fetchTrademarks({int page = 1, String? search}) async {
    return await trademark.fetchTrademarks(page: page, search: search);
  }

  Future<TrademarkDetailModel> fetchTrademarkDetail(int id) async {
    return await trademark.fetchTrademarkDetail(id);
  }

  Future<List<ProductRegistrationModel>> fetchProducts({int page = 1}) async {
    return await product.fetchProducts(page: page);
  }

  Future<Map<String, dynamic>> fetchProductDetail(String id) async {
    return await product.fetchProductDetail(id);
  }

  void dispose() {
    // Cleanup if needed
  }
}