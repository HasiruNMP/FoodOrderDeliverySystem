// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
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

  void updateEmployee(employeeId, phone, name, nic, username, license) {
    setState(() {
      this.employeeId = employeeId;
      this.phone = phone;
      this.name = name;
      this.nic = nic;
      this.username = username;
      this.license;
    });
  }

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

  final queryPost = FirebaseFirestore.instance
      .collection('employees')
      .where('department', isEqualTo: "delivery")
      .withConverter<PostEmployee>(
        fromFirestore: (snapshot, _) => PostEmployee.fromJson(snapshot.data()!),
        toFirestore: (nic, _) => nic.toJson(),
      );

  CollectionReference deliveryPersonConnect =
      FirebaseFirestore.instance.collection('employees');
  Future<void> addEmployee(newPhone, newName, newNic, newUsername, newLicense) {
    return deliveryPersonConnect
        .add({
          'employeeId': "null",
          'phone': newPhone,
          'name': newName,
          'nic': newNic,
          'department': "delivery",
          'username': newUsername,
          'license': newLicense,
        })
        .then((value) => deliveryPersonConnect
            .doc(value.id)
            .update({'employeeId': value.id}))
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Delivery Person Added'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add: $error'),
            ),
          ),
        );
  }

  void update(String id, String fieldName, String newValue) {
    deliveryPersonConnect
        .doc(id)
        .update({
          fieldName: newValue,
        })
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Value Updated'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update: $error'),
            ),
          ),
        );
  }

  void deleteEmployee() {
    deliveryPersonConnect
        .doc(employeeId)
        .delete()
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Delivery Person Deleted'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $error'),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String fullName =
                                    newFirstName.text + " " + newLastName.text;
                                addEmployee(
                                    newPhone.text,
                                    fullName,
                                    newNic.text,
                                    newUsername.text,
                                    newLicense.text);
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
                    child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Delivery Persons",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
                Expanded(
                  flex: 11,
                  child: FirestoreListView<PostEmployee>(
                    pageSize: 4,
                    query: queryPost,
                    itemBuilder: (context, snapshot) {
                      final post = snapshot.data();
                      return Card(
                        child: TextButton(
                          onPressed: () {
                            updateEmployee(
                                post.employeeId,
                                post.phone,
                                post.name,
                                post.nic,
                                post.username,
                                post.license);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post.name),
                              const Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      );
                    },
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
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
                Expanded(
                    flex: 11,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Employee ID:",
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    employeeId,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Delivery Person Name:",
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(name),
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
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      update(
                                          employeeId, "name", updateName.text);
                                    },
                                    child: Text("Update"),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "NIC:",
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(nic),
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
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      update(employeeId, "nic", updateNic.text);
                                    },
                                    child: Text("Update"),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Phone:",
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(phone),
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
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      update(employeeId, "phone",
                                          updatePhone.text);
                                    },
                                    child: Text("Update"),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Username:",
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(username),
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
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      update(employeeId, "username",
                                          updateUsername.text);
                                    },
                                    child: Text("Update"),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "License:",
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(license),
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
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      update(employeeId, "license",
                                          updateLicense.text);
                                    },
                                    child: Text("Update"),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                deleteEmployee();
                              },
                              child: Text("Delete Employee")),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
