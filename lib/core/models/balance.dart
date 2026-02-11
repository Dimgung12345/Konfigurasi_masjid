class Balance {
  final int opening;
  final int income;
  final int expense;
  final int closing;

  Balance({
    required this.opening,
    required this.income,
    required this.expense,
    required this.closing,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    print("RAW BALANCE JSON: $json");

    return Balance(
      opening: json['opening'] is int
          ? json['opening']
          : int.tryParse(json['opening']?.toString() ?? '') ?? 0,
      income: json['income'] is int
          ? json['income']
          : int.tryParse(json['income']?.toString() ?? '') ?? 0,
      expense: json['expense'] is int
          ? json['expense']
          : int.tryParse(json['expense']?.toString() ?? '') ?? 0,
      closing: json['closing'] is int
          ? json['closing']
          : int.tryParse(json['closing']?.toString() ?? '') ?? 0,
    );
  }
}