class Todo {
  String title;
  bool done;

  Todo({this.title, this.done = false});

  Map<String, dynamic> toJson() {
    return {"title": title, "done": done};
  }

  factory Todo.fromJson(Map<String, dynamic> data) {
    return Todo(title: data["title"], done: data["done"]);
  }
}
