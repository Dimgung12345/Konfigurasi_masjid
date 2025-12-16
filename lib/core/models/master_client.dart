class MasterClient {
  final String id;
  final String name;
  final String location;
  final String timezone;
  final String configTitle;
  final String configBackground;
  final String configSoundAlert;
  final String? logo; // ✅ ganti dari configBanner → logo
  final String? runningText;
  final bool enableHadis;
  final bool enableHariBesar;
  final bool enableKalender;
  final DateTime createdAt;

  // ✅ tambahan field URL
  final String? logoUrl;
  final String? backgroundUrl;
  final String? soundUrl;


  MasterClient({
    required this.id,
    required this.name,
    required this.location,
    required this.timezone,
    required this.configTitle,
    required this.configBackground,
    required this.configSoundAlert,
    this.logo,
    this.runningText,
    required this.enableHadis,
    required this.enableHariBesar,
    required this.enableKalender,
    required this.createdAt,

    // ✅ tambahan field URL
    this.logoUrl,
    this.backgroundUrl,
    this.soundUrl,
  });

  /// ✅ Parsing dari BE (snake_case → camelCase)
  factory MasterClient.fromJson(Map<String, dynamic> json) {
    return MasterClient(
      id: json["id"],
      name: json["name"],
      location: json["location"],
      timezone: json["timezone"],
      configTitle: json["config_title"],
      configBackground: json["config_background"],
      configSoundAlert: json["config_sound_alert"],
      logo: json["logo"], // ✅ mapping baru
      runningText: json["running_text"],
      enableHadis: json["enable_hadis"],
      enableHariBesar: json["enable_hari_besar"],
      enableKalender: json["enable_kalender"],
      createdAt: DateTime.parse(json["created_at"]),

      // ✅ mapping URL baru
      logoUrl: json["logo_url"],
      backgroundUrl: json["background_url"], 
      soundUrl: json["sound_url"],
    );
  }

  /// ✅ Kirim ke BE (camelCase → snake_case)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "location": location,
      "timezone": timezone,
      "config_title": configTitle,
      "config_background": configBackground,
      "config_sound_alert": configSoundAlert,
      "logo": logo, // ✅ kirim logo
      "running_text": runningText,
      "enable_hadis": enableHadis,
      "enable_hari_besar": enableHariBesar,
      "enable_kalender": enableKalender,
    };
  }

  /// ✅ Update sebagian field dengan elegan
  MasterClient copyWith({
    String? name,
    String? location,
    String? timezone,
    String? configTitle,
    String? configBackground,
    String? configSoundAlert,
    String? logo, // ✅ ganti dari configBanner → logo
    String? runningText,
    bool? enableHadis,
    bool? enableHariBesar,
    bool? enableKalender,
  }) {
    return MasterClient(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      timezone: timezone ?? this.timezone,
      configTitle: configTitle ?? this.configTitle,
      configBackground: configBackground ?? this.configBackground,
      configSoundAlert: configSoundAlert ?? this.configSoundAlert,
      logo: logo ?? this.logo,
      runningText: runningText ?? this.runningText,
      enableHadis: enableHadis ?? this.enableHadis,
      enableHariBesar: enableHariBesar ?? this.enableHariBesar,
      enableKalender: enableKalender ?? this.enableKalender,
      createdAt: createdAt,
    );
  }
}