import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_screening/Setup/signIn.dart';
import 'package:health_screening/Setup/signUp.dart';
import 'package:flutter/material.dart';

import '../Pages/adminPage.dart';
import '../Pages/userPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  late String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController displayName = TextEditingController();
  late TextEditingController role = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Welcome to Puchong Health Screening Program"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8,8,8,8),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Center(
                        child: SizedBox(
                            width: 500,
                            height: 250,
                            child: Image.asset('images/HealthScreenings.jpg')),
                      ),
                    ),
                    Padding(
                      //padding: const EdgeInsets.only(left:300,right: 300.0,top:0,bottom: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        validator: (input) {
                          if(input!.isEmpty){
                            return 'Please enter your email ';}
                          return null;
                        },
                        onSaved: (input) => _email = input!,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter valid email id as abc@gmail.com'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        validator: (input) {
                          if(input!.isEmpty){
                            return  'Enter your password';
                          }else if(input!.length < 6) {
                            return  'Your password needs to be at least 6 characters';
                          }
                          return null;
                        },
                        onSaved: (input) => _password = input!,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter secure password'),
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        //TODO FORGOT PASSWORD SCREEN GOES HERE
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () { signIn(); },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        //TODO sign up new user here
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                      },
                      child: const Text('New User? Create Account',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )




      )

    );
  }

  Future<void> signIn() async {
    //todo validate fields
    final formState = _formKey.currentState;
    if(formState!.validate()){
      //todo login to firebase
      formState.save();
      try{
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        //debugPrint('User : $user');
        //debugPrint('User : ${user.user?.email}');
        //user.user?.sendEmailVerification();
        if(!mounted) return;
        //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: user.user?.uid,)));
        //debugPrint('User UID : ${user.user?.uid}');
        DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc("${user.user?.uid}");
        documentReference.get().then((value) =>
            setState(() {
              displayName.text =  value.get("name").toString();
              role.text = value.get("role").toString();
              //debugPrint('User role : ${role.text}');
              checkRole(role.text, user);
            }
            ));
      }catch(e){
        debugPrint(e.toString());
      }
    }
  }

  void checkRole(String role, UserCredential user){
    //UserHelper.saveUser(snapshot.data!['users']);
    //debugPrint('Role : $role');
    if(role == 'admin'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAdminHomePage()));
      //return MyAdminHomePage(title: 'Admin',);
    }
    else{
      // return userPage(snapshot);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserHomePage()));
    }
  }
}

