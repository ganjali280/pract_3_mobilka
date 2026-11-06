import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../services/notes_store.dart';
import '../services/text_service.dart';
import 'api_client.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() => createDio());
  getIt.registerLazySingleton<TextService>(() => TextService(getIt<Dio>()));
  getIt.registerLazySingleton<NotesStore>(() => NotesStore());
}