import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nigerian_widows/util/app_constants.dart';

import '../../controller/HomePageController.dart';
import '../../future_providers/chart_future_provider.dart';
import '../../sharednotifiers/app.dart';
import '../../util/app_color.dart';

class WidowLandingBottomNavigation extends ConsumerWidget {
  const WidowLandingBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(chartFutureProvider).when(
          data: (data) {
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
                        height: AppConstants.bottomBarHeight,
                        child: ValueListenableBuilder(
                          valueListenable: AppNotifier.selectedPageVn,
                          builder: (_, int selectedPage, __) {
                            var pageData = pageToPagination(
                              data.data.widowsCount.count ~/ 18,
                              currentPage: selectedPage,
                            );

                            return ListView.builder(
                              primary: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: pageData.length,
                              itemBuilder: (BuildContext context, int index) {
                                var pageDatum = pageData[index];
                                double boxDim = 50;
                                double borderDim = 10;
                                var boxDecoration = const BoxDecoration();
                                var g = const BorderSide(color: Colors.grey);
                                var border = Border(
                                  top: g,
                                  bottom: g,
                                  right: g,
                                  left: g,
                                );
                                if (pageDatum == pageData.first) {
                                  boxDecoration = BoxDecoration(
                                    border: border,
                                    color: selectedPage.toString() == pageDatum
                                        ? AppColor.appColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(borderDim),
                                      bottomLeft: Radius.circular(borderDim),
                                      bottomRight: pageData.length == 1
                                          ? Radius.circular(borderDim)
                                          : const Radius.circular(0),
                                      topRight: pageData.length == 1
                                          ? Radius.circular(borderDim)
                                          : const Radius.circular(0),
                                    ),
                                  );
                                } else if (pageDatum == pageData.last) {
                                  boxDecoration = BoxDecoration(
                                    border: border,
                                    color: selectedPage.toString() == pageDatum
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
                                    color: selectedPage.toString() == pageDatum
                                        ? AppColor.appColor
                                        : Colors.transparent,
                                  );
                                }

                                return GestureDetector(
                                  onTap: () {
                                    if (pageDatum == ">>") {
                                      var idx = selectedPage + 1;
                                      getPage(ref, (idx - 2) * 18 + 17);
                                    } else if (pageDatum == "1") {
                                      getPage(ref, -1); // (p - 2) * 18 + 17
                                    } else if (pageDatum != "...") {
                                      var idx = int.parse(pageData[index]);
                                      getPage(ref, (idx - 2) * 18 + 17);
                                    } else if (pageDatum == "...") {
                                      showDialog(
                                        context: context,
                                        barrierColor:
                                            Colors.black26.withOpacity(.5),
                                        builder: (BuildContext context) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 10,
                                              sigmaY: 10,
                                            ),
                                            child: connectedDotsDialog(
                                              context,
                                              data.data.widowsCount.count ~/ 17,
                                              ref,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: boxDim,
                                    height: boxDim,
                                    decoration: boxDecoration,
                                    child: Center(
                                      child: Text(
                                        pageDatum,
                                        style: TextStyle(
                                          color: selectedPage.toString() ==
                                                  pageDatum
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
          },
          error: (error, _) => const SizedBox(),
          loading: () {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              AppNotifier.toolbarTitleVn.value = "Loading ...";
              AppNotifier.widowsPageShowShimmerVn.value = true;
            });
            return const SizedBox();
          },
        );
  }

  getPage(WidgetRef ref, int index) {
    ref.watch(homePageControllerProvider).getWidowData(input: index);
  }

  List<String> pageToPagination(int input, {int currentPage = 1}) {
    if (input == 0) {
      return [];
    } else if (input == 1) {
      return ["1"];
    } else if (input == 2) {
      return ["1", "2"];
    } else if (input == 3) {
      return ["1", "2", "3"];
    } else {
      if (currentPage == 1) {
        return [
          "$currentPage",
          "${currentPage + 1}",
          "${currentPage + 2}",
          "...",
          ">>",
        ];
      } else {
        return [
          "${currentPage - 1}",
          "$currentPage",
          "${currentPage + 1}",
          "...",
          ">>",
        ];
      }
    }
  }

  connectedDotsDialog(BuildContext context, int count, WidgetRef ref) {
    TextEditingController controller = TextEditingController(text: "0");
    String warningText = "";

    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Material(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Jump to page",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Text(
                              "From:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "1",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Text(
                              "To:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Text(
                          "Jump to:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: controller,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatefulBuilder(
                    builder: (_, void Function(void Function()) setState) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.amber),
                                  ),
                                  onPressed: () {
                                    var text = int.parse(controller.text);
                                    if (text.toString() == "0" ||
                                        text > count) {
                                      setState(() {
                                        warningText = "Invalid page number";
                                      });
                                      return;
                                    } else if (text.toString() == "1") {
                                      getPage(ref, (text - 2) * 18 + 17);
                                    } else {
                                      getPage(ref, (text - 2) * 18 + 17);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Jump",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          warningText != ""
                              ? Text(
                                  warningText,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
