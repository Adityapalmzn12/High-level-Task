// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TaskStore on _TaskStore, Store {
  Computed<List<Task>>? _$activeTasksComputed;

  @override
  List<Task> get activeTasks =>
      (_$activeTasksComputed ??= Computed<List<Task>>(() => super.activeTasks,
              name: '_TaskStore.activeTasks'))
          .value;

  late final _$tasksAtom = Atom(name: '_TaskStore.tasks', context: context);

  @override
  ObservableList<Task> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(ObservableList<Task> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
    });
  }

  late final _$_TaskStoreActionController =
      ActionController(name: '_TaskStore', context: context);

  @override
  void addTask(String title, String description, int durationInMinutes) {
    final _$actionInfo =
        _$_TaskStoreActionController.startAction(name: '_TaskStore.addTask');
    try {
      return super.addTask(title, description, durationInMinutes);
    } finally {
      _$_TaskStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateTaskStatus(String id, TaskStatus status) {
    final _$actionInfo = _$_TaskStoreActionController.startAction(
        name: '_TaskStore.updateTaskStatus');
    try {
      return super.updateTaskStatus(id, status);
    } finally {
      _$_TaskStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTask(String id) {
    final _$actionInfo =
        _$_TaskStoreActionController.startAction(name: '_TaskStore.removeTask');
    try {
      return super.removeTask(id);
    } finally {
      _$_TaskStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tasks: ${tasks},
activeTasks: ${activeTasks}
    ''';
  }
}
