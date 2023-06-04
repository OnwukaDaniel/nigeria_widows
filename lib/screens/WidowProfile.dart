import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nigerian_widows/util/app_color.dart';
import 'package:nigerian_widows/util/app_constants.dart';

import '../models/WidowData.dart';
import 'HeroImageDetailScreen.dart';

class WidowProfile extends StatefulWidget {
  static const String id = "WidowProfile";
  final Data data;
  final String image;

  const WidowProfile({Key? key, required this.data, required this.image})
      : super(key: key);

  @override
  State<WidowProfile> createState() => _WidowProfileState();
}

class _WidowProfileState extends State<WidowProfile> {
  ValueNotifier<int> selectedDataVn = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              elevation: 0,
              backgroundColor:
                  Theme.of(context).backgroundColor.withOpacity(.5),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${widget.data.fullName}'s Profile",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: kToolbarHeight + 22),
          ValueListenableBuilder(
            valueListenable: selectedDataVn,
            builder: (_, int selectedData, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectedDataVn.value = 0;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: selectedData == 0
                                  ? AppColor.appColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Personal",
                              style: TextStyle(
                                color: selectedData == 0
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            selectedDataVn.value = 1;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: selectedData == 1
                                  ? AppColor.appColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Bank Details",
                              style: TextStyle(
                                color: selectedData == 1
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: selectedDataVn,
            builder: (_, int value, Widget? child) {
              if (value == 0) {
                return Personal(data: widget.data, image: widget.image);
              } else {
                return BankScreen(data: widget.data);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Personal extends StatelessWidget {
  final Data data;
  final String image;

  const Personal({
    Key? key,
    required this.data,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HeroImageDetailScreen(image: image),
                ),
              );
            },
            child: Hero(
              tag: "profile image",
              child: CircleAvatar(
                foregroundImage: AssetImage(image),
                radius: 80,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        DetailItem(data1: "Name", data2: data.fullName!),
        DetailItem(data1: "Date of birth", data2: data.dob!),
        DetailItem(data1: "Address", data2: data.address!),
        DetailItem(data1: "Phone number", data2: data.phoneNumber!),
        DetailItem(data1: "Employment Status", data2: data.employmentStatus!),
        DetailItem(data1: "State", data2: data.state!),
        DetailItem(data1: "HomeTown", data2: data.homeTown!),
        DetailItem(data1: "Local Government", data2: data.lga!),
        Text(
          "Other Personal Details",
          style: TextStyle(
            fontSize: 18,
            color: AppColor.appColor,
          ),
        ),
        const SizedBox(height: 14),
        const Divider(),
        const SizedBox(height: 16),
        DetailItem(data1: "Husband's name", data2: data.husbandName!),
        DetailItem(
          data1: "Husband's Occupation",
          data2: data.husbandOccupation!,
        ),
        DetailItem(data1: "Year of Marriage", data2: data.husbandName!),
        DetailItem(
          data1: "Date of husband's death",
          data2: data.husbandBereavementDate!,
        ),
        DetailItem(
          data1: "Number of children",
          data2: data.numberOfChildren!.toString(),
        ),
        DetailItem(data1: "Senatorial District", data2: data.senatorialZone!),
        DetailItem(
          data1: "Category based on need",
          data2: data.categoryBasedOnNeeds!,
        ),
      ],
    );
  }
}

class BankScreen extends StatelessWidget {
  final Data data;

  const BankScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailItem(
            data1: AppConstants.ACCOUNT_NUMBER,
            data2: data.accountNumber ?? "Nil"),
        DetailItem(data1: "Bank Name", data2: data.bankName ?? "Nil"),
        DetailItem(data1: "NGO membership", data2: data.ngoMembership ?? "Nil"),
        DetailItem(data1: "NGO name", data2: data.ngoName ?? "No NGO"),
        DetailItem(data1: "Received By", data2: data.receivedBy ?? "Nil"),
        DetailItem(
            data1: "Registration Date", data2: data.registrationDate ?? "Nil"),
      ],
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data1,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(width: 14),
            if (data1 == AppConstants.ACCOUNT_NUMBER && data2 != "Nil")
              InkWell(
                onTap: () {
                  if (data2 != "Nil") {
                    copyToClipboard(data2);
                    showToast(context, 'Copied!');
                  }
                },
                child: const Icon(
                  Icons.copy,
                  color: Colors.grey,
                ),
              )
            else
              const SizedBox(),
            Flexible(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black26.withOpacity(.5),
                    builder: (BuildContext context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: connectedDotsDialog(context, data1, data2),
                      );
                    },
                  );
                },
                child: Text(
                  data2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(),
        const SizedBox(height: 14),
      ],
    );
  }

  connectedDotsDialog(BuildContext context, String data1, String data2) {
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
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data1,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            data2,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ),
                      ),
                      if (data1 == AppConstants.ACCOUNT_NUMBER && data2 != "Nil")
                        InkWell(
                          onTap: () {
                            if (data2 != "Nil") {
                              copyToClipboard(data2);
                            }
                          },
                          child: const Icon(
                            Icons.copy,
                            color: Colors.grey,
                          ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
