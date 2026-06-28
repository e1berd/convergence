class SyncEndpoint {
  const SyncEndpoint({required this.baseUrl, required this.apiKey});

  final String baseUrl;
  final String apiKey;
}

class SystemStatus {
  const SystemStatus({
    required this.myId,
    required this.uptime,
    required this.cpuPercent,
  });

  final String myId;
  final Duration uptime;
  final double cpuPercent;

  factory SystemStatus.fromJson(Map<String, dynamic> j) => SystemStatus(
    myId: j['myID'] as String? ?? '',
    uptime: Duration(seconds: (j['uptime'] as num? ?? 0).round()),
    cpuPercent: (j['cpuPercent'] as num? ?? 0).toDouble(),
  );
}

class SystemVersion {
  const SystemVersion({
    required this.version,
    required this.os,
    required this.arch,
  });

  final String version;
  final String os;
  final String arch;

  factory SystemVersion.fromJson(Map<String, dynamic> j) => SystemVersion(
    version: j['version'] as String? ?? '',
    os: j['os'] as String? ?? '',
    arch: j['arch'] as String? ?? '',
  );
}

class ConnectionTotals {
  const ConnectionTotals({required this.inBytes, required this.outBytes});

  final int inBytes;
  final int outBytes;

  factory ConnectionTotals.fromJson(Map<String, dynamic> j) => ConnectionTotals(
    inBytes: (j['inBytesTotal'] as num? ?? 0).toInt(),
    outBytes: (j['outBytesTotal'] as num? ?? 0).toInt(),
  );
}

class DeviceConnection {
  const DeviceConnection({
    required this.connected,
    required this.paused,
    required this.address,
    required this.inBytes,
    required this.outBytes,
  });

  final bool connected;
  final bool paused;
  final String address;
  final int inBytes;
  final int outBytes;

  factory DeviceConnection.fromJson(Map<String, dynamic> j) => DeviceConnection(
    connected: j['connected'] as bool? ?? false,
    paused: j['paused'] as bool? ?? false,
    address: j['address'] as String? ?? '',
    inBytes: (j['inBytesTotal'] as num? ?? 0).toInt(),
    outBytes: (j['outBytesTotal'] as num? ?? 0).toInt(),
  );
}

class Connections {
  const Connections({required this.totals, required this.devices});

  final ConnectionTotals totals;
  final Map<String, DeviceConnection> devices;

  factory Connections.fromJson(Map<String, dynamic> j) {
    final raw = (j['connections'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Connections(
      totals: ConnectionTotals.fromJson(
        (j['total'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      devices: raw.map(
        (k, v) => MapEntry(
          k,
          DeviceConnection.fromJson((v as Map).cast<String, dynamic>()),
        ),
      ),
    );
  }
}

class FolderDeviceRef {
  const FolderDeviceRef({required this.deviceId});

  final String deviceId;

  factory FolderDeviceRef.fromJson(Map<String, dynamic> j) =>
      FolderDeviceRef(deviceId: j['deviceID'] as String? ?? '');

  Map<String, dynamic> toJson() => {'deviceID': deviceId};
}

class FolderConfig {
  const FolderConfig({
    required this.id,
    required this.label,
    required this.path,
    required this.type,
    required this.devices,
    required this.rescanIntervalS,
    required this.paused,
  });

  final String id;
  final String label;
  final String path;
  final String type;
  final List<FolderDeviceRef> devices;
  final int rescanIntervalS;
  final bool paused;

  String get displayName => label.isEmpty ? id : label;

  factory FolderConfig.fromJson(Map<String, dynamic> j) => FolderConfig(
    id: j['id'] as String? ?? '',
    label: j['label'] as String? ?? '',
    path: j['path'] as String? ?? '',
    type: j['type'] as String? ?? 'sendreceive',
    devices:
        (j['devices'] as List?)
            ?.map((d) => FolderDeviceRef.fromJson((d as Map).cast()))
            .toList() ??
        const [],
    rescanIntervalS: (j['rescanIntervalS'] as num? ?? 3600).toInt(),
    paused: j['paused'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'path': path,
    'type': type,
    'devices': devices.map((d) => d.toJson()).toList(),
    'rescanIntervalS': rescanIntervalS,
    'paused': paused,
  };

  FolderConfig copyWith({
    String? label,
    String? type,
    List<FolderDeviceRef>? devices,
    int? rescanIntervalS,
    bool? paused,
  }) => FolderConfig(
    id: id,
    label: label ?? this.label,
    path: path,
    type: type ?? this.type,
    devices: devices ?? this.devices,
    rescanIntervalS: rescanIntervalS ?? this.rescanIntervalS,
    paused: paused ?? this.paused,
  );
}

class DeviceConfig {
  const DeviceConfig({
    required this.deviceId,
    required this.name,
    required this.addresses,
    required this.paused,
    required this.introducer,
    required this.autoAcceptFolders,
  });

  final String deviceId;
  final String name;
  final List<String> addresses;
  final bool paused;
  final bool introducer;
  final bool autoAcceptFolders;

  String get displayName => name.isEmpty ? shortId : name;
  String get shortId =>
      deviceId.length >= 7 ? deviceId.substring(0, 7) : deviceId;

  factory DeviceConfig.fromJson(Map<String, dynamic> j) => DeviceConfig(
    deviceId: j['deviceID'] as String? ?? '',
    name: j['name'] as String? ?? '',
    addresses:
        (j['addresses'] as List?)?.map((e) => e.toString()).toList() ??
        const ['dynamic'],
    paused: j['paused'] as bool? ?? false,
    introducer: j['introducer'] as bool? ?? false,
    autoAcceptFolders: j['autoAcceptFolders'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'deviceID': deviceId,
    'name': name,
    'addresses': addresses,
    'paused': paused,
    'introducer': introducer,
    'autoAcceptFolders': autoAcceptFolders,
  };
}

class FolderStatus {
  const FolderStatus({
    required this.state,
    required this.globalBytes,
    required this.localBytes,
    required this.needBytes,
    required this.needTotalItems,
    required this.globalFiles,
    required this.localFiles,
  });

  final String state;
  final int globalBytes;
  final int localBytes;
  final int needBytes;
  final int needTotalItems;
  final int globalFiles;
  final int localFiles;

  double get completion =>
      globalBytes <= 0 ? 1 : (globalBytes - needBytes) / globalBytes;

  factory FolderStatus.fromJson(Map<String, dynamic> j) => FolderStatus(
    state: j['state'] as String? ?? 'unknown',
    globalBytes: (j['globalBytes'] as num? ?? 0).toInt(),
    localBytes: (j['localBytes'] as num? ?? 0).toInt(),
    needBytes: (j['needBytes'] as num? ?? 0).toInt(),
    needTotalItems: (j['needTotalItems'] as num? ?? 0).toInt(),
    globalFiles: (j['globalFiles'] as num? ?? 0).toInt(),
    localFiles: (j['localFiles'] as num? ?? 0).toInt(),
  );
}

class PendingDevice {
  const PendingDevice({required this.deviceId, required this.name});

  final String deviceId;
  final String name;

  String get shortId =>
      deviceId.length >= 7 ? deviceId.substring(0, 7) : deviceId;
}

class PendingFolder {
  const PendingFolder({
    required this.folderId,
    required this.label,
    required this.offeredBy,
  });

  final String folderId;
  final String label;
  final String offeredBy;
}
