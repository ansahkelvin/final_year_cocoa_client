import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoa_project/pages/auth/login.dart';
import 'package:cocoa_project/pages/cocoa_details.dart';
import 'package:cocoa_project/pages/cocoa_processing.dart';
import 'package:cocoa_project/widgets/Blog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? image;

  Future<void> getImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final imagePicked = await imagePicker.pickImage(source: ImageSource.camera);
    if (imagePicked != null) {
      image = imagePicked;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProcessCocoa(
          image: File(image!.path),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Cocoa Pods",
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: const Icon(Icons.camera_alt_outlined),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1480694313141-fce5e697ee25?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                ),
                accountName: Text("Cocoa App"),
                accountEmail: Text("Version 1")),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: const Text("Log out"))
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("blog").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return Blog(
                    title: ds["title"],
                    date: ds["date"],
                    description: ds["description"],
                    imageUrl: ds["imageUrl"],
                  );
                });
          }),
    );
  }
}
