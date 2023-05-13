import 'package:flutter/material.dart';
import 'package:nigerian_widows/util/app_color.dart';

import '../models/WidowsData.dart';
import 'WidowProfile.dart';

class WidowsData extends StatefulWidget {
  static const String id = "WidowsData";

  const WidowsData({Key? key}) : super(key: key);

  @override
  State<WidowsData> createState() => _WidowsDataState();
}

class _WidowsDataState extends State<WidowsData> {
  ValueNotifier<List<String>> pageVn = ValueNotifier(["1", "2", "3", "4", "5"]);
  ValueNotifier<int> selectedPageVn = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.toInt();

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
          GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: generate().length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              mainAxisExtent: 238,
            ),
            itemBuilder: (BuildContext context, int index) {
              var data = generate()[index];
              double font = 9;
              String data1 = "Name ";
              String data2 = data.name;
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
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: pageVn,
            builder: (_, List<String> value, Widget? child) {
              return Center(
                child: SizedBox(
                  height: 50,
                  child: ValueListenableBuilder(
                    valueListenable: selectedPageVn,
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
                          if (s == "1") {
                            boxDecoration = BoxDecoration(
                              color: selectedPage == index
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
                          } else if (index == value.length - 1) {
                            boxDecoration = BoxDecoration(
                              color: selectedPage == index
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
                              color: selectedPage == index
                                  ? AppColor.appColor
                                  : Colors.transparent,
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              selectedPageVn.value = index;
                            },
                            child: Container(
                              width: boxDim,
                              height: boxDim,
                              decoration: boxDecoration,
                              child: Center(child: Text(s)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  List<WidowData> generate() {
    List<WidowData> result = [];
    for (int i = 0; i < 30; i++) {
      result.add(WidowData());
    }
    return result;
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({
    Key? key,
    required this.data1,
    required this.data2,
  }) : super(key: key);

  final String data1;
  final String data2;

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
