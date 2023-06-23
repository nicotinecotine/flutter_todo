class Task {
  String title;
  String importance;
  DateTime? date;
  bool isDone;
  bool isDateVisible;

  Task(
    this.title,
    this.importance,
    this.date,
    this.isDone,
    this.isDateVisible,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'importance': importance,
      'date': date?.toIso8601String(),
      'isDone': isDone,
      'isDateVisible': isDateVisible,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['title'],
      json['importance'],
      json['date'] != null ? DateTime.parse(json['date']) : null,
      json['isDone'],
      json['isDateVisible'],
    );
  }
}
