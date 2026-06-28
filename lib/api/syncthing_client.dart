import 'dart:convert';

import 'package:http/http.dart' as http;

import 'syncthing_models.dart';

class SyncthingException implements Exception {
  SyncthingException(this.message);
  final String message;
  @override
  String toString() => 'SyncthingException: $message';
}

class SyncthingClient {
  SyncthingClient({required this.endpoint, http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final SyncEndpoint endpoint;
  final http.Client _http;

  Map<String, String> get _headers => {
    'X-API-Key': endpoint.apiKey,
    'Content-Type': 'application/json',
  };

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = endpoint.baseUrl.endsWith('/')
        ? endpoint.baseUrl.substring(0, endpoint.baseUrl.length - 1)
        : endpoint.baseUrl;
    return Uri.parse('$base$path').replace(queryParameters: query);
  }

  Future<dynamic> _get(String path, [Map<String, String>? query]) async {
    final res = await _http.get(_uri(path, query), headers: _headers);
    return _decode(res);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
  }) async {
    final request = http.Request(method, _uri(path, query))
      ..headers.addAll(_headers);
    if (body != null) request.body = jsonEncode(body);
    final res = await http.Response.fromStream(await _http.send(request));
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    if (res.statusCode >= 400) {
      throw SyncthingException('${res.statusCode}: ${res.body}');
    }
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  Future<bool> ping() async {
    try {
      await _get('/rest/system/ping');
      return true;
    } on Object {
      return false;
    }
  }

  Future<SystemStatus> systemStatus() async => SystemStatus.fromJson(
    (await _get('/rest/system/status')) as Map<String, dynamic>,
  );

  Future<SystemVersion> systemVersion() async => SystemVersion.fromJson(
    (await _get('/rest/system/version')) as Map<String, dynamic>,
  );

  Future<Connections> connections() async => Connections.fromJson(
    (await _get('/rest/system/connections')) as Map<String, dynamic>,
  );

  Future<List<String>> systemLog() async {
    final data = await _get('/rest/system/log') as Map<String, dynamic>;
    final messages = (data['messages'] as List?) ?? const [];
    return messages
        .map((m) => (m as Map)['message']?.toString() ?? '')
        .toList();
  }

  Future<void> restart() => _send('POST', '/rest/system/restart');
  Future<void> shutdown() => _send('POST', '/rest/system/shutdown');

  Future<void> pauseDevice(String deviceId) =>
      _send('POST', '/rest/system/pause', query: {'device': deviceId});
  Future<void> resumeDevice(String deviceId) =>
      _send('POST', '/rest/system/resume', query: {'device': deviceId});

  Future<List<FolderConfig>> folders() async {
    final data = await _get('/rest/config/folders') as List;
    return data
        .map((f) => FolderConfig.fromJson((f as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> putFolder(FolderConfig folder) =>
      _send('PUT', '/rest/config/folders/${folder.id}', body: folder.toJson());

  Future<void> deleteFolder(String id) =>
      _send('DELETE', '/rest/config/folders/$id');

  Future<List<DeviceConfig>> devices() async {
    final data = await _get('/rest/config/devices') as List;
    return data
        .map((d) => DeviceConfig.fromJson((d as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> putDevice(DeviceConfig device) => _send(
    'PUT',
    '/rest/config/devices/${device.deviceId}',
    body: device.toJson(),
  );

  Future<void> deleteDevice(String id) =>
      _send('DELETE', '/rest/config/devices/$id');

  Future<Map<String, dynamic>> options() async =>
      (await _get('/rest/config/options') as Map).cast<String, dynamic>();

  Future<Map<String, dynamic>> gui() async =>
      (await _get('/rest/config/gui') as Map).cast<String, dynamic>();

  Future<void> putGui(Map<String, dynamic> gui) =>
      _send('PUT', '/rest/config/gui', body: gui);

  Future<void> putOptions(Map<String, dynamic> options) =>
      _send('PUT', '/rest/config/options', body: options);

  Future<FolderStatus> folderStatus(String folderId) async =>
      FolderStatus.fromJson(
        (await _get('/rest/db/status', {'folder': folderId}))
            as Map<String, dynamic>,
      );

  Future<double> completion({String? folderId, String? deviceId}) async {
    final data =
        await _get('/rest/db/completion', {
              'folder': ?folderId,
              'device': ?deviceId,
            })
            as Map<String, dynamic>;
    return (data['completion'] as num? ?? 0).toDouble();
  }

  Future<void> scan({String? folderId}) => _send(
    'POST',
    '/rest/db/scan',
    query: folderId == null ? null : {'folder': folderId},
  );

  Future<void> override(String folderId) =>
      _send('POST', '/rest/db/override', query: {'folder': folderId});

  Future<void> revert(String folderId) =>
      _send('POST', '/rest/db/revert', query: {'folder': folderId});

  Future<List<PendingDevice>> pendingDevices() async {
    final data =
        (await _get('/rest/cluster/pending/devices') as Map?)
            ?.cast<String, dynamic>() ??
        const {};
    return data.entries
        .map(
          (e) => PendingDevice(
            deviceId: e.key,
            name: (e.value as Map)['name']?.toString() ?? '',
          ),
        )
        .toList();
  }

  Future<void> dismissPendingDevice(String deviceId) => _send(
    'DELETE',
    '/rest/cluster/pending/devices',
    query: {'device': deviceId},
  );

  Future<List<PendingFolder>> pendingFolders() async {
    final data =
        (await _get('/rest/cluster/pending/folders') as Map?)
            ?.cast<String, dynamic>() ??
        const {};
    final result = <PendingFolder>[];
    for (final entry in data.entries) {
      final offeredBy =
          ((entry.value as Map)['offeredBy'] as Map?)
              ?.cast<String, dynamic>() ??
          const {};
      for (final by in offeredBy.entries) {
        result.add(
          PendingFolder(
            folderId: entry.key,
            label: (by.value as Map)['label']?.toString() ?? entry.key,
            offeredBy: by.key,
          ),
        );
      }
    }
    return result;
  }

  Future<void> dismissPendingFolder(String folderId, String deviceId) => _send(
    'DELETE',
    '/rest/cluster/pending/folders',
    query: {'folder': folderId, 'device': deviceId},
  );

  Future<String?> validateDeviceId(String id) async {
    try {
      final data =
          await _get('/rest/svc/deviceid', {'id': id}) as Map<String, dynamic>;
      return data['id'] as String?;
    } on Object {
      return null;
    }
  }

  Future<List<dynamic>> events({required int since, int limit = 100}) async {
    final data = await _get('/rest/events', {
      'since': '$since',
      'limit': '$limit',
      'timeout': '50',
    });
    return (data as List?) ?? const [];
  }

  void close() => _http.close();
}
