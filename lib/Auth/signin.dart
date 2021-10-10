import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home_page.dart';
import 'register.dart';

class SignInWindow extends StatelessWidget {
  const SignInWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignIn(),
    );
  }
}

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String myEmail = '', myPassword = '';

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  signIn() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myEmail,
          password: myPassword,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
            context: context,
            title: 'Error',
            body: Text('No user found for that email.'),
          )..show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            title: 'Error',
            body: Text('Wrong password provided for that user.'),
          )..show();
        }
      }
    } else {
      print('not valid !');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
          top: 40,
        ),
        child: Form(
          key: formState,
          child: ListView(
            children: [
              Image(
                image: AssetImage('images/note_logo.png'),
                width: 200,
                height: 200,
              ),
              Text(
                'LogIn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Signatra',
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 100,
                  right: 20,
                  left: 20,
                  bottom: 10,
                ),
                child: TextFormField(
                  onSaved: (val) {
                    myEmail = val!;
                  },
                  validator: (val) {
                    if (val!.length > 50) {
                      return 'email can\'t be larger than 50 characters';
                    }
                    if (val.length < 2) {
                      return 'email can\'t be less than 2 characters';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your email..',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  bottom: 10,
                ),
                child: TextFormField(
                  onSaved: (val) {
                    myPassword = val!;
                  },
                  validator: (val) {
                    if (val!.length > 50) {
                      return 'password can\'t be larger than 50 characters';
                    }
                    if (val.length < 4) {
                      return 'password can\'t be less than 4 characters';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your password..',
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('I don\'t have an account :'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterWindow(),
                        ),
                      );
                    },
                    child: Text(
                      'Click Here',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 80,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    var user = await signIn();

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                  child: Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
