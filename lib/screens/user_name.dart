import 'package:chatapp/screens/friend_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserName extends StatefulWidget {
  const UserName({super.key});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController _textController = TextEditingController();
  late final String currentUser;

  getUser() async {
    var s1 = await _users.doc("usersList").get().then((value) async {
      Map<String, dynamic> m = value.data() as Map<String, dynamic>;
      if (m[_textController.text] == null) {
        try {
          await _users.doc("usersList").update({_textController.text: 'user'});
          currentUser = _textController.text;
        } catch (e) {
          print(e);
        }
      } else if (m[_textController.text] == 'user') {
        currentUser = _textController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "John Doe",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                await getUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendsList(currentUser),
                  ),
                );
                _textController.clear();
              },
              color: Colors.amber,
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
