import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bci_device_sdk/bci_device_sdk.dart';
import 'package:bci_device_sdk_example/src/examples/oxyzen/oxyzen_device_controller.dart';

import 'eeg_chart.dart';

const ppgChartColors = [Colors.red, Colors.green, Colors.blue];

class PpgChartWidget extends StatelessWidget {
  const PpgChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OxyzenDeviceController>();
    return Obx(
      () => Column(
        children: [
          Text(
            'PPG: ${controller.ppgData.toString()}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          controller.ppgValues.isEmpty
              ? const Text('Empty Chart')
              : Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(context).primaryColor.withAlpha(0x15),
                  child: chart(controller.ppgValues),
                ),
        ],
      ),
    );
  }

  Widget chart(RxList<PpgRawModel> values) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
            ),
          ),
        ),
        borderData: FlBorderData(
          border: const Border(left: BorderSide(), bottom: BorderSide()),
        ),
        maxX: values.length.toDouble(),
        minX: 0,
        lineBarsData: [
          LineChartBarData(
            spots: toSpots(values, (model) => model.hr.toDouble()),
            color: Colors.blue,
            barWidth: 1,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: toSpots(values, (model) => model.spO2.toDouble()),
            color: Colors.red,
            barWidth: 1,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

List<FlSpot> toSpots(
    List<PpgRawModel> data, double Function(PpgRawModel) valueFn) {
  if (data.isEmpty) {
    return [FlSpot.zero];
  }

  final list = <FlSpot>[];
  for (var i = 0; i < data.length; i++) {
    list.add(FlSpot(i.toDouble(), valueFn(data[i])));
  }
  return list;
}
