import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'eeg_chart.dart';

final imuChartColors = [Colors.red, Colors.green, Colors.blue];
const imuChartTitles = ['x', 'y', 'z'];
const eulerChartTitles = ['yaw', 'pitch', 'roll'];

class IMUChartScreen extends StatelessWidget {
  final ChartType chartType;
  final RxnInt imuSeqNum;
  final RxList<double> valuesX;
  final RxList<double> valuesY;
  final RxList<double> valuesZ;

  const IMUChartScreen({
    Key? key,
    required this.chartType,
    required this.imuSeqNum,
    required this.valuesX,
    required this.valuesY,
    required this.valuesZ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$chartType'),
        ),
        body: IMUChartWidget(
          chartType: chartType,
          imuSeqNum: imuSeqNum,
          valuesX: valuesX,
          valuesY: valuesY,
          valuesZ: valuesZ,
        ));
  }
}

class IMUChartWidget extends StatelessWidget {
  final ChartType chartType;
  final RxnInt imuSeqNum;
  final RxList<double> valuesX;
  final RxList<double> valuesY;
  final RxList<double> valuesZ;
  const IMUChartWidget({
    Key? key,
    required this.chartType,
    required this.imuSeqNum,
    required this.valuesX,
    required this.valuesY,
    required this.valuesZ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: imuChartTitles
                .asMap()
                .map((i, e) => MapEntry(
                    i,
                    Text(
                      e,
                      style: TextStyle(
                        color: imuChartColors[i],
                      ),
                    )))
                .values
                .toList(),
          ),
          SizedBox(height: 5),
          Text(
            'IMU SeqNum=${imuSeqNum.value}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          valuesX.isEmpty
              ? const Text('Empty Chart')
              : Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(context).primaryColor.withAlpha(0x15),
                  child: lineChart(),
                ),
        ],
      );
    });
  }

  Widget lineChart() {
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
        maxX: valuesX.length.toDouble(),
        minX: 0,
        lineBarsData: [
          LineChartBarData(
            spots: toSpots(valuesX),
            color: imuChartColors[0],
            barWidth: 1,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: toSpots(valuesY),
            color: imuChartColors[1],
            barWidth: 1,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: toSpots(valuesZ),
            color: imuChartColors[2],
            barWidth: 1,
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
    list.add(FlSpot(i.toDouble(), data[i]));
  }
  return list;
}
