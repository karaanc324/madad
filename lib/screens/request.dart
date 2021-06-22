import 'package:flutter/material.dart';
import 'package:madad/service/firebase_service.dart';

class SendRequest extends StatelessWidget {
  TextEditingController requestTypeController = TextEditingController();
  TextEditingController noOfPeopleController = TextEditingController();
  TextEditingController ageGroupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        appBar: AppBar(
          title: Text("REQUEST"),
        ),
        // 1 Food, 2 No.of people, 3 Age group of people
        body: Column(
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: requestTypeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type of request',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: noOfPeopleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'No. of people',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: ageGroupController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age group of people',
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  await FirebaseService.getFirebaseService().sendNotification(
                      requestTypeController.text,
                      noOfPeopleController.text,
                      ageGroupController.text);
                  Navigator.pop(context);
                },
                child: Text('Send Request'))
          ],
        ),
      ),
    );
  }
}
