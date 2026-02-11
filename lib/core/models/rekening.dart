class FinanceCard {
  final int id;
  final String clientId;
  final String cardName;
  final String status;
  final DateTime createdAt;
  final int currentBalance; // saldo aktif

  FinanceCard({
    required this.id,
    required this.clientId,
    required this.cardName,
    required this.status,
    required this.createdAt,
    required this.currentBalance,
  });

  factory FinanceCard.fromJson(Map<String, dynamic> json) {
    return FinanceCard(
      id: json['id'],
      clientId: json['client_id'],
      cardName: json['card_name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      currentBalance: json['current_balance'] ?? 0, // default 0 kalau null
    );
  }
}