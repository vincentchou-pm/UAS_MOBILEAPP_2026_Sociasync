class ReminderItem {
  final int id;
  final String to;
  final String message;
  final String day;
  final String time;

  const ReminderItem({
    required this.id,
    required this.to,
    required this.message,
    required this.day,
    required this.time,
  });

  factory ReminderItem.fromJson(Map<String, dynamic> json) {
    return ReminderItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      to: (json['to'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      day: (json['day'] ?? '').toString(),
      time: _normalizeTime((json['time'] ?? '').toString()),
    );
  }

  static String _normalizeTime(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return '';
    if (text.length >= 5 && text.contains(':')) {
      return text.substring(0, 5);
    }
    return text;
  }
}