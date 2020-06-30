import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Data.dart';

class DataCard extends StatelessWidget {
  DataCard({this.title, this.text = 'N/A', this.maxLines = 1});

  final String title;
  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: <Widget>[
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Center(
                  child: AutoSizeText(
                    text,
                    maxLines: maxLines,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class DataGrid extends StatelessWidget {
  DataGrid(this.chartItems);

  final Map<String, ChartItem> chartItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                DataCard(
                  title: "CPU Usage",
                  text: chartItems['CPU Usage'].getLatest(0).value.toBestString(),
                ),
                DataCard(
                  title: "Load",
                  text: chartItems['Load'].getLatest(0).value.toBestString() +
                      ' / ' +
                      chartItems['Load'].getLatest(1).value.toBestString() +
                      ' / ' +
                      chartItems['Load'].getLatest(2).value.toBestString(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                DataCard(
                  title: "CPU Frequency",
                  text: chartItems['CPU Frequency'].getLatest(0).value.toBestString(),
                ),
                DataCard(
                  title: "Temperature",
                  text: chartItems['Temperature'].getLatest(0).value.toBestString(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                DataCard(
                  title: "Memory",
                  text: chartItems['Memory'].getLatest(0).value.toBestString() +
                      ' / ' +
                      chartItems['Memory'].max.toBestString(),
                ),
                DataCard(
                  title: "Swap",
                  text: chartItems['Swap'].getLatest(0).value.toBestString() +
                      ' / ' +
                      chartItems['Swap'].max.toBestString(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                DataCard(
                  title: "Disk IO",
                  maxLines: 2,
                  text: chartItems['Disk IO'].getLatest(0).value.toBestString() +
                      ' R\n' +
                      chartItems['Disk IO'].getLatest(1).value.toBestString() +
                      ' W',
                ),
                DataCard(
                  title: "Disk Usage",
                  text: chartItems['Disk Usage'].getLatest(0).value.toBestString() +
                      ' / ' +
                      chartItems['Disk Usage'].max.toBestString(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                DataCard(
                  title: "Network",
                  maxLines: 2,
                  text: chartItems['Network'].getLatest(0).value.toBestString() +
                      ' ↑\n' +
                      chartItems['Network'].getLatest(1).value.toBestString() +
                      ' ↓',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
