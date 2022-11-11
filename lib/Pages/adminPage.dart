import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Setup/welcome.dart';
import 'AddEditPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heath Screening',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyAdminHomePage(),
    );
  }
}

class MyAdminHomePage extends StatefulWidget {
  const MyAdminHomePage({super.key});

  @override
  State<MyAdminHomePage> createState() => _MyAdminHomePageState();
}

Future getData() async{
  String url = "/read.php"; //https://unbarbed-election.000webhostapp.com/read.php
  var response = await http.get(Uri(scheme: 'https', host: 'unbarbed-election.000webhostapp.com', path: url),
      headers: {"Access-Control-Allow-Origin": "*", "Accept":"application/json"});
  var responseBody = json.decode(response.body);
  //debugPrint('response body : $responseBody');
  return responseBody;
}

class _MyAdminHomePageState extends State<MyAdminHomePage> {

  void _signOut() {
    FirebaseAuth.instance.signOut();
    //UserCredential user = FirebaseAuth.instance.currentUser as UserCredential;
    //print('$user');
    runApp(
        const MaterialApp(
          home: WelcomePage(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAdminHomePage(),),);
            //debugPrint('Refresh clicked ...... ');
          }, icon: const Icon(Icons.refresh)),
          IconButton(
              icon:  const Icon(Icons.logout),
              onPressed: () {
                _signOut();
                //debugPrint('Logout clicked ...... ');

              },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: _listView(),
          ),
        )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage(list: [],index: 0, editMode: false, role: "admin"),),);
          //debugPrint('Edit clicked');
        },
        tooltip: 'Add volunteer',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _listView extends StatelessWidget{
  //const _listView({super.key});
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            debugPrint("Error : ${snapshot.error}");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:  CircularProgressIndicator(),);
          }
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                List snap = snapshot.data;
                return ListTile(
                  leading:  GestureDetector(child: const Icon(Icons.edit),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditPage(list: snap,index: index, editMode: true, role: "admin",),),);
                        debugPrint('Edit clicked');
                      }),
                  title: Text(snap[index]['name']),
                  subtitle: Text(snap[index]['nric']),
                  trailing: GestureDetector(child: const Icon(Icons.delete),
                    onTap: (){
                      var url = 'delete.php';
                      http.post(Uri(scheme: 'https', host: 'unbarbed-election.000webhostapp.com', path: url),
                          body: {'id': snap[index]['id'],});
                      //debugPrint('Delete clicked');
                    },),
                );
              }
          ) : const Center( child : CircularProgressIndicator());
        }
    );
  }
}
