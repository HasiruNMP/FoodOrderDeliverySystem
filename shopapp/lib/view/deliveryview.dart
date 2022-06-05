// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shopapp/api/apiservice.dart';
import 'package:shopapp/model/postCategory.dart';
import 'package:shopapp/model/postEmployee.dart';
import 'package:shopapp/view/homeview.dart';
import 'package:shopapp/view/menuview.dart';

import 'loginview.dart';

class DeliveryDetailedView extends StatefulWidget {
  const DeliveryDetailedView({Key? key}) : super(key: key);

  @override
  _DeliveryDetailedViewState createState() => _DeliveryDetailedViewState();
}

class _DeliveryDetailedViewState extends State<DeliveryDetailedView> {
  String employeeId = "null";
  String phone = "null";
  String name = "null";
  String nic = "null";
  String username = "null";
  String license = "null";

  TextEditingController newLicense = TextEditingController();
  TextEditingController newNic = TextEditingController();
  TextEditingController newFirstName = TextEditingController();
  TextEditingController newLastName = TextEditingController();
  TextEditingController newPhone = TextEditingController();
  TextEditingController newUsername = TextEditingController();

  TextEditingController updateLicense = TextEditingController();
  TextEditingController updateNic = TextEditingController();
  TextEditingController updateName = TextEditingController();
  TextEditingController updatePhone = TextEditingController();
  TextEditingController updateUsername = TextEditingController();

  late Future<List<PostEmployee>> futureEmployeeData;
  @override
  void initState() {
    super.initState();
    futureEmployeeData = APIService.getDeliveryEmployees();
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Widget addDelP() {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: "First Name"),
                controller: newFirstName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Last Name"),
                controller: newLastName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "NIC"),
                controller: newNic,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Phone"),
                controller: newPhone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Username"),
                controller: newUsername,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "License"),
                controller: newLicense,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              OutlinedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    PostEmployee deliver = PostEmployee(
                        name: newFirstName.text + " " + newLastName.text,
                        phone: newPhone.text,
                        username: newUsername.text,
                        department: 'Delivery',
                        employeeId: 0,
                        license: newLicense.text,
                        nic: newNic.text);
                    var addStatus = await APIService.addDeliveryPerson(deliver);
                    print(addStatus);
                    if (addStatus == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text('Data Added Successfully!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Failed to add data!'),
                        ),
                      );
                    }
                  }
                },
                child: Text("Add New"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int selDelP = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const VerticalDivider(),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Delivery Person",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Divider(),
                      Expanded(
                        flex: 11,
                        child: FutureBuilder<List<PostEmployee>>(
                            future: futureEmployeeData,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }
                              //
                              // if (snapshot.connectionState == ConnectionState.waiting ||
                              //     !snapshot.hasData) {
                              //   return CircularProgressIndicator();
                              // }

                              if (snapshot.hasData) {
                                List<PostEmployee>? data = snapshot.data;
                                return ListView.builder(
                                    itemCount: data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        color: (selDelP == index)
                                            ? Colors.brown.shade100
                                            : Colors.brown.shade50,
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selDelP = index;
                                                employeeId = data[index]
                                                    .employeeId
                                                    .toString();
                                                updatePhone.text =
                                                    data[index].phone;
                                                updateName.text =
                                                    data[index].name;
                                                updateNic.text =
                                                    data[index].nic;
                                                updateUsername.text =
                                                    data[index].username;
                                                updateLicense.text =
                                                    data[index].license;
                                              });
                                            },
                                            child: ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(data[index].name),
                                                  const Icon(
                                                      Icons.navigate_next),
                                                ],
                                              ),
                                            )),
                                      );
                                    });
                              }
                              return Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(child: addDelP()),
          const VerticalDivider(),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Delivery Person Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 300, vertical: 100),
                    child: Form(
                      key: _formKey2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Employee ID: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    employeeId,
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                          //Divider(),
                          SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Name:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: updateName,
                                      decoration: InputDecoration(
                                          hintText: "New Value",
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "NIC:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: updateNic,
                                      decoration: InputDecoration(
                                          hintText: "New Value",
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Phone:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: updatePhone,
                                      decoration: InputDecoration(
                                          hintText: "New Value",
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Username:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: updateUsername,
                                      decoration: InputDecoration(
                                          hintText: "New Value",
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "License:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: updateLicense,
                                      decoration: InputDecoration(
                                          hintText: "New Value",
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      if (_formKey2.currentState!.validate()) {
                                        var updateStatus = await APIService
                                            .updateDeliveryPerson(
                                                int.parse(employeeId),
                                                updateNic.text,
                                                updateName.text,
                                                updateLicense.text,
                                                updatePhone.text,
                                                updateUsername.text);
                                        if (updateStatus == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.blue,
                                              content:
                                                  Text('Updated Successfully!'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text('Failed to Update!'),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content:
                                                Text('Failed to update data!'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Update",
                                      style: TextStyle(color: Colors.indigo),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      if (employeeId != 'null') {
                                        var deleteStatus =
                                            await APIService.deleteEmployee(
                                          int.parse(employeeId),
                                        );
                                        if (deleteStatus == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.blue,
                                              content:
                                                  Text('Deleted Successfully!'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text('Failed to Delete!'),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Please select delivery person you want to delete!'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Delete Employee",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
        ],
      ),
    );
  }
}
