class TaskModel {
  final double createdAt;
  final double createdDate;
  final double expirationDate;
  final String status;
  final String text;

  TaskModel({
    required this.createdAt,
    required this.createdDate,
    required this.expirationDate,
    required this.status,
    required this.text,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    createdAt: (json['createdAt'] as num).toDouble(),
    createdDate: (json['createdDate'] as num).toDouble(),
    expirationDate: (json['expirationDate'] as num).toDouble(),
    status: json['status'] as String,
    text: json['text'] as String,
  );

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'createdDate': createdDate,
    'expirationDate': expirationDate,
    'status': status,
    'text': text,
  };

  TaskModel copyWith({
    double? createdAt,
    double? createdDate,
    double? expirationDate,
    String? status,
    String? text,
  }) => TaskModel(
    createdAt: createdAt ?? this.createdAt,
    createdDate: createdDate ?? this.createdDate,
    expirationDate: expirationDate ?? this.expirationDate,
    status: status ?? this.status,
    text: text ?? this.text,
  );
}
