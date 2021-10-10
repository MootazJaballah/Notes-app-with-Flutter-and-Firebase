import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'signin.dart';

class RegisterWindow extends StatelessWidget {
  const RegisterWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Register(),
    );
  }
}

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String myUserName = '', myEmail = '', myPassword = '';

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  signUp() async {
    var formData = formState.currentState;

    if (formData!.validate()) {
      formData.save();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: myEmail,
          password: myPassword,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
            context: context,
            title: 'Error',
            body: Text('The password provided is too weak.'),
          )..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
            context: context,
            title: 'Error',
            body: Text('The account already exists for that email.'),
          )..show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('not valid!');
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
                'Register',
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
                    myUserName = val!;
                  },
                  validator: (val) {
                    if (val!.length > 50) {
                      return 'UserName can\'t be larger than 50 characters';
                    }
                    if (val.length < 2) {
                      return 'UserName can\'t be less than 2 characters';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'UserName..',
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
                    child: Text('I already have an account :'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInWindow(),
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
                    await signUp();
                    print('***************************');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInWindow(),
                      ),
                    );
                    print('***************************');
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
