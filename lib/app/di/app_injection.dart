import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:life_insurance/core/core.dart'
    show
        BiometricService,
        ILocalCacheService,
        LocalCacheService,
        NetworkClient,
        NetworkServiceType;
import 'package:life_insurance/features/auth/auth.dart';
import 'package:life_insurance/features/features.dart' show AppearanceBloc;

abstract class AppInjection {
  static final sl = GetIt.instance;
  static Future<void> initDependencies() async {
    // External
    sl.registerLazySingleton<LocalCacheService>(() => ILocalCacheService());
    sl.registerLazySingleton<Dio>(
      () => NetworkClient.getClient(NetworkServiceType.protected),
    );
    sl.registerLazySingleton<BiometricService>(() => BiometricService());

    // BLoC
    sl.registerFactory(() => AppearanceBloc(localCacheService: sl()));
    // Repository
    sl.registerFactory<AuthRepository>(
      () => IAuthRepository(tokenStorage: sl(), biometricService: sl()),
    );
  }
}
