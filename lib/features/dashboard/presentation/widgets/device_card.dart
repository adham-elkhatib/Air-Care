import 'package:flutter/material.dart';

import '../../../../Data/Model/Device/sensor_data.dart';
import '../../../../core/widgets/primary_button.dart';

class DeviceCard extends StatefulWidget {
  final SensorData sensorData;
  final void Function(SensorData updatedData)? onUpdate;

  const DeviceCard({super.key, required this.sensorData, this.onUpdate});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late TextEditingController _tempThresholdController;
  late TextEditingController _smokeThresholdController;
  late TextEditingController _humidityThresholdController;

  @override
  void initState() {
    super.initState();
    _tempThresholdController = TextEditingController(
      text: widget.sensorData.temperatureThreshold?.toString() ?? '',
    );
    _smokeThresholdController = TextEditingController(
      text: widget.sensorData.smokeLevelThreshold?.toString() ?? '',
    );
    _humidityThresholdController = TextEditingController(
      text: widget.sensorData.humidityThreshold?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _tempThresholdController.dispose();
    _smokeThresholdController.dispose();
    _humidityThresholdController.dispose();
    super.dispose();
  }

  void _updateThresholds() {
    final updatedData = SensorData(
      id: widget.sensorData.id,
      temperature: widget.sensorData.temperature,
      smokeLevel: widget.sensorData.smokeLevel,
      humidity: widget.sensorData.humidity,
      token: widget.sensorData.token,
      temperatureThreshold:
          double.tryParse(_tempThresholdController.text) ??
          widget.sensorData.temperatureThreshold,
      smokeLevelThreshold:
          double.tryParse(_smokeThresholdController.text) ??
          widget.sensorData.smokeLevelThreshold,
      humidityThreshold:
          double.tryParse(_humidityThresholdController.text) ??
          widget.sensorData.humidityThreshold,
    );

    widget.onUpdate?.call(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Device ID
          Text(
            "Device ID: ${widget.sensorData.id}",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          /// Sensor Readings
          Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _buildInfo(
                label: "Temperature",
                value: "${widget.sensorData.temperature ?? '-'} °C",
                color: widget.sensorData.temperatureColor,
              ),
              _buildInfo(
                label: "Smoke Level",
                value: "${widget.sensorData.smokeLevel ?? '-'} %",
                color: widget.sensorData.smokeLevelColor,
              ),
              _buildInfo(
                label: "Humidity",
                value: "${widget.sensorData.humidity ?? '-'} %",
                color: Colors.blueGrey,
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),

          /// Editable Thresholds
          const Text(
            "Threshold Settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildThresholdField(
                  label: "Temp Threshold",
                  controller: _tempThresholdController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildThresholdField(
                  label: "Smoke Threshold",
                  controller: _smokeThresholdController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildThresholdField(
            label: "Humidity Threshold",
            controller: _humidityThresholdController,
          ),

          const SizedBox(height: 24),

          /// Update Button
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              child: PrimaryButton(
                title: "Update",
                onPressed: _updateThresholds,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }

  Widget _buildThresholdField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter value',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}
