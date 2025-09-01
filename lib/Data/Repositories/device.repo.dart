import '../../core/Providers/FB Firestore/fbfirestore_repo.dart';
import '../Model/Device/device.model.dart';

class DevicesRepo extends FirestoreRepo<Device> {
  DevicesRepo() : super('Devices');

  @override
  Device? toModel(Map<String, dynamic>? item) => Device.fromMap(item ?? {});

  @override
  Map<String, dynamic>? fromModel(Device? item) => item?.toMap() ?? {};
}
