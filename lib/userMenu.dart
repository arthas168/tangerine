import 'package:flutter/material.dart';

import 'EventList.dart';

class UserMenuActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.menu,
        size: 26.0,
      ),
      onSelected: (value) => {print("value $value")},
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventList()));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Row(children: [
                Icon(Icons.list, color: Colors.grey),
                Padding(
                    padding: EdgeInsets.only(left: 34),
                    child: Text("View events"))
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
