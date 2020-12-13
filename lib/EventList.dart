import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tangerine/services/database.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Stream eventStream;

  DatabaseService databaseService = new DatabaseService();

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
                Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), ),
                SizedBox(
                  height: 8,
                ),
                Text(date.substring(5, date.length - 7), style: TextStyle(color: Colors.white),)
              ],
            ),
          )),
    );
  }
}
