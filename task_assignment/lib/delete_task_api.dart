import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_assignment/typedefs.dart';

class DeleteTaskApi {
  const DeleteTaskApi();

  Future<void> doCallCloudCodeDeleteTask(
    String id,
    BoolCallback callback) async {
    //Executes a cloud function with parameters that returns a Map object
    final ParseCloudFunction function = ParseCloudFunction('deleteTask');
    final Map<String, dynamic> params = <String, dynamic>{
      'objectId': id
    };
    final ParseResponse apiResponse = await function.executeObjectFunction<ParseObject>(parameters: params);
    if (apiResponse.success && apiResponse.result != null) {
      if (apiResponse.result['result'] is ParseObject) {
        final ParseObject parseObject = apiResponse.result['result'];
        print(parseObject.objectId);
        callback(true);
      }
    }
    callback(false);
  }
}