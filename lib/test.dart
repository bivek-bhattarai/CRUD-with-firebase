import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_user.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController ageFieldController = TextEditingController();
  TextEditingController phoneFieldController = TextEditingController();
  late String updateName;
  late String updateAge;
  late String updatePhone;

  List allData = [];
  bool isLoading = true;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<dynamic> getData() async {
    allData.clear();
    await ref.get().then((res) {
      res.docs.forEach((element) {
        var data = {
          'ID': element.id,
          'Name': element.get('Name'),
          'Age': element.get('Age'),
          'Phone': element.get('Phone'),
        };
        allData.add(data);
      });
    }).then((value) => setState(() {
          isLoading = false;
        }));
  }

  void updateData(int index, String name, age, phone) async {
    nameFieldController.clear();
    ageFieldController.clear();
    phoneFieldController.clear();
    try {
      await ref.doc(allData[index]['ID']).update({'Name': name, 'Age': age, 'Phone': phone});
      getData();
    } catch (e) {
      print(e);
    }
  }

  void deleteData(int index) async {
    try {
      await ref.doc(allData[index]['ID']).delete();
      getData();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isLoading == false
            ? ListView.builder(
                itemCount: allData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(allData[index]['Name']),
                    subtitle: Text(allData[index]['Age'] + ', ' + allData[index]['Phone']),
                    trailing: SizedBox(
                      width: 100.0,
                      child: Row(
                        children: <IconButton>[
                          IconButton(
                              color: Colors.blue,
                              onPressed: () {
                                updateName = allData[index]['Name'];
                                updateAge = allData[index]['Age'];
                                updatePhone = allData[index]['Phone'];
                                nameFieldController.text = allData[index]['Name'];
                                ageFieldController.text = allData[index]['Age'];
                                phoneFieldController.text = allData[index]['Phone'];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Update Data'),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: nameFieldController,
                                                onChanged: (value) {
                                                  updateName = value;
                                                },
                                                decoration: const InputDecoration(
                                                  labelText: 'Name',
                                                  icon: Icon(Icons.account_box),
                                                ),
                                              ),
                                              TextFormField(
                                                controller: ageFieldController,
                                                onChanged: (value) {
                                                  updateAge = value;
                                                },
                                                decoration: const InputDecoration(
                                                  labelText: 'Age',
                                                  icon: Icon(Icons.account_box),
                                                ),
                                              ),
                                              TextFormField(
                                                controller: phoneFieldController,
                                                onChanged: (value) {
                                                  updatePhone = value;
                                                },
                                                decoration: const InputDecoration(
                                                  labelText: 'Phone',
                                                  icon: Icon(Icons.phone),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            updateData(
                                                index, updateName, updateAge, updatePhone);
                                          },
                                          child: const Text('Submit'),
                                        ),
                                      ],
                                    );
                                  }
                                );
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              color: Colors.red,
                              onPressed: () {
                                deleteData(index);
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  );
                })
            : const Center(
                child: Text('Loading.....'),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddUser()))
              .then((value) => getData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
