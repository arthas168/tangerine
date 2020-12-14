import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:tangerine/helpers/my_flutter_app_icons.dart';
import 'package:tangerine/services/database.dart';
import 'package:tangerine/userMenu.dart';

import 'helpers/formatter.dart';

void main() {
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
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
  Future<void> _showNoDateError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No date chosen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please provide a date and time for the event.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialogue() async {

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Name: " + name),
                SizedBox(
                  height: 10,
                ),
                Text("Date: " + formatDateTimeString(dateToString))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'BACK',
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                uploadEventData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String dateToString = "";

  uploadEventData() async {
   

      Map<String, String> eventMap = {
        "name": name,
        "date": dateToString,
        "createdAt": DateTime.now().toString(),
        "referenceId": randomAlphaNumeric(10)
      };

      await databaseService
          .addEventData(eventMap, randomAlphaNumeric(10))
          .then((val) {
        print("RESET");
        Phoenix.rebirth(context);
        Fluttertoast.showToast(
            msg: "Event added!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }).catchError((e) {
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
              actions: [
                UserMenuActions(),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(MyFlutterApp.tangerine__1_, size: 42, color: Colors.deepOrange),
                  SizedBox(height: 15,),
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
                  SizedBox(height: 30),
                  Container(
                    child: Text("Date: " +
                        (dateToString == ""
                            ? "no date chosen"
                            : formatDateTimeString(dateToString))),
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2020, 1, 1),
                            maxTime: DateTime(2021, 12, 31), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          setState(() {
                            dateToString = date.toString();
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'Pick date and time',
                        style: TextStyle(color: Colors.deepOrange),
                      )),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                  if (dateToString == "") {
                    _showNoDateError();
                  return;
                  }

                   if (_formKey.currentState.validate()) {
                _showConfirmationDialogue();
                   }
              },
              tooltip: 'Add event',
              child: Icon(Icons.check),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
    return futureBuilder;
  }
}
