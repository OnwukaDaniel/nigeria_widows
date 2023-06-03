import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/HomePageController.dart';
import '../../future_providers/chart_future_provider.dart';
import '../../sharednotifiers/app.dart';
import '../../util/app_color.dart';

class WidowLandingBottomNavigation extends ConsumerWidget {
  const WidowLandingBottomNavigation({Key? key}) : super(key: key);
  final double bottomBarHeight = 60;

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
                        height: bottomBarHeight,
                        child: ValueListenableBuilder(
                          valueListenable: AppNotifier.selectedPageVn,
                          builder: (_, int selectedPage, __) {
                            var pageData = pageToPagination(
                              data.data.widowsCount.count ~/ 18,
                              currentPage: selectedPage,
                            );
                            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                              AppNotifier.toolbarTitleVn.value = "Widows Data";
                              AppNotifier.widowsPageShowShimmerVn.value = false;
                            });

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
                                      getPage(ref, selectedPage * 17);
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
    AppNotifier.toolbarTitleVn.value = "Loading ...";
    AppNotifier.widowsPageShowShimmerVn.value = true;
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
}
