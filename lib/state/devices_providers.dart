import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/syncthing_models.dart';
import 'engine_providers.dart';
import 'system_providers.dart';

final devicesProvider = FutureProvider<List<DeviceConfig>>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return const [];
  return client.devices();
});

final localDeviceIdProvider = FutureProvider<String?>((ref) async {
  return (await ref.watch(systemStatusProvider.future))?.myId;
});

final pendingDevicesProvider = FutureProvider<List<PendingDevice>>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return const [];
  return client.pendingDevices();
});

final pendingFoldersProvider = FutureProvider<List<PendingFolder>>((ref) async {
  final client = ref.watch(clientProvider);
  ref.watch(refreshTickProvider);
  if (client == null) return const [];
  return client.pendingFolders();
});

final devicesControllerProvider = Provider(DevicesController.new);

class DevicesController {
  DevicesController(this._ref);

  final Ref _ref;

  Future<void> save(DeviceConfig device) async {
    await _ref.read(clientProvider)?.putDevice(device);
    _ref.invalidate(devicesProvider);
    _ref.invalidate(pendingDevicesProvider);
  }

  Future<void> remove(String deviceId) async {
    await _ref.read(clientProvider)?.deleteDevice(deviceId);
    _ref.invalidate(devicesProvider);
  }

  Future<void> setPaused(DeviceConfig device, bool paused) async {
    final client = _ref.read(clientProvider);
    if (client == null) return;
    paused
        ? await client.pauseDevice(device.deviceId)
        : await client.resumeDevice(device.deviceId);
    _ref.invalidate(connectionsProvider);
  }

  Future<void> dismissPendingDevice(String deviceId) async {
    await _ref.read(clientProvider)?.dismissPendingDevice(deviceId);
    _ref.invalidate(pendingDevicesProvider);
  }

  Future<String?> validate(String deviceId) =>
      _ref.read(clientProvider)?.validateDeviceId(deviceId) ??
      Future.value(null);
}
