class ClientHadist {
  final int id;
  final String clientId;
  final int hadistId;
  final bool disabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientHadist({
    required this.id,
    required this.clientId,
    required this.hadistId,
    required this.disabled,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ✅ Parsing dari BE (snake_case → camelCase)
  factory ClientHadist.fromJson(Map<String, dynamic> json) {
    if (json['hadist_id'] == null) {
      throw Exception("Invalid client_hadist: missing hadist_id");
    }
    return ClientHadist(
      id: (json['id'] ?? 0) as int,
      clientId: json['client_id']?.toString() ?? '',
      hadistId: json['hadist_id'] as int,
      disabled: json['disabled'] == true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// ✅ Kirim ke BE (camelCase → snake_case)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "client_id": clientId,
      "hadist_id": hadistId,
      "disabled": disabled,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  /// ✅ Update sebagian field dengan elegan
  ClientHadist copyWith({
    int? id,
    String? clientId,
    int? hadistId,
    bool? disabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientHadist(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      hadistId: hadistId ?? this.hadistId,
      disabled: disabled ?? this.disabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}