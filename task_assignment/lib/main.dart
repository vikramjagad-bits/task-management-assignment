import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_assignment/task_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = '3PkNWugkMZfbU0iECBJxTic8zn7Yl5oYVCcdZxO6';
  const keyClientKey = 'A8xycvMKKwk04Tqpz6jI9uSoK52F0rA47tGMqnGJ';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MaterialApp(
    home: TaskManagement(),
  ));
}

class Task {
  String id;
  String title;
  String description;

  static const idKey = 'objectId';
  static const titleKey = 'title';
  static const descriptionKey = 'description';

  Task(this.id, this.title, this.description);

  Task.fromJson(Map map)
    : id = map[idKey] ?? '',
      title = map[titleKey] ?? '',
      description = map[descriptionKey] ?? '';
}


class TaskManagement extends StatefulWidget {
  @override
  _TaskManagementState createState() => _TaskManagementState();
}

class _TaskManagementState extends State<TaskManagement> {
  late Future<List<dynamic>> _taskList;

  @override
  void initState() {
    super.initState();
    _taskList = doCallCloudCodeGetTaskList();
  }

  void _retry() {
    _taskList = doCallCloudCodeGetTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Management"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () { 
              navigateToTaskDetailPage(context, Task('', '', ''), TaskDetailType.newTask);
            },
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _taskList,
        builder: getListView
      ),
    );
  }

  Widget getListView(context, snapshot) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.0),
      itemCount: snapshot.data?.length ?? 0,
      itemBuilder: (context, index) {
        final task = Task.fromJson(snapshot.data![index]);
        return ListTile(  
          title: Text(task.title),  
          subtitle: Text(task.description),
          onTap: () {
            navigateToTaskDetailPage(context, task, TaskDetailType.detail);
          },
        );
      }
    );
  }

  Future<dynamic> navigateToTaskDetailPage(BuildContext context, Task task, TaskDetailType type) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(null, task, type)
      )
    ).then((_) => {
      setState(() {
        _retry();
      })
    });
  }

  Future<List<dynamic>> doCallCloudCodeGetTaskList() async {
    //Executes a cloud function with parameters that returns a Map object
    final ParseCloudFunction function = ParseCloudFunction('getTaskList');
    final ParseResponse apiResponse = await function.execute();
    if (apiResponse.success) {
      return apiResponse.result;
    } else {
      return [];
    }
  }
}
