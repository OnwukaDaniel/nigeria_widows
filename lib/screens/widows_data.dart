import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nigerian_widows/util/app_color.dart';
import 'package:nigerian_widows/viewmodel/users_view_model.dart';
import "package:provider/provider.dart";

import '../sharednotifiers/app.dart';
import 'WidowProfile.dart';

class WidowsData extends StatefulWidget {
  static const String id = "WidowsData";

  const WidowsData({Key? key}) : super(key: key);

  @override
  State<WidowsData> createState() => _WidowsDataState();
}

class _WidowsDataState extends State<WidowsData> {

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<UsersViewModel>().getPageCount();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Widows Data",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        children: [
          _ui(usersViewModel),
          const SizedBox(height: 16),
          _bottomPageView(usersViewModel),
        ],
      ),
    );
  }

  _ui(UsersViewModel usersViewModel) {
    if (usersViewModel.loading) {
      return SpinKitFadingCube(color: AppColor.appColor, size: 50);
    } else if (usersViewModel.userListModel.isNotEmpty) {
      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: context.watch<UsersViewModel>().userListModel.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          mainAxisExtent: 238,
        ),
        itemBuilder: (BuildContext context, int index) {
          var data = context.watch<UsersViewModel>().userListModel[index];
          double font = 9;
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/splash/african_woman.png",
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 4),
                DetailItem(data1: "Name ", data2: data.name),
                const SizedBox(height: 4),
                DetailItem(data1: "Date of birth ", data2: data.dob),
                const SizedBox(height: 4),
                DetailItem(data1: "Address ", data2: data.address),
                const SizedBox(height: 4),
                DetailItem(data1: "Phone ", data2: data.phone),
                const SizedBox(height: 4),
                DetailItem(data1: "State ", data2: data.state),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return WidowProfile(data: data);
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "View details ",
                        style: TextStyle(
                          fontSize: font + 1,
                          color: AppColor.appColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.appColor,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    } else {
      return Text(
        usersViewModel.failure.errorResponse.toString(),
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      );
    }
  }

  _bottomPageView(UsersViewModel usersViewModel) {
    var value = usersViewModel.pageIndexView;
    if (usersViewModel.pageIndexView.isEmpty) value = ["1"];
    return Center(
      child: SizedBox(
        height: 50,
        child: ValueListenableBuilder(
          valueListenable: AppNotifier.selectedPageVn,
          builder: (_, int selectedPage, Widget? child) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: value.length,
              itemBuilder: (BuildContext context, int index) {
                var s = value[index];
                double boxDim = 50;
                double borderDim = 10;
                var boxDecoration = const BoxDecoration();
                var g = const BorderSide(color: Colors.grey);
                var border = Border(top: g, bottom: g, right: g, left: g);

                if (s == value.first) {
                  boxDecoration = BoxDecoration(
                    border: border,
                    color: selectedPage.toString() == s
                        ? AppColor.appColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderDim),
                      bottomLeft: Radius.circular(borderDim),
                      bottomRight: value.length == 1
                          ? Radius.circular(borderDim)
                          : const Radius.circular(0),
                      topRight: value.length == 1
                          ? Radius.circular(borderDim)
                          : const Radius.circular(0),
                    ),
                  );
                } else if (s == value.last) {
                  boxDecoration = BoxDecoration(
                    border: border,
                    color: selectedPage.toString() == s
                        ? AppColor.appColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(0),
                      bottomLeft: const Radius.circular(0),
                      bottomRight: Radius.circular(borderDim),
                      topRight: Radius.circular(borderDim),
                    ),
                  );
                } else {
                  boxDecoration = BoxDecoration(
                    border: border,
                    color: selectedPage.toString() == s
                        ? AppColor.appColor
                        : Colors.transparent,
                  );
                }

                return GestureDetector(
                  onTap: () {
                    context.read<UsersViewModel>().setPageIndex(value[index]);
                  },
                  child: Container(
                    width: boxDim,
                    height: boxDim,
                    decoration: boxDecoration,
                    child: Center(
                      child: Text(
                        s,
                        style: TextStyle(
                          color: selectedPage.toString() == s
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String data1;
  final String data2;

  const DetailItem({
    Key? key,
    required this.data1,
    required this.data2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 9,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          Text(
            data2,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
    );
  }
}
