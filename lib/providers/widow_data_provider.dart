import 'package:riverpod/riverpod.dart';
import '../repo/api_status.dart';
import '../repo/user_service.dart';

final widowDataProvider = FutureProvider<APIResponse>((ref) async{
  return ref.watch(userProvider).getWidowsData();
});