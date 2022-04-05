import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:graph_it_app/widgets/app_back_button.dart';

// ignore: must_be_immutable
class PolynomialChartScreen extends StatefulWidget {
  late int minX;
  late int maxX;
  late List coefficients;

  PolynomialChartScreen(List coefficients, int minX, int maxX) {
    this.minX = minX;
    this.maxX = maxX;
    this.coefficients = coefficients;
  }

  @override
  State<PolynomialChartScreen> createState() => _PolynomialChartScreenState();
}

class _PolynomialChartScreenState extends State<PolynomialChartScreen> {
  late List ylist = [];

  FlSpot solvePol(List coefficients, double x) {
    int length = coefficients.length;
    double y = 0;
    // double maxY = coefficients.elementAt(s) * pow(x, length + 4);
    for (int i = 0; i < length; i++) {
      y += coefficients.elementAt(i) * pow(x, length - 1 - i);
    }
    ylist.add(y);
    return FlSpot(x, y);
  }

  late double miny;

  late double maxy;

  void createList(double minX, double maxX, List coeffiecients) {
    for (double x = -minX; x <= maxX; x += 0.01) {
      double y = 0;
      for (int i = 0; i < coeffiecients.length; i++) {
        y += coeffiecients.elementAt(i) * pow(x, coeffiecients.length - 1 - i);
      }
      ylist.add(y);
    }
  }

  double maxY(List ylist) {
    double mY = -1.0 / 0.0;
    for (int i = 0; i < ylist.length; i++) {
      if (mY < ylist[i]) mY = ylist[i];
    }
    return mY + mY * 0.1;
  }

  double minY(List ylist) {
    double mY = ylist.first;
    for (int i = 0; i < ylist.length; i++) {
      if (mY > ylist[i]) mY = ylist[i];
    }
    return mY - mY * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polynomial Graph'),
        leading: ModalRoute.of(context)!.canPop ? AppBackButton() : null,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 22.0, bottom: 20),
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (dragUpdDet) {
                        setState(() {
                          double primDelta = dragUpdDet.primaryDelta ?? 0.0;
                          if (primDelta != 0) {
                            if (primDelta.isNegative) {
                              widget.minX += 2;
                              widget.maxX += 2;
                            } else {
                              widget.minX -= 2;
                              widget.maxX -= 2;
                            }
                            // ylist.removeRange(0, ylist.length);
                            // createList(widget.minX.toDouble(), widget.maxX.toDouble(), widget.coefficients);
                            miny = minY(ylist);
                            maxy = maxY(ylist);
                          }
                        });
                      },
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                                maxContentWidth: 100,
                                tooltipBgColor: Colors.lightBlue,
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots
                                      .map((LineBarSpot touchedSpot) {
                                    final textStyle = TextStyle(
                                      color: touchedSpot.bar.colors[0],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    );
                                    return LineTooltipItem(
                                        '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                                        textStyle);
                                  }).toList();
                                }),
                            handleBuiltInTouches: true,
                            getTouchLineStart: (data, index) => 0,
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              colors: [
                                Colors.black,
                              ],
                              spots: List.generate(
                                      (widget.maxX - widget.minX) * 10 + 1,
                                      (i) => (widget.minX * 10 + i) / 10)
                                  .map((x) => solvePol(widget.coefficients, x))
                                  .toList(),
                              isCurved: true,
                              isStrokeCapRound: true,
                              barWidth: 1,
                              belowBarData: BarAreaData(
                                show: false,
                              ),
                              dotData: FlDotData(show: false),
                            ),
                          ],
                          minY: minY(ylist).floor().toDouble(),
                          // maxY: 3,
                          maxY: maxY(ylist).ceil().toDouble(),
                          // maxY: solvePol.max,
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                              interval: ((maxY(ylist).ceil().toDouble() -
                                          minY(ylist).floor().toDouble()) /
                                      10)
                                  .ceil()
                                  .toDouble(),
                              showTitles: true,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                              margin: 16,
                            ),
                            rightTitles: SideTitles(showTitles: false),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                              margin: 16,
                            ),
                            topTitles: SideTitles(showTitles: false),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1.5,
                            verticalInterval: 5,
                            checkToShowHorizontalLine: (value) {
                              return value.toInt() == 0;
                            },
                            checkToShowVerticalLine: (value) {
                              return value.toInt() == 0;
                            },
                          ),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
