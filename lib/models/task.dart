
class Task {
  String description;
  String title;
  bool done;
  DateTime date;

  Task(this.title, {this.description = '', DateTime? date, this.done = false})
      : date = date ?? DateTime.now();
}
