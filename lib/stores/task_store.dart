import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import 'dart:convert';

part 'task_store.g.dart';

class TaskStore = _TaskStore with _$TaskStore;

abstract class _TaskStore with Store {
  final uuid = Uuid();
  Timer? timer;

  _TaskStore() {
    _loadTasks();
    timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateTasks());
  }

  @observable
  ObservableList<Task> tasks = ObservableList<Task>();

  @action
  void addTask(String title, String description, int durationInMinutes) {
    final newTask = Task(
      id: uuid.v4(),
      title: title,
      description: description,
      startTime: DateTime.now(),
      durationInMinutes: durationInMinutes,
      status: TaskStatus.running, // Set default status to running
      elapsedTime: 0, // Initialize elapsedTime to 0
    );
    tasks.add(newTask);
    _saveTasks();
  }

  @action
  void updateTaskStatus(String id, TaskStatus status) {
    final task = tasks.firstWhere((task) => task.id == id);
    final index = tasks.indexOf(task);
    if (status == TaskStatus.running) {
      tasks[index] = task.copyWith(
        status: status,
        startTime: DateTime.now(),
      );
    } else {
      final elapsedTime = task.elapsedTime +
          DateTime.now().difference(task.startTime).inSeconds;
      tasks[index] = task.copyWith(
        status: status,
        elapsedTime: elapsedTime,
      );
    }
    _saveTasks();
  }

  @action
  void updateTaskElapsedTime(String id) {
    final task = tasks.firstWhere((task) => task.id == id);
    final index = tasks.indexOf(task);
    if (task.status == TaskStatus.running) {
      final elapsedTime = task.elapsedTime +
          DateTime.now().difference(task.startTime).inSeconds;
      tasks[index] = task.copyWith(
        elapsedTime: elapsedTime,
        startTime: DateTime.now(),
      );
    }
    _saveTasks();
  }

  @action
  void removeTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    _saveTasks();
  }

  @computed
  List<Task> get activeTasks {
    return tasks.where((task) {
      final elapsedTime = task.elapsedTime +
          (task.status == TaskStatus.running
              ? DateTime.now().difference(task.startTime).inSeconds
              : 0);
      return task.status != TaskStatus.completed &&
          elapsedTime < task.durationInMinutes * 60;
    }).toList();
  }

  void _updateTasks() {
    for (var task in tasks) {
      if (task.status == TaskStatus.running &&
          DateTime.now().difference(task.startTime).inSeconds +
              task.elapsedTime >=
              task.durationInMinutes * 60) {
        updateTaskStatus(task.id, TaskStatus.completed);
      } else if (task.status == TaskStatus.running) {
        updateTaskElapsedTime(task.id);
      }
    }
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];
    tasks = ObservableList<Task>.of(taskList.map((task) => Task.fromJson(jsonDecode(task))));
  }
}
