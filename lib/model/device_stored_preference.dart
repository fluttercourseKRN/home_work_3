class DeviceStoredPreference {
  final String autoSnapshotInterval;
  final bool isAutoSnapshotEnabled;

  const DeviceStoredPreference({
    required this.autoSnapshotInterval,
    required this.isAutoSnapshotEnabled,
  });

  Map<String, dynamic> toMap() {
    return {
      'autoSnapshotInterval': autoSnapshotInterval,
      'isAutoSnapshotEnabled': isAutoSnapshotEnabled,
    };
  }

  factory DeviceStoredPreference.fromMap(Map<String, dynamic> map) {
    return DeviceStoredPreference(
      autoSnapshotInterval: map['autoSnapshotInterval'] as String,
      isAutoSnapshotEnabled: map['isAutoSnapshotEnabled'] as bool,
    );
  }
}
