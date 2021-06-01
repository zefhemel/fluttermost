import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttermost',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(
              tabs: [
                Tab(text: "Server1"),
                Tab(text: "Server2"),
              ],
            )),
            body: TabBarView(children: [
              MattermostServer(serverName: "Server 1"),
              MattermostServer(serverName: "Server 2"),
            ]),
          )),
    );
  }
}

class MattermostServer extends StatelessWidget {
  String serverName;

  MattermostServer({
    Key? key,
    required String serverName,
  })  : serverName = serverName,
        super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 3,
            child: Container(
              color: Colors.black12,
              child: SidebarWidget(),
            )),
        Expanded(
          flex: 7,
          child: Container(
            child: ChannelView(),
          ),
        ),
      ],
    );
  }
}

class SidebarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.all(8),
        child: Text("Channels",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            )),
      ),
      Expanded(
          flex: 1,
          child: ListView.builder(
              padding: const EdgeInsets.all(3),
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 25,
                  child: Container(child: Text('Channel $index')),
                );
              })),
    ]);
  }
}

class ChannelView extends StatelessWidget {
  // New code
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // RaisedButton(
        //   child: Text('To Bottom'),
        //   onPressed: () {
        //     _scrollController.animateTo(
        //         _scrollController.position.maxScrollExtent,
        //         duration: Duration(milliseconds: 100),
        //         curve: Curves.fastOutSlowIn);
        //   },
        // ),
        Expanded(
          child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(3),
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: PostCard(),
                );
              }),
        ),
        ChatEntryView(),
      ],
    );
  }
}

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            _hovering = true;
          });
        },
        onExit: (event) {
          setState(() {
            _hovering = false;
          });
        },
        child: Stack(
          children: [
            Column(children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://pickaface.net/gallery/avatar/MissGriffith529ca4c121402.png"),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Text(
                              "Zef 🤯",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("22:23",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: MarkdownBody(
                          data: 'This is some awesome [stuff](https://zef.me)',
                          onTapLink: (text, href, title) {
                            print("Clicked $text with $href");
                          },
                        ),
                      ),
                      ReactionsWidget()
                    ],
                  )
                ],
              )
            ]),
            if (_hovering)
              Positioned(
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('...'),
                  ),
                ),
                top: 5,
                right: 5,
              )
          ],
        ),
      ),
    );
  }
}

class ReactionsWidget extends StatelessWidget {
  const ReactionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReactionButton(emoji: "👍", count: 3),
        ReactionButton(emoji: "🤯", count: 200),
      ],
    );
  }
}

class ReactionButton extends StatelessWidget {
  String emoji;
  int count;

  ReactionButton({
    Key? key,
    required this.emoji,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 8),
        child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
            ),
            onLongPress: () {
              print("Long pressed");
            },
            onPressed: () {
              print("Thumbed up");
            },
            child: Row(children: [
              Text(
                emoji,
              ),
              Text(
                " $count",
                style: TextStyle(color: Colors.black54, fontSize: 11),
              )
            ])));
  }
}

/// This is the stateful widget that the main application instantiates.
class ChatEntryView extends StatefulWidget {
  const ChatEntryView({Key? key}) : super(key: key);

  @override
  State<ChatEntryView> createState() => _ChatEntryState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ChatEntryState extends State<ChatEntryView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      onSubmitted: (String value) async {
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thanks!'),
              content: Text(
                  'You typed "$value", which has length ${value.characters.length}.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
