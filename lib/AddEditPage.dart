import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class AddEditPage extends StatefulWidget {
  final List list;
  final int index;
  final bool editMode;

  const AddEditPage({super.key, required this.list, required this.index, required this.editMode});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {

  TextEditingController name = TextEditingController();
  TextEditingController nric = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController huai = TextEditingController();
  TextEditingController xieli = TextEditingController();
  TextEditingController mobile = TextEditingController();

  //bool editMode = false;

  addUpdateData(){
    if(widget.editMode){
      var url = 'update.php';
      http.post(Uri(scheme: 'https', host: 'unbarbed-election.000webhostapp.com', path: url), headers: {"Accept":"application/json"},
          body: {
            'id' : widget.list[widget.index]['id'],
            'name' : name.text,
            'nric' : nric.text,
            'age' : age.text,
            'gender' : gender.text,
            'huai' : huai.text,
            'xieli' : xieli.text,
            'mobile' : mobile.text,
        });
    }else{
      var url = 'create.php';
      http.post(Uri(scheme: 'https', host: 'unbarbed-election.000webhostapp.com', path: url), headers: {"Accept":"application/json"},
          body: {
              'name' : name.text,
              'nric' : nric.text,
              'age' : age.text,
              'gender' : gender.text,
              'huai' : huai.text,
              'xieli' : xieli.text,
              'mobile' : mobile.text,
          });
    }

  }


  @override
  void initState() {
    super.initState();
    if(widget.editMode){
      debugPrint('Edit id : ${widget.list[widget.index]}');
      name.text = widget.list[widget.index]['name'];
      nric.text = widget.list[widget.index]['nric'];
      age.text = widget.list[widget.index]['age'];
      gender.text = widget.list[widget.index]['gender'];
      huai.text = widget.list[widget.index]['huai'];
      xieli.text = widget.list[widget.index]['xieli'];
      mobile.text = widget.list[widget.index]['mobile'];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.editMode ? 'Update' :'Add Data'),),
      body: ListView(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: name,
              decoration: const InputDecoration(labelText: '名字 Name :',),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nric,
              decoration: const InputDecoration(labelText: '身份証號碼 NRIC :',),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: age,
              decoration: const InputDecoration(labelText: '年齡 Age :',),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: mobile,
              decoration: const InputDecoration(labelText: '電話號碼 Mobile no. :',),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: gender,
              decoration: const InputDecoration(labelText: '性別 Gender :',),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: huai,
              decoration: const InputDecoration(labelText: '互愛 HuAi  :',),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: xieli,
              decoration: const InputDecoration(labelText: '協力 XieLi  :',),
            ),
          ),
          Padding(padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: (){
                setState(() {
                  addUpdateData();
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Health Screening'),),);
                debugPrint('Clicked Button');
              },
              child: Text(widget.editMode ? 'Update' :'Save',style: const TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}