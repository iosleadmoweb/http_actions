import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerPreference {
  CacheManagerPreference._privateConstructor();

  static final CacheManagerPreference instance =
      CacheManagerPreference._privateConstructor();

  static const key = 'customCacheKey';
  CacheManager cacheManager = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: key),
    ),
  );

  Future<bool> checkConnection() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> clearCache() async {
    await cacheManager.emptyCache();
  }
}
