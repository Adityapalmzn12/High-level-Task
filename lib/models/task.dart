import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskStatus { running, paused, completed }

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    required DateTime startTime,
    required int durationInMinutes,
    required TaskStatus status,
    @Default(0) int elapsedTime, // Ensure elapsedTime has a default value of 0
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
