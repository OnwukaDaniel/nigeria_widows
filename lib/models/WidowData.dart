class WidowData {
  Date? date;
  List<Data> data = [];
  int? lastIndex;
  String? message;
  String? status;
  int? statusCode;

  WidowData(
      {this.date,
      this.data =  const [],
      this.lastIndex,
      this.message,
      this.status,
      this.statusCode});

  WidowData.fromJson(Map<String, dynamic> json) {
    try{
      date = json['date'] != null ? Date.fromJson(json['date']) : null;
    } catch (e){
      date = Date.fromJson({"_seconds": 1685806428, "_nanoseconds": 76000000});
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    lastIndex = json['lastIndex'];
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (date != null) {
      data['date'] = date!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['lastIndex'] = lastIndex;
    data['message'] = message;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class Date {
  int? iSeconds;
  int? iNanoseconds;

  Date({this.iSeconds, this.iNanoseconds});

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
  String? occupation;
  String? categoryBasedOnNeeds;
  String? accountName;
  String? lga;
  String? bankName;
  String? employmentStatus;
  int? yearOfMarriage;
  String? ngoMembership;
  String? homeTown;
  dynamic oneOrTwo;
  String? registrationDate;
  String? id;
  String? state;
  String? husbandBereavementDate;
  dynamic receivedBy;
  String? address;
  String? husbandName;
  String? fullName;
  String? husbandOccupation;
  String? accountNumber;
  String? ngoName;
  String? phoneNumber;
  int? numberOfChildren;
  String? senatorialZone;
  String? dob;

  Data(
      {this.occupation,
      this.categoryBasedOnNeeds,
      this.accountName,
      this.lga,
      this.bankName,
      this.employmentStatus,
      this.yearOfMarriage,
      this.ngoMembership,
      this.homeTown,
      this.oneOrTwo,
      this.registrationDate,
      this.id,
      this.state,
      this.husbandBereavementDate,
      this.receivedBy,
      this.address,
      this.husbandName,
      this.fullName,
      this.husbandOccupation,
      this.accountNumber,
      this.ngoName,
      this.phoneNumber,
      this.numberOfChildren,
      this.senatorialZone,
      this.dob});

  Data.fromJson(Map<String, dynamic> json) {
    occupation = json['occupation'];
    categoryBasedOnNeeds = json['categoryBasedOnNeeds'];
    accountName = json['accountName'];
    lga = json['lga'];
    bankName = json['bankName'];
    employmentStatus = json['employmentStatus'];
    yearOfMarriage = json['yearOfMarriage'];
    ngoMembership = json['ngoMembership'];
    homeTown = json['homeTown'];
    oneOrTwo = json['oneOrTwo'];
    registrationDate = json['registrationDate'];
    id = json['id'];
    state = json['state'];
    husbandBereavementDate = json['husbandBereavementDate'];
    receivedBy = json['receivedBy'];
    address = json['address'];
    husbandName = json['husbandName'];
    fullName = json['fullName'];
    husbandOccupation = json['husbandOccupation'];
    accountNumber = json['accountNumber'];
    ngoName = json['ngoName'];
    phoneNumber = json['phoneNumber'];
    numberOfChildren = json['numberOfChildren'];
    senatorialZone = json['senatorialZone'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupation'] = occupation;
    data['categoryBasedOnNeeds'] = categoryBasedOnNeeds;
    data['accountName'] = accountName;
    data['lga'] = lga;
    data['bankName'] = bankName;
    data['employmentStatus'] = employmentStatus;
    data['yearOfMarriage'] = yearOfMarriage;
    data['ngoMembership'] = ngoMembership;
    data['homeTown'] = homeTown;
    data['oneOrTwo'] = oneOrTwo;
    data['registrationDate'] = registrationDate;
    data['id'] = id;
    data['state'] = state;
    data['husbandBereavementDate'] = husbandBereavementDate;
    data['receivedBy'] = receivedBy;
    data['address'] = address;
    data['husbandName'] = husbandName;
    data['fullName'] = fullName;
    data['husbandOccupation'] = husbandOccupation;
    data['accountNumber'] = accountNumber;
    data['ngoName'] = ngoName;
    data['phoneNumber'] = phoneNumber;
    data['numberOfChildren'] = numberOfChildren;
    data['senatorialZone'] = senatorialZone;
    data['dob'] = dob;
    return data;
  }
}
