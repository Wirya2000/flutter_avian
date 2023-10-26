class TotalHadiah {
  String jenis;
  String qty;
  String unit;

  TotalHadiah({
    required this.jenis,
    required this.qty,
    required this.unit,
  });

  factory TotalHadiah.fromJson(Map<String, dynamic> json) {
    return TotalHadiah(
      jenis: json['Jenis'],
      qty: json['Qty'],
      unit: json['Unit'],
    );
  }
  // int id;
  // String branchCode;
  // String name;
  // String description;
  // String value;

  // TotalHadiah({
  //   required this.id,
  //   required this.branchCode,
  //   required this.name,
  //   required this.description,
  //   required this.value,
  // });

  // factory TotalHadiah.fromJson(Map<String, dynamic> json) {
  //   return TotalHadiah(
  //     id: json['ID'],
  //     branchCode: json['BranchCode'],
  //     name: json['Name'],
  //     description: json['Description'],
  //     value: json['Value'],
  //   );
  // }
}

List<TotalHadiah> totalHadiahList = [];