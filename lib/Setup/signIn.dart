import 'package:health_screening/Pages/adminPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  late String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'),),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if(input!.isEmpty){
                      return 'Please keyin your email ';}
                    return null;
                  },
                  onSaved: (input) => _email = input!,
                  decoration: const InputDecoration(labelText: 'Email'
                  ),
                ),
                TextFormField(
                  validator: (input) {
                    if(input!.length < 6) {
                      return  'Your password needs to be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (input) => _password = input!,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () { signIn(); },
                  child: const Text('Sign In'),
                )
              ],
            ),
        )
      ),
    );
  }

  void signIn() async {
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyAdminHomePage()));
      }catch(e){
        debugPrint(e.toString());
      }
    }
  }
}

