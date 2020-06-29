import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataChartWidget extends StatelessWidget {
  DataChartWidget(this.chartItem);

  final ChartItem chartItem;

  @override
  Widget build(BuildContext context) {
    var height = 150.0;
    if (chartItem.lines.length > 1) height += 30;
    final String unit = chartItem.max?.getBestUnit() ?? chartItem.getMaxInView().value.getBestUnit();
    final now = DateTime.now().millisecondsSinceEpoch;
    final start = now - 60 * 1000;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
          child: Text(
            chartItem.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          height: height,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.seconds,
              interval: 5,
              rangePadding: ChartRangePadding.none,
              visibleMinimum: DateTime.fromMillisecondsSinceEpoch(start),
            ),
            primaryYAxis: NumericAxis(
              desiredIntervals: (chartItem.max != null && chartItem.min != null) ? 4 : null,
              maximum: chartItem.max?.scaleUse(unit),
              minimum: chartItem.min?.scaleUse(unit),
              labelFormat: '{value}$unit',
              numberFormat: NumberFormat("####.#"),
            ),
            legend: Legend(
              isVisible: chartItem.lines.length > 1,
              position: LegendPosition.bottom,
              iconHeight: 10,
              isResponsive: false,
              toggleSeriesVisibility: false,
              itemPadding: 10,
            ),
            series: chartItem.lines.map((Line line) {
              return LineSeries<ChartDataPoint, DateTime>(
                animationDuration: 0,
                dataSource: line.data,
                name: line.name,
                xValueMapper: (ChartDataPoint dataPoint, _) => DateTime.fromMillisecondsSinceEpoch(dataPoint.time),
                yValueMapper: (ChartDataPoint dataPoint, _) => dataPoint.value.scaleUse(unit),
                width: 2,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
