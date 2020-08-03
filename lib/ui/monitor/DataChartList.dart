import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/tools.dart';
import 'package:raspi_monitor_app/ui/monitor/DataChartWidget.dart';

class DataChartList extends StatelessWidget {
  DataChartList(this.chartItems);

  final Map<String, ChartItem> chartItems;

  @override
  Widget build(BuildContext context) {
    final chartItemList = chartItems.entries.toList();
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          top: (isLandScape(context) ? 0.0 : MediaQuery.of(context).padding.top) +
              4),
      itemCount: chartItemList.length,
      itemBuilder: (BuildContext context, i) {
        return DataChartWidget(chartItemList[i]);
      },
      separatorBuilder: (_, __) => Divider(),
    );
  }
}
