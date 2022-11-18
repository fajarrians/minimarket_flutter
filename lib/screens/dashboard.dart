import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:minimarket/network/api.dart';
import 'package:minimarket/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  var company_id;
  var dataArrayMonthly = [];
  var dataArrayWeekly = [];
  var dataArrayItems = [];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    super.initState();
    _loadDataUser();
  }

  _loadDataUser() async {
    final localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('data')!);
    setState(() {
      company_id = user['company_id'];
    });
    _loadDataApi();
  }

  @override
  Widget build(BuildContext context) {
    List<ChartMonthly> chartDataMonthly = <ChartMonthly>[];
    for (var i = 0; i < dataArrayMonthly.length; i++) {
      chartDataMonthly.add(ChartMonthly(dataArrayMonthly[i]['month'],
          dataArrayMonthly[i]['total_transaction']));
    }

    List<ChartWeekly> chartDataWeekly = <ChartWeekly>[];
    for (var i = 0; i < dataArrayWeekly.length; i++) {
      chartDataWeekly.add(ChartWeekly(
          dataArrayWeekly[i]['day'], dataArrayWeekly[i]['total_transaction']));
    }

    List<ChartItems> chartDataItems = <ChartItems>[];
    for (var i = 0; i < dataArrayItems.length; i++) {
      chartDataItems.add(ChartItems(
          dataArrayItems[i]['item_name'], dataArrayItems[i]['subtotal_item']));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Beranda',
          style: TextStyle(
              color: ColorPalette().black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorPalette().white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorPalette().white,
                  boxShadow: [
                    const BoxShadow(
                      color: Color.fromARGB(38, 0, 0, 0),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text(
                      'Grafik Barang Laku',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Container(
                      child: SfCircularChart(
                        legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          position: LegendPosition.bottom,
                        ),
                        tooltipBehavior: _tooltipBehavior,
                        series: <CircularSeries<ChartItems, String>>[
                          PieSeries<ChartItems, String>(
                            dataSource: chartDataItems,
                            xValueMapper: (ChartItems sales, _) =>
                                sales.item_name,
                            yValueMapper: (ChartItems sales, _) => sales.total,
                            enableTooltip: true,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorPalette().white,
                  boxShadow: [
                    const BoxShadow(
                      color: Color.fromARGB(38, 0, 0, 0),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    const Text(
                      'Grafik Penjualan Bulanan',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Container(
                      child: SfCartesianChart(
                        zoomPanBehavior: _zoomPanBehavior,
                        primaryXAxis: CategoryAxis(),
                        series: <ColumnSeries<ChartMonthly, String>>[
                          ColumnSeries<ChartMonthly, String>(
                            color: ColorPalette().green,
                            dataSource: chartDataMonthly,
                            xValueMapper: (ChartMonthly sales, _) =>
                                sales.month,
                            yValueMapper: (ChartMonthly sales, _) =>
                                sales.total,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorPalette().white,
                  boxShadow: [
                    const BoxShadow(
                      color: Color.fromARGB(38, 0, 0, 0),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: [
                    const Text(
                      'Grafik Penjualan Mingguan',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Container(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ColumnSeries<ChartWeekly, String>>[
                          ColumnSeries<ChartWeekly, String>(
                            color: ColorPalette().green,
                            dataSource: chartDataWeekly,
                            xValueMapper: (ChartWeekly sales, _) => sales.day,
                            yValueMapper: (ChartWeekly sales, _) => sales.total,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadDataApi() async {
    var data = {'company_id': company_id};

    var resDataMonthly =
        await Network().postData(data, '/chart-monthly-sales-transaction');
    var bodyDataMonthly = json.decode(resDataMonthly.body);

    var resDataWeekly =
        await Network().postData(data, '/chart-weekly-sales-transaction');
    var bodyDataWeekly = json.decode(resDataWeekly.body);

    var resDataItems = await Network().postData(data, '/chart-sales-items');
    var bodyDataItems = json.decode(resDataItems.body);

    setState(() {
      dataArrayMonthly = bodyDataMonthly;
      dataArrayWeekly = bodyDataWeekly;
      dataArrayItems = bodyDataItems;
    });
  }
}

class ChartMonthly {
  ChartMonthly(this.month, this.total);
  final String month;
  final int total;
}

class ChartWeekly {
  ChartWeekly(this.day, this.total);
  final String day;
  final int total;
}

class ChartItems {
  ChartItems(this.item_name, this.total);
  final String item_name;
  final int total;
}
