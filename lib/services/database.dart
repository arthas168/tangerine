import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<Stream> getEvents() async {
    return FirebaseFirestore.instance.collection("Event").orderBy("date").snapshots();
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

  Future<void> deleteEvents() async {
    await FirebaseFirestore.instance.collection("Event").get().then((value) => {
          for (DocumentSnapshot ds in value.docs) {ds.reference.delete()}
        });
  }

  Future<void> deleteOneEvent(String id) async {
    await FirebaseFirestore.instance.collection("Event").doc(id).delete();
  }
}
