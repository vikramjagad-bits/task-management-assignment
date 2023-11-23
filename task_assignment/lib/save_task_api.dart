import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_assignment/typedefs.dart';

class SaveTaskApi {
  const SaveTaskApi();

  Future<void> doCallCloudCodeSaveTask(
    String? id,
    String title,
    String description,
    BoolCallback callback) async {
    //Executes a cloud function with parameters that returns a Map object
    final ParseCloudFunction function = ParseCloudFunction('saveTask');
    Map<String, dynamic> params = <String, dynamic>{
      'title': title,
      'description': description
    };
    if (id != null) {
      params['objectId'] = id;
    }
    final ParseResponse apiResponse = await function.executeObjectFunction<ParseObject>(parameters: params);
    if (apiResponse.success && apiResponse.result != null) {
      if (apiResponse.result['result'] is ParseObject) {
        final ParseObject parseObject = apiResponse.result['result'];
        print(parseObject.objectId);
        callback(true);
        return;
      }
    }
    callback(false);
  }
}