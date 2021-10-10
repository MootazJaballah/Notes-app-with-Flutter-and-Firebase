import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var userRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Mode'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: userRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text('name : ${snapshot.data!.docs[i]['name']}'),
                    subtitle:
                        Text('phone : ${snapshot.data!.docs[i]['phone']}'),
                  );
                });
          }
          if (snapshot.hasError) {
            return Text('Error..');
          }
          return Text('Loading..');
        },
      ),
    );
  }
}
