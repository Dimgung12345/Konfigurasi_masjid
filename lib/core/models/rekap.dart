class MonthlyBalance {
  final int id;
  final String clientId;
  final String month; // format YYYY-MM
  final int openingBalance;
  final int totalIncome;
  final int totalExpense;
  final int closingBalance;
  final DateTime? closedAt;
  final DateTime createdAt;

  MonthlyBalance({
    required this.id,
    required this.clientId,
    required this.month,
    required this.openingBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.closingBalance,
    this.closedAt,
    required this.createdAt,
  });

  factory MonthlyBalance.fromJson(Map<String, dynamic> json) {
    return MonthlyBalance(
      id: json['id'],
      clientId: json['client_id'],
      month: json['month'],
      openingBalance: json['opening_balance'],
      totalIncome: json['total_income'],
      totalExpense: json['total_expense'],
      closingBalance: json['closing_balance'],
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}