import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nigerian_widows/repo/api_status.dart';
import 'package:riverpod/riverpod.dart';

import '../models/WidowData.dart';
import '../util/app_constants.dart';

abstract class WidowService{
  Future getWidowData({int input = -1});
}

class UserServices {
  static Future<Object> getPageCount() async {
    return Future(() => Success(code: AppConstants.SUCCESS, response: 30));
  }

  static Future<Object> getUsers(int page) async {
    List<WidowData> result = [];
    for (int i = 0; i < 16; i++) {
      //result.add(WidowData(name: page.toString()));
    }
    return Future(() => Success(code: 200, response: result));
  }

  static Future<Object> getChatData() async {
    Response response = await http.get(
      Uri.parse(
        'https://us-central1-ondo-widows-f2964.cloudfunctions.net/homepageData',
      ),
    );
    if (response.statusCode == AppConstants.SUCCESS) {
      return APIResponse(
        code: AppConstants.SUCCESS,
        response: response.body,
      );
    } else {
      return APIResponse(
        code: AppConstants.FAILURE,
        response: "No response",
      );
    }
  }

  Future<APIResponse> getWidowsData({int input = -1}) async {
    Response response = await http.get(
      Uri.parse(
        'https://us-central1-ondo-widows-f2964.cloudfunctions.net/allWidows?lastIndex=$input',
      ),
    );

    if (response.statusCode == AppConstants.SUCCESS) {
      return APIResponse(
        code: AppConstants.SUCCESS,
        response: response.body,
      );
    } else {
      return APIResponse(
        code: AppConstants.FAILURE,
        response: "No response",
      );
    }
  }
}

final userProvider = Provider<UserServices>((ref)=> UserServices());