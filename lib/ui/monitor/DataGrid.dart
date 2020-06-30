import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Data.dart';

class DataGrid extends StatelessWidget {
  DataGrid(this.chartItems);

  final Map<String, ChartItem> chartItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Placeholder(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
