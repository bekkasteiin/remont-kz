import 'package:get_it/get_it.dart';
import 'package:remont_kz/data/api_builder.dart';
import 'package:remont_kz/domain/services/token_store_service.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // @Important: всегда должен инжектиться первым
  _registerRouting();
  _registerFactories();
  _registerSingletons();
  _registerBlocs();
  await getIt.allReady();
}

void _registerSingletons() {
  //для будущего разработки
  getIt.registerSingleton<ApiBuilder>(ApiBuilder());
  getIt.registerSingleton<TokenStoreService>(TokenStoreService());


}

Future<void> _registerRouting() async {}

void _registerBlocs() {
  //для будущего разработки
  // getIt.registerSingleton<AuthSmsCubit>(AuthSmsCubit());
  // getIt.registerSingleton<AuhtPhoneCubit>(AuhtPhoneCubit());
  // getIt.registerSingleton<ProfileCubit>(ProfileCubit());
  // getIt.registerSingleton<ChatCubit>(ChatCubit());
  // getIt.registerSingleton<SingleChatCubit>(SingleChatCubit());
  // getIt.registerSingleton<CardProfilesCubit>(CardProfilesCubit());

}

void _registerFactories() {
  //для будущего разработки
  // getIt.registerSingleton<ConnectivityService>(ConnectivityService());
  // getIt.registerSingleton<ModalService>(ModalService());
  // getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  // getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl());
  // getIt.registerLazySingleton<ChatRepo>(() => ChatRepoImpl());
}
