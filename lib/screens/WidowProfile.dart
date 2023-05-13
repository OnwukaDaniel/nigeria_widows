import 'package:flutter/material.dart';
import 'package:nigerian_widows/models/WidowsData.dart';
import 'package:nigerian_widows/util/app_color.dart';

class WidowProfile extends StatefulWidget {
  static const String id = "WidowProfile";
  final WidowData data;

  const WidowProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<WidowProfile> createState() => _WidowProfileState();
}

class _WidowProfileState extends State<WidowProfile> {
  ValueNotifier<int> selectedDataVn = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Profile",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
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
                                    : Colors.black,
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
              if(value == 0){
                return Personal(data: widget.data);
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
  final WidowData data;
  const Personal({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            foregroundImage: AssetImage(data.image),
            radius: 80,
          ),
        ),
        const SizedBox(height: 16),
        DetailItem(data1: "Name", data2: data.name),
        DetailItem(data1: "Date of birth", data2: data.dob),
        DetailItem(data1: "Address", data2: data.address),
        DetailItem(data1: "Phone number", data2: data.phone),
        DetailItem(data1: "Employment Status", data2: data.empStatus),
        DetailItem(data1: "State", data2: data.state),
        DetailItem(data1: "HomeTown", data2: data.homeTown),
        DetailItem(data1: "Local Government", data2: data.localGovt),
        const SizedBox(height: 16),
        Text(
          "Other Personal Details",
          style: TextStyle(
            fontSize: 18,
            color: AppColor.appColor,
          ),
        ),
        const SizedBox(height: 32),
        DetailItem(data1: "Husband's name", data2: data.husbandName),
        DetailItem(
          data1: "Husband's Occupation",
          data2: data.husbandOccupation,
        ),
        DetailItem(data1: "Year of Marriage", data2: data.husbandName),
        DetailItem(
          data1: "Date of husband's death",
          data2: data.husbandDeathDate,
        ),
        DetailItem(
          data1: "Number of children",
          data2: data.numChild,
        ),
        DetailItem(data1: "Senatorial District", data2: data.senDist),
        DetailItem(
          data1: "Category based on need",
          data2: data.needCat,
        ),
      ],
    );
  }
}

class BankScreen extends StatelessWidget {
  final WidowData data;
  const BankScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailItem(data1: "Account Number", data2: data.accountNo),
        DetailItem(data1: "Bank Name", data2: data.bankName),
        DetailItem(data1: "NGO membership", data2: data.ngoMembership),
        DetailItem(data1: "NGO name", data2: data.ngoName),
        DetailItem(data1: "Received By", data2: data.receivedBy),
        DetailItem(data1: "Registration Date", data2: data.registrationDate),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const Spacer(),
            Flexible(
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
          ],
        ),
        const SizedBox(height: 14),
        const Divider(),
        const SizedBox(height: 14),
      ],
    );
  }
}