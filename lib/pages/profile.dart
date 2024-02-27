import 'dart:io';

import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Profile extends StatefulWidget {
  const Profile(this.username, {Key? key, required this.imagePath})
      : super(key: key);
  final String username;
  final String imagePath;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(widget.imagePath)),
                      ),
                    ),
                    margin: EdgeInsets.all(20),
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    'Hi ' + widget.username + '!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              FutureBuilder(
                future: FirebaseFunctions().readdata(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something Went Wrong');
                  }
                  // ignore: dead_code
                  else if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Home',
                              style: TextStyle(fontSize: 40),
                            ),
                            SwitchListTile(
                              title: Text('Lock 1'),
                              value: (snapshot.data
                                      as Map<String, dynamic>?)?['switch1'] ??
                                  false,
                              onChanged: (value) {
                                setState(() {
                                  FirebaseFunctions().writedata(
                                    !((snapshot.data as Map<String, dynamic>?)?[
                                            'switch1'] ??
                                        false),
                                    ((snapshot.data as Map<String, dynamic>?)?[
                                            'switch2'] ??
                                        false),
                                  );
                                });
                              },
                            ),
                            SwitchListTile(
                              title: Text('Lock 2'),
                              value: (snapshot.data
                                      as Map<String, dynamic>?)?['switch2'] ??
                                  false,
                              onChanged: (value) {
                                setState(() {
                                  FirebaseFunctions().writedata(
                                    ((snapshot.data as Map<String, dynamic>?)?[
                                            'switch1'] ??
                                        false),
                                    !((snapshot.data as Map<String, dynamic>?)?[
                                            'switch2'] ??
                                        false),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              Spacer(),
              AppButton(
                text: "LOG OUT",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                color: Color(0xFFFF6161),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseFunctions {
  Future<void> writedata(bool switch1, bool switch2) async {
    DatabaseReference ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                "https://efda-d66cd-default-rtdb.asia-southeast1.firebasedatabase.app")
        .ref()
        .child('data');

    await ref.set({
      "switch1": switch1,
      "switch2": switch2,
    });
  }

  Future<Map<String, bool?>> readdata() async {
    final ref = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                "https://efda-d66cd-default-rtdb.asia-southeast1.firebasedatabase.app")
        .ref()
        .child('data');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final Map<dynamic, dynamic>? data =
          snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final bool? switch1 = data['switch1'] as bool?;
        final bool? switch2 = data['switch2'] as bool?;

        return {'switch1': switch1, 'switch2': switch2};
      }
    } else {
      print('No data available.');
    }

    return {
      'switch1': true,
      'switch2': true,
    }; // Default values if no data is available
  }
}
