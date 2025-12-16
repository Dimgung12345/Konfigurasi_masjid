class HadistDTO {
  final int id;
  final String konten;
  final String? riwayat;
  final String? kitab;
  final bool enabled;

  HadistDTO({
    required this.id,
    required this.konten,
    this.riwayat,
    this.kitab,
    required this.enabled,
  });

  factory HadistDTO.fromJson(Map<String, dynamic> json) {
    return HadistDTO(
      id: json['id'] as int,
      konten: json['konten']?.toString() ?? '',
      riwayat: json['riwayat']?.toString(),
      kitab: json['kitab']?.toString(),
      enabled: json['enabled'] == true,
    );
  }
}