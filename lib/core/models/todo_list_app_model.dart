class TodoListAppModel {
  final int? id;
  final String description;

  TodoListAppModel({
    this.id,
    required this.description,
  });

  TodoListAppModel copyWith({
    int? id,
    String? description,
  }) =>
      TodoListAppModel(
          id: id ?? this.id, description: description ?? this.description);

  static TodoListAppModel fromJson(Map<String, Object?> json) =>
      TodoListAppModel(
        id: json['id'] as int?,
        description: json['description'] as String,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'description': description,
      };
}
