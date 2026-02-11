class FinancialTransaction {
  final int id;
  final String clientId;
  final int cardId;
  final DateTime date;
  final String type;
  final int amount;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FinancialTransaction({
    required this.id,
    required this.clientId,
    required this.cardId,
    required this.date,
    required this.type,
    required this.amount,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) {
    print("RAW JSON: $json");

    return FinancialTransaction(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      clientId: json['client_id']?.toString() ?? '',
      cardId: json['card_id'] is int ? json['card_id'] : int.tryParse(json['card_id'].toString()) ?? 0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      type: json['type']?.toString() ?? 'unknown',
      amount: json['amount'] is int ? json['amount'] : int.tryParse(json['amount'].toString()) ?? 0,
      description: json['description']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  bool get isIncome => type == "penerimaan";
}