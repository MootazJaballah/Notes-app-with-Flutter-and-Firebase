import 'package:fech_mousel/edit_note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Auth/signin.dart';
import 'add_note.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInWindow(),
                ),
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          );
        },
      ),
      body: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var noteRef = FirebaseFirestore.instance.collection('notes');
  bool isMein = false;
  var user = FirebaseAuth.instance.currentUser;

  getUser() {
    print(user!.email);
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: noteRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                if (snapshot.data!.docs[i]['userID'] == user!.uid) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        snapshot.data!.docs.removeAt(i);
                        noteRef.doc('${snapshot.data!.docs[i].id}').delete();
                      });
                    },
                    child: Card(
                      child: ListTile(
                        leading:
                            Text('Name : ${snapshot.data!.docs[i]['lender']}'),
                        title: Text(
                            'Amount : ${snapshot.data!.docs[i]['amount']}'),
                        subtitle:
                            Text('Date : ${snapshot.data!.docs[i]['day']}'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditNote(
                                  docId: snapshot.data!.docs[i].id,
                                  lender: snapshot.data!.docs[i]['lender'],
                                  amount: snapshot.data!.docs[i]['amount'],
                                  day: snapshot.data!.docs[i]['day'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
          if (snapshot.hasError) {
            return Text('Error !');
          }
          return Text('Loading...');
        },
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  const ListNotes({Key? key, this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              'images/1.png',
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            flex: 4,
            child: ListTile(
              title: Text('${notes['note']}'),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
