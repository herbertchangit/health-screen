import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      home: const MyUserHomePage(),
    );
  }
}

class MyUserHomePage extends StatefulWidget {
  const MyUserHomePage({super.key});

  @override
  State<MyUserHomePage> createState() => _MyUserHomePageState();
}

Future getData() async{
  String url = "/read.php"; //https://unbarbed-election.000webhostapp.com/read.php
  var response = await http.get(Uri(scheme: 'https', host: 'unbarbed-election.000webhostapp.com', path: url),
      headers: {"Access-Control-Allow-Origin": "*", "Accept":"application/json"});
  var responseBody = json.decode(response.body);
  //debugPrint('response body : $responseBody');
  return responseBody;
}

class _MyUserHomePageState extends State<MyUserHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('User'),
        actions: [IconButton(icon:  const Icon(Icons.refresh),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyUserHomePage(),),);
            debugPrint('Refresh clicked ...... ');
          },)],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: _listView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditPage(list: [],index: 0, editMode: false, role: 'user',),),);
          debugPrint('Edit clicked');
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditPage(list: snap,index: index, editMode: true, role: 'admin',),),);
                        debugPrint('Edit clicked');
                      }),
                  title: Text(snap[index]['name']),
                  subtitle: Text(snap[index]['nric']),
                  trailing: GestureDetector(child: const Icon(Icons.delete),
                    onTap: (){
                      var url = 'delete.php';
                      http.post(Uri(scheme: 'https', host: 'unbarbed-election.000webhostapp.com', path: url),
                          body: {'id': snap[index]['id'],});
                      debugPrint('Delete clicked');
                    },),
                );
              }
          ) : const Center( child : CircularProgressIndicator());
        }
    );
  }
}
