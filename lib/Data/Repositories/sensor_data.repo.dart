import '../../core/Providers/FB RTDB/fbrtdb_repo.dart';
import '../Model/Device/sensor_data.dart';

class SensorDataRepo extends RTDBRepo<SensorData> {
  SensorDataRepo() : super(path: "Devices", discardKey: true);

  @override
  SensorData? toModel(Object? data) {
    return SensorData.fromMap(
      (data as Map<Object?, Object?>?)?.map(
            (key, value) => MapEntry(key.toString(), value),
          ) ??
          {},
    );
  }

  @override
  Map<String, dynamic>? fromModel(SensorData? item) => item?.toMap() ?? {};
}
