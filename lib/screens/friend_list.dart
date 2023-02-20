import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/loding_data.dart';

class FriendsList extends StatelessWidget {
  final String currentUser;
  const FriendsList(this.currentUser, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final Stream<DocumentSnapshot> userStream =
        users.doc('usersList').snapshots();
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          elevation: 0,
          centerTitle: true,
          title: const Text("Messages"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.grey[100],
          child: StreamBuilder<DocumentSnapshot>(
              stream: userStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("loading");
                }

                Map<dynamic, dynamic> data =
                    snapshot.data!.data() as Map<dynamic, dynamic>;
                data.remove(currentUser);
                var userList = data.keys.toList();
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          bool doc1exist = false, doc2exist = false;
                          String? docId;

                          CollectionReference users =
                              FirebaseFirestore.instance.collection('messages');
                          DocumentReference documentRef1 =
                              users.doc("$currentUser and ${userList[index]}");
                          DocumentReference documentRef2 =
                              users.doc("${userList[index]} and $currentUser");

                          await documentRef1
                              .get()
                              .then((value) => doc1exist = value.exists);
                          await documentRef2
                              .get()
                              .then((value) => doc2exist = value.exists);

                          print(doc1exist);
                          print(doc2exist);

                          if (!doc1exist && !doc2exist) {
                            await documentRef1.set({
                              "messages": {
                                {currentUser: "Hi 👋! ${userList[index]}"}
                              }
                            }).then((value) {
                              print("Document added successfully!");
                            }).catchError((error) {
                              print("Failed to add document: $error");
                            });
                            docId = documentRef1.id;
                          }
                          if (doc1exist) docId = documentRef1.id;
                          if (doc2exist) docId = documentRef2.id;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Chat(currentUser, docId as String),
                            ),
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 25,
                            child: CachedNetworkImage(
                              imageUrl: "https://placekitten.com/640/360",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: imageProvider,
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                )),
                              ),
                              placeholder: (context, url) =>
                                  const LoadingData(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Text(
                          userList[index],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_circle_right_outlined),
                          onPressed: () {},
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    );
                  },
                  itemCount: userList.length,
                );
              }),
        ));
  }
}
