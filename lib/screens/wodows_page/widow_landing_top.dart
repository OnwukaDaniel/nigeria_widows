import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/HomePageController.dart';
import '../../models/WidowData.dart';
import '../../sharednotifiers/app.dart';
import '../../util/CustomShimmer.dart';
import '../../util/app_color.dart';
import '../WidowProfile.dart';
import '../transistion/RightToLeft.dart';

class WidowLandingTop extends ConsumerWidget {
  const WidowLandingTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      children: [
        ValueListenableBuilder(
          valueListenable: AppNotifier.cacheWidowDataVn,
          builder: (BuildContext context, WidowData data, Widget? child) {
            var dataList = data.data;
            return ValueListenableBuilder(
              valueListenable: AppNotifier.widowsPageShowShimmerVn,
              builder: (_, bool isAnimating, Widget? child) {
                if (isAnimating == true) {
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      mainAxisExtent: 238,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const CustomShimmer(width: double.infinity, height: 120),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                CustomShimmer(width: 50, height: 10),
                                Spacer(),
                                CustomShimmer(width: 60, height: 10),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                CustomShimmer(width: 50, height: 10),
                                Spacer(),
                                CustomShimmer(width: 60, height: 10),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                CustomShimmer(width: 50, height: 10),
                                Spacer(),
                                CustomShimmer(width: 60, height: 10),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                CustomShimmer(width: 50, height: 10),
                                Spacer(),
                                CustomShimmer(width: 60, height: 10),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                CustomShimmer(width: 50, height: 10),
                                Spacer(),
                                CustomShimmer(width: 60, height: 10),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const CustomShimmer(width: 60, height: 10),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return child!;
                }
              },
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 238,
                ),
                itemBuilder: (BuildContext context, int index) {
                  double font = 9;
                  var data = dataList[index];

                  var img = "assets/widow_images/profile1.png";

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
                              RightToLeft(
                                page: WidowProfile(
                                  data: data,
                                  image: img,
                                ),
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
            );
          },
        ),
      ],
    );
  }

  getPage(WidgetRef ref, int index) {
    ref.watch(homePageControllerProvider).getWidowData(input: index);
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
