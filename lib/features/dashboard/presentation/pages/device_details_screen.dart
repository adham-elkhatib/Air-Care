import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../Data/Model/Device/device.model.dart';
import '../../../../Data/Model/Device/sensor_data.dart';
import '../../../../Data/Repositories/sensor_data.repo.dart';
import '../../../../core/utils/SnackBar/snackbar.helper.dart';
import '../../../../core/widgets/section_placeholder.dart';
import '../widgets/device_card.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  SensorData? currentSensorData;
  List<SensorData> sensorData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialSensorData();
  }

  Future<void> _loadInitialSensorData() async {
    final newData = await SensorDataRepo().read(widget.device.barcode);
    if (newData != null) {
      currentSensorData = newData;
      sensorData.add(newData);
    }
    setState(() => isLoading = false);
  }

  Color getGradientColor(double level) {
    if (level < 200) return Colors.green;
    if (level < 500)
      return Color.lerp(Colors.green, Colors.orange, (level - 200) / 300)!;
    return Color.lerp(Colors.orange, Colors.red, (level - 500) / 500)!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 120,
        title: Column(
          children: [
            SizedBox(
              height: 60,
              child: Image.asset(
                "assets/images/Logo 01 black background.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.device.name),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.redAccent,
            ),
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  title: const Text("Confirm Deletion"),
                  content: const Text(
                    "Are you sure you want to delete this device?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
              if (confirmDelete == true) {
                Navigator.pop(context, {
                  'action': 'delete',
                  'device': widget.device,
                });
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F1114),
                    Color(0xFF1A1E23),
                    Color(0xFF2C2F3A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: StreamBuilder<SensorData?>(
                stream: SensorDataRepo().onUpdate().where(
                  (data) => data?.id == widget.device.barcode,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    currentSensorData = snapshot.data!;
                    sensorData.add(snapshot.data!);
                  }

                  if (currentSensorData == null) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: SectionPlaceholder(
                          title: "There is no current sensor data",
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Device Summary Card
                            DeviceCard(
                              sensorData: currentSensorData!,
                              onUpdate: (updatedData) async {
                                await SensorDataRepo().update(
                                  currentSensorData!.id,
                                  updatedData,
                                );
                                SnackbarHelper.showTemplated(
                                  context,
                                  title:
                                      "Device thresholds updated successfully!",
                                );
                              },
                            ),
                            const SizedBox(height: 24),

                            /// Charts Card
                            _buildChartCard(
                              title: "Temperature",
                              subtitle: "in Celsius (°C)",
                              max: 80,
                              series: SplineSeries<SensorData, int>(
                                dataSource: sensorData,
                                xValueMapper: (_, i) => i,
                                yValueMapper: (d, _) => d.temperature,
                                pointColorMapper: (d, _) =>
                                    getGradientColor(d.temperature ?? 0),
                                width: 4,
                                markerSettings: const MarkerSettings(
                                  isVisible: false,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildChartCard(
                              title: "Smoke Concentration",
                              subtitle: "ppm (parts per million)",
                              max: 1200,
                              series: SplineSeries<SensorData, int>(
                                dataSource: sensorData,
                                xValueMapper: (_, i) => i,
                                yValueMapper: (d, _) => d.smokeLevel,
                                pointColorMapper: (d, _) =>
                                    getGradientColor(d.smokeLevel ?? 0),
                                width: 4,
                                markerSettings: const MarkerSettings(
                                  isVisible: false,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildChartCard(
                              title: "Humidity",
                              subtitle: "%",
                              max: 100,
                              series: SplineSeries<SensorData, int>(
                                dataSource: sensorData,
                                xValueMapper: (_, i) => i,
                                yValueMapper: (d, _) => d.humidity,
                                pointColorMapper: (d, _) =>
                                    getGradientColor(d.humidity ?? 0),
                                width: 4,
                                markerSettings: const MarkerSettings(
                                  isVisible: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required double max,
    required CartesianSeries series,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          SfCartesianChart(
            backgroundColor: Colors.transparent,
            plotAreaBackgroundColor: Colors.transparent,
            primaryXAxis: const CategoryAxis(
              labelStyle: TextStyle(color: Colors.white70),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: max,
              labelStyle: const TextStyle(color: Colors.white70),
            ),
            series: [series],
          ),
        ],
      ),
    );
  }
}
