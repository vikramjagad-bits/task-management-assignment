import 'package:flutter/material.dart';
import 'package:task_assignment/delete_task_api.dart';
import 'package:task_assignment/main.dart';
import 'package:task_assignment/save_task_api.dart';

enum TaskDetailType {
  detail,
  newTask,
  editTask
}

class TaskDetailPage extends StatefulWidget {
  final Task task;
  TaskDetailType taskDetailType;

  TaskDetailPage(Key? key, this.task, this.taskDetailType): super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(getTitle()),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: getActions(),
      ),
      body: Column(
        children: getViews()
      )
    );
  }

  List<Widget> getViews() {
    switch (widget.taskDetailType) {
      case TaskDetailType.detail: {
        return [
          SizedBox(height: 25),
          getRow(widget.task.title, 16, FontWeight.w400),
          getRow(widget.task.description, 14, FontWeight.w400),
        ];
      }
      case TaskDetailType.editTask: {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16
            ),
            child: TextFormField(
              controller: _titleEditingController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter task name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16
            ),
            child: TextFormField(
              controller: _descriptionEditingController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter task description',
              ),
            ),
          )
        ];
      }
      case TaskDetailType.newTask:
      return [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: TextFormField(
            controller: _titleEditingController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter task name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: TextFormField(
            controller: _descriptionEditingController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter task description',
            ),
          ),
        )
      ];
    }
  }

  Row getRow(String text, double? fontSize, FontWeight fontWeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          )
        ),
        SizedBox(width: 16)
      ],
    );
  }

  String getTitle() {
    switch (widget.taskDetailType) {
      case TaskDetailType.detail: 
        return 'Task Detail';
      case TaskDetailType.newTask:
        return 'Add new Task';
      case TaskDetailType.editTask:
        return 'Edit Task';
    }
  }

  List<Widget> getActions() {
    switch (widget.taskDetailType) {
    case TaskDetailType.detail:
      return [
        IconButton(
          onPressed: () => DeleteTaskApi().doCallCloudCodeDeleteTask(
            widget.task.id,
            (success) => {
              if (success) {
                Navigator.pop(context)
              }
            }
          ),
          icon: Icon(Icons.delete)
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _titleEditingController.text = widget.task.title;
              _descriptionEditingController.text = widget.task.description;
              widget.taskDetailType = TaskDetailType.editTask;
            });
          },
          icon: Icon(Icons.edit)
        )
      ];
    case TaskDetailType.editTask:
      return [
        IconButton(
          onPressed: () => SaveTaskApi().doCallCloudCodeSaveTask(
            widget.task.id,
            _titleEditingController.text,
            _descriptionEditingController.text,
            (success) {
              if (success) {
                Navigator.pop(context);
              }
            }
          ),
          icon: Icon(Icons.save)
        )
      ];
    case TaskDetailType.newTask:
      return [
        IconButton(
          onPressed: () => SaveTaskApi().doCallCloudCodeSaveTask(
            null,
            _titleEditingController.text,
            _descriptionEditingController.text,
            (success) {
              if (success) {
                Navigator.pop(context);
              }
            }
          ),
          icon: Icon(Icons.save)
        )
      ];
    }
  }
}
