class WorkEntry {
  final String key;
  final String id;
  final String title;
  final String date;
  final String fromTime;
  final String toTime;
  final String hours;
  final String status;
  final String description;
  final String workplace;

  WorkEntry({
    this.key = '',
    required this.id,
    required this.title,
    required this.date,
    required this.fromTime,
    required this.toTime,
    required this.hours,
    required this.status,
    required this.description,
    required this.workplace,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'fromTime': fromTime,
      'toTime': toTime,
      'hours': hours,
      'status': status,
      'description': description,
      'workplace': workplace,
    };
  }

  factory WorkEntry.fromMap(Map<dynamic, dynamic> map, String key) {
    return WorkEntry(
      key: key,
      id: key,
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      fromTime: map['fromTime'] ?? '',
      toTime: map['toTime'] ?? '',
      hours: map['hours'] ?? '0',
      status: map['status'] ?? 'Pending',
      description: map['description'] ?? '',
      workplace: map['workplace'] ?? '',
    );
  }
}
