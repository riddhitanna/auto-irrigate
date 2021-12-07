import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GraphHelper{

  static List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  static Widget moistureGraph(List data) {

    List<FlSpot> graphData = List.empty(growable: true);
    List timestamps = List.empty(growable: true);
    int index = 1;
    for(var obj in data){
      double y;

      try{
        y = double.parse(obj['moisture']);
      } catch (e) {
        y = 0.0;
      }

      String hr = obj['timestamp'].toString().split('T')[1].split(':')[0];
      String min = obj['timestamp'].toString().split('T')[1].split(':')[1];
      String sec = obj['timestamp'].toString().split('T')[1].split(':')[2];
      sec = sec.replaceAll('Z', '');
      String time = hr + ":" + min;
      timestamps.add(time);

      graphData.add(FlSpot(double.parse(index.toString()), y));
      index = index + 1;
    }

    var lineChartData =
    LineChartData(
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: "Moisture Data (%)",
          margin: 0,
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: "time",
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          if(value %10 == 0){
            return FlLine(
              color: Colors.grey,
              strokeWidth: 1,
            );
          }
          return FlLine(
            color: Colors.transparent,
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.transparent,
            strokeWidth: 0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: SideTitles(
          showTitles: false,
        ),
        rightTitles: SideTitles(
          showTitles: false,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          // rotateAngle: 45,
          getTextStyles: (context, value) =>
              const TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
          getTitles: (value) {
            if((value - 1) % 20 == 0){
              return timestamps[value.toInt()];
            }
            return '';
          },
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) =>
          const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          getTitles: (value) {
            if(value%10 != 0){
              return '';
            }
            return value.toInt().toString();
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Colors.lightBlue, width: 4.0),
          bottom: BorderSide(color: Colors.lightBlue, width: 4.0),
        )
      ),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: graphData,
          isCurved: false,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );

    return AspectRatio(
      aspectRatio: 1.8,
      child: Container(child: LineChart(lineChartData), margin: const EdgeInsets.only(right: 30.0, left: 10)),
    );
  }

  static Widget moistureGraphWeb(List data) {

    List<FlSpot> graphData = List.empty(growable: true);
    List timestamps = List.empty(growable: true);
    int index = 1;
    for(var obj in data){
      double y;

      try{
        y = double.parse(obj['moisture']);
      } catch (e) {
        y = 0.0;
      }

      String hr = obj['timestamp'].toString().split('T')[1].split(':')[0];
      String min = obj['timestamp'].toString().split('T')[1].split(':')[1];
      String sec = obj['timestamp'].toString().split('T')[1].split(':')[2];
      sec = sec.replaceAll('Z', '');
      String time = hr + ":" + min;
      timestamps.add(time);

      graphData.add(FlSpot(double.parse(index.toString()), y));
      index = index + 1;
    }

    var lineChartData =
    LineChartData(
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: "Moisture Data (%)",
          margin: 0,
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: "time",
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          if(value %10 == 0){
            return FlLine(
              color: Colors.grey,
              strokeWidth: 1,
            );
          }
          return FlLine(
            color: Colors.transparent,
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.transparent,
            strokeWidth: 0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: SideTitles(
          showTitles: false,
        ),
        rightTitles: SideTitles(
          showTitles: false,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          // rotateAngle: 45,
          getTextStyles: (context, value) =>
          const TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 12
          ),
          getTitles: (value) {
            if((value - 1) % 20 == 0){
              return timestamps[value.toInt()];
            }
            return '';
          },
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) =>
          const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          getTitles: (value) {
            if(value%10 != 0){
              return '';
            }
            return value.toInt().toString();
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.lightBlue, width: 4.0),
            bottom: BorderSide(color: Colors.lightBlue, width: 4.0),
          )
      ),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: graphData,
          isCurved: false,
          colors: gradientColors,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );

    return AspectRatio(
      aspectRatio: 1.8,
      child: LineChart(lineChartData)
    );
  }

}