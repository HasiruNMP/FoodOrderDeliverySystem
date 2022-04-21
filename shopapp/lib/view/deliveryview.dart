// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shopapp/api/apiservice.dart';
import 'package:shopapp/model/postCategory.dart';
import 'package:shopapp/model/postEmployee.dart';
import 'package:shopapp/view/homeview.dart';
import 'package:shopapp/view/menuview.dart';

class DeliveryView extends StatefulWidget {
  const DeliveryView({Key? key}) : super(key: key);

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              child: const SideBar(),
            ),
          ),
          const Expanded(
            flex: 14,
            child: DeliveryDetailedView(),
          ),
        ],
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.food_bank), Text('FODS')],
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MenuHomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                Text(
                  'MENU',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.store,
                  color: Colors.black,
                ),
                Text(
                  'ORDERS',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DeliveryView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.pedal_bike,
                  color: Colors.black,
                ),
                Text(
                  'DELIVERY',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formKey2 = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Delivery Person'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Add New",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
                Expanded(
                  flex: 11,
                  child: Padding(
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
                                    name: newFirstName.text +
                                        " " +
                                        newLastName.text,
                                    phone: newPhone.text,
                                    username: newUsername.text,
                                    department: 'Delivery',
                                    employeeId: 0,
                                    license: newLicense.text,
                                    nic: newNic.text);
                                var addStatus =
                                    await APIService.addDeliveryPerson(deliver);
                                print(addStatus);
                                if (addStatus == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blue,
                                      content: Text('Data Added Successfully!'),
                                    ),
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DeliveryView(),
                                    ),
                                    (route) => false,
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
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Delivery Person",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )),
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
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              employeeId = data[index]
                                                  .employeeId
                                                  .toString();
                                              updatePhone.text =
                                                  data[index].phone;
                                              updateName.text =
                                                  data[index].name;
                                              updateNic.text = data[index].nic;
                                              updateUsername.text =
                                                  data[index].username;
                                              updateLicense.text =
                                                  data[index].license;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(data[index].name),
                                              const Icon(Icons.navigate_next),
                                            ],
                                          ),
                                        ),
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
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Delivery Person Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
                Expanded(
                  flex: 11,
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
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Employee ID:",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    employeeId,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: SizedBox(),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Delivery Person Name:",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: updateName,
                                    decoration: InputDecoration(
                                        hintText: "New Value",
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "NIC:",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: updateNic,
                                    decoration: InputDecoration(
                                        hintText: "New Value",
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Phone:",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: updatePhone,
                                    decoration: InputDecoration(
                                        hintText: "New Value",
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Username:",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: updateUsername,
                                    decoration: InputDecoration(
                                        hintText: "New Value",
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "License:",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: updateLicense,
                                    decoration: InputDecoration(
                                        hintText: "New Value",
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Container(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey2.currentState!.validate()) {
                                var updateStatus =
                                    await APIService.updateDeliveryPerson(
                                        int.parse(employeeId),
                                        updateNic.text,
                                        updateName.text,
                                        updateLicense.text,
                                        updatePhone.text,
                                        updateUsername.text);
                                if (updateStatus == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blue,
                                      content: Text('Updated Successfully!'),
                                    ),
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DeliveryView(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Failed to Update!'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Failed to update data!'),
                                  ),
                                );
                              }
                            },
                            child: Text("Update"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (employeeId != 'null') {
                                var deleteStatus =
                                    await APIService.deleteEmployee(
                                  int.parse(employeeId),
                                );
                                if (deleteStatus == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blue,
                                      content: Text('Deleted Successfully!'),
                                    ),
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DeliveryView(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Failed to Delete!'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'Please select delivery person you want to delete!'),
                                  ),
                                );
                              }
                            },
                            child: Text("Delete Employee"),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
