class HomePageData {
  Date date = Date();
  Data data = Data(
    widowsCount: WidowsCount(),
    localGovData: LocalGovData(),
    employmentStatusData: LocalGovData(),
    occupationData: LocalGovData(),
    yearsInMarriageData: LocalGovData(),
    nGOAffiliation: LocalGovData(),
    childrenData: LocalGovData(),
  );
  String message = "";
  String status = "";
  int statusCode = 0;

  HomePageData(
      {required this.date,
      required this.data,
      required this.message,
      required this.status,
      required this.statusCode});

  HomePageData.fromJson(Map<String, dynamic> json) {
    date = Date.fromJson(json['date']);
    data = Data.fromJson(json['data']);
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> d = <String, dynamic>{};
    d['date'] = date.toJson();
    d['data'] = data.toJson();
    d['message'] = message;
    d['status'] = status;
    d['statusCode'] = statusCode;
    return d;
  }

  HomePageData.getDefault() {
    HomePageData(
      date: Date(),
      data: Data(
        widowsCount: WidowsCount(),
        localGovData: LocalGovData(),
        childrenData: LocalGovData(),
        nGOAffiliation: LocalGovData(),
        occupationData: LocalGovData(),
        yearsInMarriageData: LocalGovData(),
        employmentStatusData: LocalGovData(),
      ),
      message: message,
      status: status,
      statusCode: statusCode,
    );
  }
}

class Date {
  int iSeconds = 0;
  int iNanoseconds = 0;

  Date({this.iSeconds = 0, this.iNanoseconds = 0});

  Date.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_seconds'] = iSeconds;
    data['_nanoseconds'] = iNanoseconds;
    return data;
  }
}

class Data {
  WidowsCount widowsCount = WidowsCount();
  LocalGovData localGovData = LocalGovData();
  LocalGovData childrenData = LocalGovData();
  LocalGovData nGOAffiliation = LocalGovData();
  LocalGovData occupationData = LocalGovData();
  LocalGovData yearsInMarriageData = LocalGovData();
  LocalGovData employmentStatusData = LocalGovData();
  int lgaCount = 0;

  Data({
    required this.widowsCount,
    required this.localGovData,
    required this.childrenData,
    required this.nGOAffiliation,
    required this.occupationData,
    required this.yearsInMarriageData,
    required this.employmentStatusData,
    this.lgaCount = 0,
  });

  Data.fromJson(Map<String, dynamic> json) {
    widowsCount = json['widows_count'] == null
        ? WidowsCount()
        : WidowsCount.fromJson(json['widows_count']);
    localGovData = json['LocalGovData'] == null
        ? LocalGovData()
        : LocalGovData.fromJson(json['LocalGovData']);
    childrenData = json['ChildrenData'] == null
        ? LocalGovData()
        : LocalGovData.fromJson(json['ChildrenData']);
    nGOAffiliation = json['NGOAffiliation'] == null
        ? LocalGovData()
        : LocalGovData.fromJson(json['NGOAffiliation']);
    occupationData = json['OccupationData'] == null
        ? LocalGovData()
        : LocalGovData.fromJson(json['OccupationData']);
    yearsInMarriageData = json['YearsInMarriageData'] == null
        ? LocalGovData()
        : LocalGovData.fromJson(json['YearsInMarriageData']);
    employmentStatusData = json['EmploymentStatusData'] == null
        ? LocalGovData()
        : LocalGovData.fromJson(json['EmploymentStatusData']);
    lgaCount = json['lga_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['widows_count'] = widowsCount.toJson();
    data['LocalGovData'] = localGovData.toJson();
    data['ChildrenData'] = childrenData.toJson();
    data['NGOAffiliation'] = nGOAffiliation.toJson();
    data['OccupationData'] = occupationData.toJson();
    data['YearsInMarriageData'] = yearsInMarriageData.toJson();
    data['EmploymentStatusData'] = employmentStatusData.toJson();
    data['lga_count'] = lgaCount;
    return data;
  }
}

class WidowsCount {
  int count = 0;

  WidowsCount({this.count = 0});

  WidowsCount.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

class LocalGovData {
  List<BaseLocalGovtData> data = [];

  LocalGovData({this.data = const []});

  LocalGovData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BaseLocalGovtData>[];
      json['data'].forEach((v) {
        data.add(BaseLocalGovtData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class TitleValueOrderListData {
  List<TitleValueOrderData> data = [];

  TitleValueOrderListData({this.data = const []});

  TitleValueOrderListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TitleValueOrderData>[];
      json['data'].forEach((v) {
        data.add(TitleValueOrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class BaseLocalGovtData {
  String title = "";
  int value = 0;

  BaseLocalGovtData({this.title = "", this.value = 0});

  BaseLocalGovtData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}

class TitleValueOrderData {
  String title = "";
  int value = 0;
  int ordinal = 0;

  TitleValueOrderData({this.title = "", this.value = 0, this.ordinal = 0});

  TitleValueOrderData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
    ordinal = json['ordinal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['value'] = value;
    data['ordinal'] = ordinal;
    return data;
  }
}
