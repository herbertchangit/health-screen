import 'package:flutter/material.dart';
import 'package:health_screening/Pages/adminPage.dart';
import 'package:health_screening/Pages/userPage.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class AddEditPage extends StatefulWidget {
  final List list;
  final int index;
  final bool editMode;
  final String role;

  const AddEditPage({super.key, required this.list,
    required this.index, required this.editMode, required this.role});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

enum Gender { Male, Female }

class _AddEditPageState extends State<AddEditPage> {

  //variables for text field controller
  TextEditingController name = TextEditingController();
  TextEditingController nric = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController huai = TextEditingController();
  TextEditingController xieli = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController registrationDate = TextEditingController();
  TextEditingController registrationTime = TextEditingController();

  //variables for date time picker
  late double _height;
  late double _width;
  late String _setTime, _setDate;
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _regDateController = TextEditingController();
  final TextEditingController _regTimeController = TextEditingController();

  addUpdateData() {
    if (widget.editMode) {
      var url = 'update.php';
      var response = http.post(Uri(scheme: 'https',
          host: 'unbarbed-election.000webhostapp.com',
          path: url), headers: {"Accept": "application/json"},
          body: {
            'id': widget.list[widget.index]['id'], 'name': name.text, 'nric': nric.text,
            'age': age.text, 'gender': gender.text, 'huai': huai.text,
            'xieli': xieli.text, 'mobile': mobile.text,
            'registration_date': registrationDate.text,
            'registration_time': registrationTime.text,
          });
      debugPrint('response : ${response.hashCode}');
    } else {
      var url = 'create.php';
      http.post(Uri(scheme: 'https',
          host: 'unbarbed-election.000webhostapp.com',
          path: url), headers: {"Accept": "application/json"},
          body: {
            'name': name.text, 'nric': nric.text, 'age': age.text, 'gender': gender.text,
            'huai': huai.text, 'xieli': xieli.text, 'mobile': mobile.text,
            'registration_date': registrationDate.text,
            'registration_time': registrationTime.text,
          });
    }
  }

  String genderController = "";

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      debugPrint('Edit id : ${widget.list[widget.index]}');
      name.text = widget.list[widget.index]['name'];
      nric.text = widget.list[widget.index]['nric'];
      age.text = widget.list[widget.index]['age'];
      gender.text = widget.list[widget.index]['gender'];
      genderController = widget.list[widget.index]['gender'];
      huai.text = widget.list[widget.index]['huai'];
      xieli.text = widget.list[widget.index]['xieli'];
      mobile.text = widget.list[widget.index]['mobile'];
      registrationDate.text = widget.list[widget.index]['registration_date'];
      registrationTime.text = widget.list[widget.index]['registration_time'];
    }

    _regDateController.text = DateFormat.yMd().format(DateTime.now());

    _regTimeController.text = formatDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null) {
      //var outputFormat = DateFormat('dd/MM/yyyy');
      var outputFormat = DateFormat('yyyy-MM-dd');
      var outputDate = outputFormat.format(picked);
      setState(() {
        selectedDate = picked;
        registrationDate.text = outputDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour : $_minute';
        registrationTime.text = _time;
        registrationTime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [HH, ':', nn, ":", ss]).toString();
        debugPrint('Selected Time : ${registrationTime.text}');
      });
    }
  }


  Gender? _gender = Gender.Female;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());

    if(genderController == 'Male'){
      _gender = Gender.Male;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.editMode ? 'Update' : 'Add Data'),),
      body: Center(
        child: SizedBox(
          width: 1000,
          child: ListView(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(8,20,8,8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget> [
                      Flexible(
                        child: TextFormField(
                          controller: name,
                          decoration: const InputDecoration(labelText: '名字 Name :', border: OutlineInputBorder(),),
                        ),
                      ),
                      const Icon(Icons.space_bar, color: Colors.black),
                      Flexible(child: TextField(
                        controller: nric,
                        decoration: const InputDecoration(labelText: '身份証號碼 NRIC :', border: OutlineInputBorder(),),
                      ),)
                    ]
                ),
              ),
              Padding(padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget> [
                      Flexible(
                        child: TextField(
                          controller: age,
                          decoration: const InputDecoration(labelText: '年齡 Age :', border: OutlineInputBorder(),),
                        ),
                      ),
                      const Icon(Icons.space_bar, color: Colors.black),
                      Flexible(
                        child: InkWell(
                          child: Container(
                            width: _width / 2,
                            height: _height / 9,
                            //margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: const Text('Male'),
                                  leading: Radio<Gender>(
                                    value: Gender.Male,
                                    groupValue: _gender,
                                    onChanged: (Gender? value) {
                                      setState(() {
                                        _gender = value;
                                        gender.text = 'Male';
                                        debugPrint('Gender : ${gender.text}');
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Female'),
                                  leading: Radio<Gender>(
                                    value: Gender.Female,
                                    groupValue: _gender,
                                    onChanged: (Gender? value) {
                                      setState(() {
                                        _gender = value;
                                        gender.text = 'Female';
                                        debugPrint('Gender : ${gender.text}');
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: mobile,
                  decoration: const InputDecoration(
                    labelText: '電話號碼 Mobile no. :', border: OutlineInputBorder(),),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget> [
                        Flexible(
                          child: TextField(
                            controller: huai,
                            decoration: const InputDecoration(labelText: '互愛 HuAi  :', border: OutlineInputBorder(),),
                          ),
                        ),
                        const Icon(Icons.space_bar, color: Colors.black),
                        Flexible(
                          child: TextField(
                            controller: xieli,
                            decoration: const InputDecoration(labelText: '協力 XieLi  :', border: OutlineInputBorder(),),
                          ),
                        )
                      ]
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget> [
                      Flexible(
                        child: InkWell(
                          onTap: () { _selectDate(context); },
                          child: Container(
                            width: _width / 2,
                            height: _height / 12,
                            margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextField(
                              controller: registrationDate,
                              decoration: const InputDecoration(labelText: '報名日期 Registration Date', border: OutlineInputBorder(),),
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.space_bar, color: Colors.black),
                      Flexible(
                        child: InkWell(
                        onTap: () { _selectTime(context); },
                        child: Container(
                          width: _width / 2,
                          height: _height / 12,
                          margin: const EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextField(
                            controller: registrationTime,
                            decoration: const InputDecoration(labelText: '報名時間 Registration Time', border: OutlineInputBorder(),),
                          ),
                        ),
                      ),)

                    ]
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          addUpdateData();
                        });
                        if (widget.role == 'admin') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const MyAdminHomePage(),),);
                        }
                        debugPrint('Clicked Button');
                      },
                      child: Text(widget.editMode ? 'Update' : 'Save',
                        style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.role == 'admin') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const MyAdminHomePage(),),);
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const MyUserHomePage(),),);
                        }
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}