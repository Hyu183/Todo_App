class TodoDTO {
  final int id;
  final String title;
  final DateTime dueTime;
//   final String description;
  final int isDone;

  const TodoDTO({
    required this.id,
    required this.title,
    required this.dueTime,
    // required this.description,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dueTime': dueTime.toIso8601String().replaceFirst('T', ' '),
      'isDone': isDone,
    };
  }
}
