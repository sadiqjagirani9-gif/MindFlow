import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindflow/core/database/app_database.dart';
import 'package:mindflow/features/tasks/data/task_repository.dart';

final taskRepositorySeedProvider = FutureProvider<void>((ref) async {
  await ref.read(taskRepositoryProvider).seedDefaultCategories();
});

final tasksProvider = StreamProvider<List<TaskRecord>>((ref) {
  ref.watch(taskRepositorySeedProvider);
  return ref.watch(taskRepositoryProvider).watchTasks();
});

final taskCategoriesProvider = StreamProvider<List<TaskCategory>>((ref) {
  ref.watch(taskRepositorySeedProvider);
  return ref.watch(taskRepositoryProvider).watchCategories();
});
