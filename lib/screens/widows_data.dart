import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nigerian_widows/screens/transistion/RightToLeft.dart';
import 'package:nigerian_widows/util/app_color.dart';
import 'package:nigerian_widows/viewmodel/users_view_model.dart';
import "package:provider/provider.dart";

import '../sharednotifiers/app.dart';
import '../viewmodel/widows_model.dart';
import 'WidowProfile.dart';

class WidowsData extends StatefulWidget {
  static const String id = "WidowsData";

  const WidowsData({Key? key}) : super(key: key);

  @override
  State<WidowsData> createState() => _WidowsDataState();
}

class _WidowsDataState extends State<WidowsData> {
  double bottomBarHeight = 60;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppNotifier.toolbarTitleVn.value = "Widow's data";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    WidowsViewModel widowsViewModel = context.watch<WidowsViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 16),
              _ui2(widowsViewModel),
              SizedBox(height: bottomBarHeight),
            ],
          ),
          _bottomPageView(widowsViewModel),
        ],
      ),
    );
  }

  _ui2(WidowsViewModel widowsViewModel) {
    if (widowsViewModel.loading) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        AppNotifier.toolbarTitleVn.value = "Loading ...";
      });

      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 20,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          mainAxisExtent: 238,
        ),
        itemBuilder: (BuildContext context, int index) {
          double font = 9;

          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.account_circle_outlined,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 4),
                const DetailItem(data1: "Name ", data2: "-----"),
                const SizedBox(height: 4),
                const DetailItem(data1: "Date of birth ", data2: "-----"),
                const SizedBox(height: 4),
                const DetailItem(data1: "Address ", data2: "-----"),
                const SizedBox(height: 4),
                const DetailItem(data1: "Phone ", data2: "-----"),
                const SizedBox(height: 4),
                const DetailItem(data1: "State ", data2: "-----"),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "......",
                      style: TextStyle(
                        fontSize: font + 1,
                        color: AppColor.appColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    } else {
      if (widowsViewModel.success) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          AppNotifier.toolbarTitleVn.value = "Widow's data";
        });
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: context.read<WidowsViewModel>().specificPageData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            mainAxisExtent: 238,
          ),
          itemBuilder: (BuildContext context, int index) {
            double font = 9;
            int countPerPage = context.read<WidowsViewModel>().countPerPage;
            int pageNumber = context.read<WidowsViewModel>().pagesCurrent;
            var data = context.read<WidowsViewModel>().specificPageData[index];

            var img =
                "assets/widow_images/profile${(pageNumber - 1) * countPerPage + index + 1}.png";

            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.asset(
                    img,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 4),
                  DetailItem(data1: "Name ", data2: data.fullName!),
                  const SizedBox(height: 4),
                  DetailItem(data1: "Date of birth ", data2: data.dob!),
                  const SizedBox(height: 4),
                  DetailItem(data1: "Address ", data2: data.address!),
                  const SizedBox(height: 4),
                  DetailItem(data1: "Phone ", data2: data.phoneNumber!),
                  const SizedBox(height: 4),
                  DetailItem(data1: "State ", data2: data.state!),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        RightToLeft(page: WidowProfile(data: data, image: img)),
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
          "Failure",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        );
      }
    }
    return SizedBox();
  }

  _bottomPageView(WidowsViewModel widowsViewModel) {
    var value = widowsViewModel.pageIndexView;
    if (widowsViewModel.pageIndexView.isEmpty) value = ["1"];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                height: bottomBarHeight,
                child: ValueListenableBuilder(
                  valueListenable: AppNotifier.selectedPageVn,
                  builder: (_, int selectedPage, Widget? child) {
                    return ListView.builder(
                      primary: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: value.length,
                      itemBuilder: (BuildContext context, int index) {
                        var s = value[index];
                        double boxDim = 50;
                        double borderDim = 10;
                        var boxDecoration = const BoxDecoration();
                        var g = const BorderSide(color: Colors.grey);
                        var border =
                            Border(top: g, bottom: g, right: g, left: g);

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
                            context
                                .read<WidowsViewModel>()
                                .setPageIndex(value[index]);
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
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
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
            ),
          ),
        ),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({
    Key? key,
    required this.data1,
    required this.data2,
    this.isName = false,
  }) : super(key: key);

  final bool isName;
  final String data1;
  final String data2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            data1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 9,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Text(
              data2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 9,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
