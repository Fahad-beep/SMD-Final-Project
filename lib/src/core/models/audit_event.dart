class AuditEvent {
  const AuditEvent({
    required this.id,
    required this.title,
    required this.details,
    required this.category,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String details;
  final String category;
  final DateTime createdAt;

  factory AuditEvent.fromJson(Map<String, dynamic> json) {
    return AuditEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      details: json['details'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
