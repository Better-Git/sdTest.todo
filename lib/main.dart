import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(MyToDoApp());
}

class MyToDoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To-Do',
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter To-Do'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _list = [];
  TextEditingController _controller = TextEditingController();

  Future<void> _showTaskCreateDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create A New Task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: _controller,
                  cursorHeight: 30.0,
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(primary: Colors.red),
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _list.add('${_controller.text}');
                    _controller.text = '';
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskItems(int index, String text) {
    var _slidableController = SlidableController(),
        _slidableKey = GlobalObjectKey<SlidableState>(text);

    return Slidable(
      actionExtentRatio: 0.25,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      controller: _slidableController,
      delegate: SlidableDrawerDelegate(),
      key: _slidableKey,
      secondaryActions: <Widget>[
        Stack(
          children: <Widget>[
            IconSlideAction(
              caption: 'Remove',
              color: Colors.red,
              icon: Icons.delete,
            ),
            Positioned.fill(
              child: Material(
                child: InkWell(
                  onTap: () {
                    _slidableKey.currentState.close();
                    setState(() {
                      _list.removeAt(index);
                    });
                  },
                  splashColor: Colors.transparent,
                ),
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => _buildTaskItems(index, _list[index]),
        itemCount: _list.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
          thickness: 4.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showTaskCreateDialog,
        tooltip: 'Add A New Task',
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
