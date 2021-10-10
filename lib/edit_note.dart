import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class EditNote extends StatelessWidget {
  final docId;
  final lender, amount, day;
  const EditNote({Key? key, this.docId, this.lender, this.amount, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        centerTitle: true,
      ),
      body: EditNoteWindow(docID: docId, lender: lender, amount: amount, day: day,),
    );
  }
}

class EditNoteWindow extends StatefulWidget {
  final docID;
  final lender, amount, day;
  const EditNoteWindow({Key? key, this.docID, this.lender, this.amount, this.day}) : super(key: key);

  @override
  _EditNoteWindowState createState() => _EditNoteWindowState();
}

class _EditNoteWindowState extends State<EditNoteWindow> {
  String lender = '', amount = '', day = '';

  var note = FirebaseFirestore.instance.collection('notes');

  var user = FirebaseAuth.instance.currentUser;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  Future<void> printData() async {

  }

  Future<void> saveData() {
    var formData = formState.currentState;
    formData!.save();
    // Call the user's CollectionReference to add a new user
    return note.doc(widget.docID)
        .update({
      'lender': lender, // John Doe
      'amount': amount, // Stokes and Sons
      'day': day // 42
    })
        .then((value) => print("Note Edited"))
        .catchError((error) => print("Failed to edit note: $error"));
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
                    initialValue: widget.lender,
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
                    initialValue: widget.amount,
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
                    initialValue: widget.day,
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
