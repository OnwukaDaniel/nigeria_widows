// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:nigerian_widows/models/WidowsData.dart';
// import 'package:nigerian_widows/repo/api_status.dart';
// import 'package:nigerian_widows/repo/user_service.dart';
//
// import '../models/HomePageData.dart';
// import '../util/app_constants.dart';
//
// class ChartViewModel extends ChangeNotifier {
//   bool _loading = false;
//   HomePageData _chartModel = HomePageData.getDefault();
//   bool _success = false;
//
//   bool get loading => _loading;
//
//   HomePageData get chartModel => _chartModel;
//
//   bool get success => _success;
//
//   ChartViewModel() {
//     getChatData();
//   }
//
//   setLoading(bool loading) async {
//     _loading = loading;
//     notifyListeners();
//   }
//
//   setChatDataModel(HomePageData input) {
//     _chartModel = input;
//   }
//
//   setSuccess(bool success) {
//     _success = success;
//   }
//
//   getChatData() async {
//     setLoading(true);
//     var response = await UserServices.getChatData() as APIResponse;
//     if(response.code == AppConstants.SUCCESS){
//       HomePageData data = HomePageData.fromJson(jsonDecode(response.response));
//       _chartModel = data;
//       setLoading(false);
//       setSuccess(true);
//     } else {
//       setLoading(false);
//       setSuccess(false);
//     }
//   }
// }
