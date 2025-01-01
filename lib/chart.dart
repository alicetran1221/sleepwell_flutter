import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const ChartPage(title: 'Sleep Trend'),
    );
  }
}

class ChartPage extends StatefulWidget {
  const ChartPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  void _loadLog() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('log')
          .get();

      List<Map<String, dynamic>> logs = snapshot.docs
          .map((doc) => {
        'date': doc['date'],
        'hours': doc['hours'],
        'notes': doc['notes'], }).toList();

      setState(() {
        sleepLog = logs;
      });
    } catch (e) {
      print("error fetching sleep logs: $e");
    }
  }

  List<FlSpot> _getData(List<Map<String, dynamic>> sleepLog) {
    sleepLog.sort((a, b) {
      DateTime dateA = DateFormat("yyyy-MM-dd").parse(a['date']);
      DateTime dateB = DateFormat("yyyy-MM-dd").parse(b['date']);
      return dateB.compareTo(dateA); // Sort in descending order
    });

    List<Map<String, dynamic>> pastWeek = sleepLog.take(7).toList();
    List<FlSpot> chartData = [];

    for (int i = 0; i < pastWeek.length; i++) {
      //DateTime logDate = DateFormat("yyyy-MM-dd").parse(pastWeek[i]['date']);
      double hours = double.tryParse(pastWeek[i]['hours'].toString()) ?? 0.0;

      // Add a BarChartGroupData object for each log entry
      chartData.add(FlSpot(i.toDouble(), hours));
    }

    print(chartData[1]);

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Line Chart',
              style: TextStyle(fontSize: 30), // Sets font size to 20 logical pixels
            ),
            SizedBox(height: 10),
            Text('Sleep trend for the past 7 days.', style: TextStyle(fontSize: 15),),
            SizedBox(height: 40),
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,  // Border color
                  width: 2,  // Border width
                ),
                // Optional: rounded corners
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getData(sleepLog),
                      isCurved: true,
                      barWidth: 2,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
