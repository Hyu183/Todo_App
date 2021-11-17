class TodoDTO {
  final String id;
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
      'id': id,
      'title': title,
      'dueTime': dueTime.toIso8601String().replaceFirst('T', ' '),
      'isDone': isDone,
    };
  }
}
