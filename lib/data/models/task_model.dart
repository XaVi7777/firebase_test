class TaskModel {
  final String text;

  TaskModel({required this.text});

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      TaskModel(text: json['text'] as String);

  Map<String, dynamic> toJson() => {'text': text};

  TaskModel copyWith({String? text}) => TaskModel(text: text ?? this.text);
}
