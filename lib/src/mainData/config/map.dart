class MapConfig {
  // Layer visibility
  static bool isBorderEnabled = false;
  static bool isCommuneEnabled = false;
  static bool isDistrictEnabled = true;
  static bool isPatentEnabled = true;
  static bool isTrademarkEnabled = true;
  static bool isIndustrialDesignEnabled = true;

  // UI state
  static bool isLegendVisible = false;
  static bool isRightMenuOpen = false;
  static bool isLegendAnimating = false;

  // Loading states
  static bool isLoading = isDistrictEnabled;
  static bool isDataLoading = false;
  static bool isBorderLoading = isBorderEnabled;
  static bool isCommuneLoading = isCommuneEnabled;
  static bool isPatentLoading = isPatentEnabled;
  static bool isTrademarkLoading = isTrademarkEnabled;
  static bool isIndustrialDesignLoading = isIndustrialDesignEnabled;

  // Map settings
  static double currentZoom = 10.0;
  static double minZoom = 8.0;
  static double maxZoom = 18.0;
  static double defaultLatitude = 10.2433;
  static double defaultLongitude = 106.3752;

  // Data refresh intervals (in minutes)
  static int dataRefreshInterval = 30;
  
  // Cache settings
  static bool enableDataCaching = true;
  static int maxCacheAge = 60; // minutes

 static double mapSearch = 18.0;
 static String mapUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
 static String mapPackage = 'com.example.app';
}