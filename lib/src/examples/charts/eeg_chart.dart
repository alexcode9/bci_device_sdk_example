import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../crimson/crimson_device_controller.dart';

enum ChartType { eeg, acc, gyro, euler, ppg }

class EEGChartWidget extends StatelessWidget {
  final bool showSeqNum;
  final RxnInt eegSeqNum;
  final RxList<double> eegValues;
  const EEGChartWidget(
      {Key? key,
      this.showSeqNum = true,
      required this.eegSeqNum,
      required this.eegValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          if (showSeqNum)
            Text(
              'EEG SeqNum=${eegSeqNum.value}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          SizedBox(height: 5),
          eegValues.isEmpty
              ? const Text('Empty Chart')
              : Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(context).primaryColor.withAlpha(0x15),
                  child: chart(eegValues),
                ),
        ],
      ),
    );
  }

  Widget chart(RxList<double> values) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 100,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: eegXRange / 5,
            ),
          ),
        ),
        borderData: FlBorderData(
          border: const Border(left: BorderSide(), bottom: BorderSide()),
        ),
        maxX: eegXRange.toDouble(),
        minX: 0,
        lineBarsData: [
          LineChartBarData(
            barWidth: 1,
            spots: toSpots(values),
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

List<FlSpot> toSpots(List<double> data) {
  if (data.isEmpty) {
    return [FlSpot.zero];
  }

  final list = <FlSpot>[];
  for (var i = 0; i < data.length; i++) {
    list.add(FlSpot(i.roundToDouble(), data[i].truncateToDouble()));
  }
  return list;
}
