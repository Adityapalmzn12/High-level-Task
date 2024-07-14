import 'package:get_it/get_it.dart';
import 'stores/task_store.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<TaskStore>(() => TaskStore());
}
