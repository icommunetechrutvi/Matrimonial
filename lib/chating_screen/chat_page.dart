/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late PusherClient pusher;
  Channel? channel;
  List<Message> messages = [];
  List<User> users = [
    User(id: 'user1', name: 'User 1'),
    User(id: 'user2', name: 'User 2'),
  ];
  String currentChannel = '';
  String currentUser = 'user1'; // Replace with actual logged-in user
  TextEditingController messageController = TextEditingController();



  @override
  void initState() {
    super.initState();
    initPusher();
  }

  void initPusher() {
    pusher = PusherClient(
      '38d0122e284cfacbf6d5',
      PusherOptions(
        cluster: 'ap2',
        encrypted: true,
      ),
      enableLogging: true,
    );
  }
  //
  // void subscribeToChannel(String channelName) {
  //   channel?.unbind('message');
  //   // channel?.unsubscribe();
  //
  //   channel = pusher.subscribe(channelName);
  //   channel!.bind('message', (event) {
  //     if (event?.data != null) {
  //       final data = json.decode(event!.data.toString());
  //       final message = Message.fromJson(data);
  //       setState(() {
  //         messages.add(message);
  //       });
  //     }
  //   });
  //
  //   pusher.connect();
  // }

  void subscribeToChannel(String channelName) {
    channel?.unbind('message');
    channel = pusher.subscribe(channelName);

    channel!.bind('message', (event) {
      if (event?.data != null) {
        final data = json.decode(event!.data.toString());
        final message = Message.fromJson(data);
        setState(() {
          messages.add(message);
        });
      }
    });

    pusher.connect();
  }

  Future<void> sendMessage(String messageContent) async {
    final url = Uri.parse('http://192.168.1.42:3000/send-message'); // Replace with your IP address
    print('URL: $url');
    final jsonData = json.encode({
      'channel': currentChannel,
      'message': messageContent,
      'sender': currentUser,
    });
    print('Payload: $jsonData');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        print('Message sent!');
        // Optionally process the response here
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void startChatWithUser(User user) {
    setState(() {
      currentChannel = '${currentUser}-${user.id}';
      messages.clear();
    });
    subscribeToChannel(currentChannel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text('Pusher',style: TextStyle(color: AppColor.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
              image: AssetImage("assets/icon/back_app_bar.png"),
              height: MediaQuery.of(context).size.height * 0.02),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  onTap: () {
                    startChatWithUser(user);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.sender == currentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: message.sender == currentUser
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${message.sender}: ${message.content}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0,left: 12,right: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = messageController.text;
                    if (message.isNotEmpty) {
                      sendMessage(message);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel?.unbind('message');
    // channel?.unsubscribe();
    pusher.disconnect();
    super.dispose();
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}

class Message {
  final String sender;
  final String content;

  Message({required this.sender, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      content: json['message'],
    );
  }
}*/










import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late PusherClient pusher;
  Channel? channel;
  List<User> users = [
    User(id: 'user1', name: 'User 1'),
    User(id: 'user2', name: 'User 2'),
    User(id: 'user3', name: 'User 3'),
    User(id: 'user4', name: 'User 4'),
  ];
  String currentUser = 'user4'; // Replace with actual logged-in user
  // String currentUser = '69';

  @override
  void initState() {
    super.initState();
    initPusher();
  }

  void initPusher() {
    pusher = PusherClient(
      '38d0122e284cfacbf6d5',
      PusherOptions(
        cluster: 'ap2',
        encrypted: true,
      ),
      enableLogging: true,
    );
    pusher.connect();
  }

  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }

  // void startChatWithUser(User user) {
  //   final channelName = '${currentUser}-${user.id}';
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return AllUserPage(
  //       userChannel: channelName,
  //       currentUser: currentUser,
  //       pusher: pusher,
  //     );
  //   }));
  // }

  void startChatWithUser(User user) {
    final userIds = [currentUser, user.id];
    userIds.sort();
    final channelName = userIds.join('-');

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AllUserPage(
        userChannel: channelName,
        currentUser: currentUser,
        pusher: pusher,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text('Pusher', style: TextStyle(color: AppColor.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
              image: AssetImage("assets/icon/back_app_bar.png"),
              height: MediaQuery.of(context).size.height * 0.02),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            color: Colors.white24,
            child: ListTile(
              title: Text(user.name, style: TextStyle(fontSize: 19)),
              onTap: () {
                startChatWithUser(user);
              },
            ),
          );
        },
      ),
    );
  }
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}


class AllUserPage extends StatefulWidget {
  final String userChannel;
  final String currentUser;
  final PusherClient pusher;

  const AllUserPage({
    Key? key,
    required this.userChannel,
    required this.currentUser,
    required this.pusher,
  }) : super(key: key);

  @override
  _AllUserPageState createState() => _AllUserPageState();
}

class _AllUserPageState extends State<AllUserPage> {
  TextEditingController messageController = TextEditingController();
  List<Message> messages = [];
  Channel? channel;

  @override
  void initState() {
    super.initState();
    subscribeToChannel();
  }

  void subscribeToChannel() {
    channel?.unbind('message');
    channel = widget.pusher.subscribe(widget.userChannel);
    // channel = widget.pusher.subscribe("private-chatify.3");

    channel!.bind('message', (event) {
      print('Received event: ${event?.data}');
      if (event?.data != null) {
        final data = json.decode(event!.data.toString());
        final message = Message.fromJson(data);
        setState(() {
          messages.add(message);
        });
      }
    });

    widget.pusher.connect();
  }

  @override
  void dispose() {
    channel?.unbind('message');
    widget.pusher.unsubscribe(widget.userChannel);
    super.dispose();
  }

  Future<void> sendMessage(String messageContent) async {
    final url = Uri.parse('http://192.168.1.42:3000/send-message');
    final jsonData = json.encode({
      'channel': widget.userChannel,
      'message': messageContent,
      'sender': widget.currentUser,
      // 'from_id': "69",
      // 'message': messageContent,
      // 'to_id': "3",
    });

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Message sent!');
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text('Chat Page # ${widget.userChannel}', style: TextStyle(color: AppColor.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
              image: AssetImage("assets/icon/back_app_bar.png"),
              height: MediaQuery.of(context).size.height * 0.02),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.sender == widget.currentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: message.sender == widget.currentUser
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${message.sender}: ${message.content}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, left: 12, right: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(borderSide: BorderSide(width: 8),borderRadius: BorderRadius.circular(100)),
                      hintText: 'Write a message..',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = messageController.text;
                    if (message.isNotEmpty) {
                      sendMessage(message);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String content;

  Message({required this.sender, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      content: json['message'],
    );
  }
}
