class Toko {
  String custID;
  String name;
  String address;
  String branchCode;
  String phoneNo;
  List hadiahs;
  int received;

  Toko({
    required this.custID,
    required this.name,
    required this.address,
    required this.branchCode,
    required this.phoneNo,
    required this.hadiahs,
    required this.received,
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
      custID: json['CustID'],
      name: json['Name'],
      address: json['Address'],
      branchCode: json['BranchCode'],
      phoneNo: json['PhoneNo'],
      hadiahs: json['hadiah'] as List,
      received: json['received'],
    );
  }
}

List<Toko> tokoList = [];