import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class AddNote extends StatelessWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        centerTitle: true,
      ),
      body: AddNoteWindow(),
    );
  }
}

class AddNoteWindow extends StatefulWidget {
  const AddNoteWindow({Key? key}) : super(key: key);

  @override
  _AddNoteWindowState createState() => _AddNoteWindowState();
}

class _AddNoteWindowState extends State<AddNoteWindow> {
  String lender = '', amount = '', day = '';

  var note = FirebaseFirestore.instance.collection('notes');

  var user = FirebaseAuth.instance.currentUser;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  Future<void> saveData() {
    var formData = formState.currentState;
    formData!.save();
    // Call the user's CollectionReference to add a new user
    return note
        .add({
          'lender': lender,
          'amount': amount,
          'day': day,
          'userID': user!.uid,
        })
        .then((value) => print("Note Added"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formState,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 40,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('The Lender : '),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    onSaved: (val) {
                      lender = val!;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter name of the lender..',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('The Amount : '),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    onSaved: (val) {
                      amount = val!;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter how much...',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 40,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('Delivery Day : '),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    onSaved: (val) {
                      day = val!;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter the delivery day...',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 40,
            ),
            child: ElevatedButton(
              onPressed: () {
                saveData();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
