import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/message_card.dart';
import '../components/show_error.dart';

class Chat extends StatelessWidget {
  final String currentUser;
  final String docId;
  const Chat(this.currentUser, this.docId, {super.key});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    final TextEditingController _newmsg = TextEditingController();

    final ScrollController _scrollController = ScrollController();
    CollectionReference users =
        FirebaseFirestore.instance.collection('messages');
    DocumentReference doc = users.doc(docId);

    final Stream<DocumentSnapshot> messageStream = doc.snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  if (snapshot.data!.data() != Null) {
                    dynamic msgdata = snapshot.data!.data();
                    List<dynamic> msgList = msgdata["messages"];
                    return ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return MessageCard(currentUser, msgList[index]);
                      },
                      itemCount: msgList.length,
                    );
                  }
                  return Container(color: Colors.white);
                }),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                  controller: _newmsg,
                  decoration: InputDecoration(
                    hintText: "type your message here...",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (_newmsg.text.isEmpty) {
                          // print("Entre your msg");
                          showError(context, "Message is Empty");
                          return;
                        }
                        Map newmsg = {currentUser: _newmsg.text};
                        try {
                          await doc.update({
                            'messages': FieldValue.arrayUnion([newmsg])
                          });
                        } catch (e) {
                          print(e);
                        }
                        _newmsg.clear();
                        // Scroll to the last item
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      },
                      icon: const Icon(Icons.send_rounded),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
