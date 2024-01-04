import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_starting_project/components/message_bubble.dart';
import 'package:flash_chat_starting_project/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_starting_project/constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  TextEditingController _messageControlar = TextEditingController();

  // void getMessages() async {
  //   var messages = await _fireStore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messageStream() {
    _fireStore.collection('messages').snapshots().listen((event) {
      for (var message in event.docs) {
        print(message.data());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        automaticallyImplyLeading: false,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Implement logout functionality
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }

                AuthService().signOut();
              }),
        ],
        title: const Text('⚡ ️Chat'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(fireStore: _fireStore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageControlar,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality
                      _fireStore.collection('messages').add({
                        'data': DateTime.now().millisecondsSinceEpoch,
                        'text': _messageControlar.text,
                        'sender': AuthService().getCurrentUser!.email,
                      });
                      _messageControlar.clear();
                    },
                    child: const Icon(Icons.send,
                        size: 30, color: kSendButtonColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    super.key,
    required FirebaseFirestore fireStore,
  }) : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('messages')
          .orderBy('data', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          var messages = snapshot.data!.docs;
          List<Widget> messageWidgets = [];
          for (var message in messages) {
            var messageText = message.get('text');
            var sender = message.get('sender');
            Widget messageWidget = MessageBubble(
              message: messageText,
              sender: sender,
              isMe: AuthService().getCurrentUser!.email == sender,
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ),
          );
        } else {
          return Center(
            child: Text('snapshot has no data'),
          );
        }
      },
    );
  }
}
