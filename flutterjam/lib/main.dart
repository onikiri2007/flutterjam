import 'package:flutter/material.dart';
import 'package:flutterjam/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Jam Session 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  List<Todo> todos = new List<Todo>();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  void addToDo() {
    var todo = Todo(title: _controller.text);
    Firestore.instance.collection('todos').add(todo.toJson());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the title";
                        }
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Enter to do item",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, we want to show a Snackbar
                        addToDo();
                      }
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("todos").snapshots(),
                  builder: (BuildContext contesxt,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return _buildList(snapshot.data);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildList(QuerySnapshot data) {
    return ListView.separated(
        itemCount: data.documents.length,
        itemBuilder: (BuildContext context, int index) {
          var item = data.documents[index];
          var todo = Todo.fromJson(item.data);
          return _buildToDoItem(todo);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        });
  }

  _buildToDoItem(Todo todo) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.only(top: 2.0, bottom: 2.0),
    );
  }
}
