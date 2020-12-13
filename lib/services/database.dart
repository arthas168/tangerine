import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  Future<Stream> getEvents() async {
    return FirebaseFirestore.instance.collection("Event").snapshots();
  }


  Future<void> addEventData(Map eventData, String eventId) async {
    await FirebaseFirestore.instance
        .collection("Event")
        .doc(eventId)
        .set(eventData)
        .catchError((e) {
      print(e.toString());
    });
  }
}
