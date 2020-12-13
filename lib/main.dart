import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:tangerine/services/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String name = "";
  String dateToString = "";

  uploadEventData() {
    setState(() {
      _isLoading = true;
    });

    Map<String, String> eventMap = {
      "name": name,
      "date": dateToString,
    };

    databaseService
        .addEventData(eventMap, randomAlphaNumeric(10))
        .then((val) {})
        .catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong!");
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      width: 250,
                      child: TextFormField(
                        validator: (value) {
                          if (value.length == 0) {
                            return "Please enter name.";
                          }

                          if (value.length < 3) {
                            return "Name must be at least 3 characters long.";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepOrange, width: 2.0),
                          ),
                        ),
                        onChanged: (val) {
                          name = val;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2020, 1, 1),
                            maxTime: DateTime(2021, 12, 31), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          dateToString = date.toString();
                          dateToString = date.toString();
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'Add date',
                        style: TextStyle(color: Colors.deepOrange),
                      )),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                uploadEventData();
              },
              tooltip: 'Add event',
              child: Icon(Icons.check),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
    return futureBuilder;
  }
}
