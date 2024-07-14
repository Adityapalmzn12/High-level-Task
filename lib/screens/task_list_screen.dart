import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../stores/task_store.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskStore = Provider.of<TaskStore>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: Text('Potato Timer', style: TextStyle(color: Colors.white)),
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          itemCount: taskStore.activeTasks.length,
          itemBuilder: (context, index) {
            final task = taskStore.activeTasks[index];
            return TaskItem(task: task, taskStore: taskStore);
          },
        ),
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () => _showAddTaskDialog(context),
        elevation: 0.0,
        fillColor: Colors.transparent,
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/flIcon.png'),
          radius: 40.0,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final taskStore = Provider.of<TaskStore>(context, listen: false);
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: 'Duration (in minutes)'),
              keyboardType: TextInputType.number,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  final now = DateTime.now();
                  final durationInMinutes = time.hour * 60 + time.minute - now.hour * 60 - now.minute;
                  durationController.text = durationInMinutes.toString();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final title = titleController.text;
              final description = descriptionController.text;
              final duration = int.tryParse(durationController.text) ?? 0;

              taskStore.addTask(title, description, duration);
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final TaskStore taskStore;

  TaskItem({required this.task, required this.taskStore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (context, snapshot) {
        final elapsedTime = task.elapsedTime +
            (task.status == TaskStatus.running
                ? DateTime.now().difference(task.startTime).inSeconds
                : 0);
        final remainingTime = task.durationInMinutes * 60 - elapsedTime;

        return Card(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${Duration(seconds: remainingTime).toString().split('.').first}',
                      style: TextStyle(color: Colors.lightGreen, fontSize: 22),
                    ),
                    IconButton(
                      icon: Icon(
                        task.status == TaskStatus.running
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (task.status == TaskStatus.running) {
                          taskStore.updateTaskStatus(task.id, TaskStatus.paused);
                        } else {
                          taskStore.updateTaskStatus(task.id, TaskStatus.running);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () {
                        taskStore.updateTaskStatus(task.id, TaskStatus.completed);
                      },
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(color: Colors.lightGreen, fontSize: 22),
                ),
                Text(
                  '${task.description}',
                  style: TextStyle(color: Colors.lightGreen, fontSize: 18),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
