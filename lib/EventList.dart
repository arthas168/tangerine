import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tangerine/helpers/formatter.dart';
import 'package:tangerine/services/database.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {



  Stream eventStream;

  DatabaseService databaseService = new DatabaseService();

  Future<void> _showDeleteDialogue() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete all events'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete all events?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('BACK', style: TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('YES', style: TextStyle(color: Colors.red),),
              onPressed: () async {
                await databaseService.deleteEvents();
                Fluttertoast.showToast(
                    msg: "Events deleted!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    databaseService.getEvents().then((val) async {
      setState(() {
        eventStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Event List"),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
          elevation: 0,
          brightness: Brightness.light),
      body: Container(
        child: StreamBuilder(
          stream: eventStream,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return EventTile(
                        name: snapshot.data.documents[index].data()["name"],
                        date: snapshot.data.documents[index].data()["date"],
                      );
                    });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDeleteDialogue();
        },
        tooltip: 'Add event',
        child: Icon(Icons.delete_forever),
        backgroundColor: Colors.black87,
      ), // This
    );
  }
}

class EventTile extends StatelessWidget {
  final String name;
  final String date;

  EventTile({@required this.name, @required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
          elevation: 4,
          color: Colors.deepOrange,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  formatDateString(date),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )),
    );
  }
}
