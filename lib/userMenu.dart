import 'package:flutter/material.dart';

import 'EventList.dart';

class UserMenuActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Icon(Icons.list, color: Colors.white),
      onPressed: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventList()))
      },
    );
  }
}
