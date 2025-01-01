import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String, dynamic>> sleepLog = [];

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
      home: const LogPage(title: 'Log Sleep Hours'),
    );
  }
}

class LogPage extends StatefulWidget {
  const LogPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LogPage> createState() => _MyLogPageState();
}

class _MyLogPageState extends State<LogPage> {


  @override
  void initState() {
    super.initState();
    _loadLog();
  }


  String selectedDate = "No date selected";
  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        selectedDate = formattedDate;
        _dateController.text = formattedDate;
      });
    }
  }

  void _addLog(String hours, String date, String notes) async {
    try {
      CollectionReference sleepCollection = FirebaseFirestore.instance.collection("log");

      await sleepCollection.add({
        'hours': hours,
        'date': date,
        'notes': notes,
      });
      print("Sleep log added successfully");
    } catch (e) {
      print("Error adding log: $e");
    }
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

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _showPopup(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          title: const Text("Log your hours"),
          content: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Hours:", style: TextStyle(fontSize: 20),),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _hoursController,
                      decoration: InputDecoration(
                        hintText: "Hours",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Date:", style: TextStyle(fontSize: 20),),
                  GestureDetector(
                      onTap: () {
                        _pickDate(context);
                      },
                      child: Icon(Icons.calendar_today)
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Notes:", style: TextStyle(fontSize: 20),),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: "Notes",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              TextButton(
                  onPressed: () async {
                    String hours = _hoursController.text;
                    String date = _dateController.text;
                    String notes = _notesController.text;

                    if (hours.isEmpty || date.isEmpty || notes.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("All fields must be filled out.", style: TextStyle(color: Colors.red))),
                      );
                      return;
                    }

                    _addLog(_hoursController.text, _dateController.text, _notesController.text);
                    _loadLog();
                    _hoursController.clear();
                    _dateController.clear();
                    _notesController.clear();
                  },
                  child: Text("Save", style: TextStyle(fontSize: 20),))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close", style: TextStyle(fontSize: 20),),
            )
          ]
      );
    }
    );
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
      body: sleepLog.isEmpty
        ? const Center(child: Text("Please log your sleep.",
          style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400
      )))
        : ListView.builder(
          itemCount: sleepLog.length,
          itemBuilder: (context, index){
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${sleepLog[index]['hours'].toString()} hours" ?? "0 hours",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600
                            )),
                        Text(sleepLog[index]['date'].toString() ?? "Unknown date",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400
                            )),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(sleepLog[index]['notes'].toString(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPopup(context),
        tooltip: 'Log',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
