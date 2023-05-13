import 'package:nigerian_widows/repo/api_status.dart';

import '../models/WidowsData.dart';
import '../util/app_constants.dart';

class UserServices {

  static Future<Object> getPageCount() async {
    try {
      return Future(() => Success(code: AppConstants.SUCCESS, response: 30));
    } catch (e) {
      return Future(
        () => Failure(
          code: AppConstants.NO_RESPONSE,
          errorResponse: "No response",
        ),
      );
    }
  }

  static Future<Object> getUsers(int page) async {
    try {
      List<WidowData> result = [];
      for (int i = 0; i < 16; i++) {
        result.add(WidowData());
      }
      return Future(() => Success(code: 200, response: result));
    } catch (e) {
      return Future(
        () {
          return Failure(
            code: AppConstants.NO_RESPONSE,
            errorResponse: "No response",
          );
        },
      );
    }
  }
}
