import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final Map<String, dynamic> msg;
  final String currentUser;
  const MessageCard(this.currentUser, this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String sentby = msg.entries.first.key;
    return Align(
      alignment:
          sentby == currentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width / 2),
          decoration: BoxDecoration(
            color: sentby == currentUser
                ? Colors.amber
                : const Color.fromARGB(255, 213, 103, 237),
            borderRadius: sentby == currentUser
                ? const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))
                : const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(0),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 6, bottom: 2, left: 6, right: 6),
                child: Text(
                  sentby,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(msg.entries.first.value),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
