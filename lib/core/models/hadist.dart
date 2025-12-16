class Hadist {
  final int id;
  final String konten;
  final String? riwayat;
  final String? kitab;
  final DateTime createdAt;

  Hadist({
    required this.id,
    required this.konten,
    this.riwayat,
    this.kitab,
    required this.createdAt,
  });

factory Hadist.fromJson(Map<String, dynamic> json) {
  final id = json['id'] ?? json['ID'];
  if (id == null) {
    throw Exception("Invalid hadist: missing id");
  }
  return Hadist(
    id: id as int,
    konten: (json['konten'] ?? json['Konten'])?.toString() ?? '',
    riwayat: (json['riwayat'] ?? json['Riwayat'])?.toString(),
    kitab: (json['kitab'] ?? json['Kitab'])?.toString(),
    createdAt: DateTime.tryParse(
      (json['created_at'] ?? json['CreatedAt'])?.toString() ?? ''
    ) ?? DateTime.now(),
  );
}
  
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "konten": konten,
      "riwayat": riwayat,
      "kitab": kitab,
      "created_at": createdAt.toIso8601String(),
    };
  }
}