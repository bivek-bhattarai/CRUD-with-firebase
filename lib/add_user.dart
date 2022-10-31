import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('users');
  late String name;
  late String age;
  late String phone;

  var nameFieldController = TextEditingController();
  var ageFieldController = TextEditingController();
  var phoneFieldController = TextEditingController();

  void addUser() async {
    await ref.add({'Name': name, 'Age': age, 'Phone': phone}).then((value) =>  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Added Successfully"),
      duration: Duration(milliseconds: 3000),
    ))).then((value) => Navigator.pop(context));

    nameFieldController.clear();
    ageFieldController.clear();
    phoneFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameFieldController,
            decoration: const InputDecoration(hintText: 'Enter your name'),
            onChanged: (value) {
              name = value;
            },
          ),
          TextField(
            controller: ageFieldController,
            decoration: const InputDecoration(hintText: 'Enter your age'),
            onChanged: (value) {
              age = value;
            },
          ),
          TextField(
            controller: phoneFieldController,
            decoration: const InputDecoration(hintText: 'Enter your phone'),
            onChanged: (value) {
              phone = value;
            },
          ),
          RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            onPressed: () {
              addUser();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
