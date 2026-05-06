class NotificationItem {
  final String title;
  final String message;
  final String time;
  final bool isHighlighted;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.isHighlighted = false,
  });
}

class NotificationMapper {
  static NotificationItem map(Map<String, dynamic> item) {
    final title = (item['title'] ?? '').toString().trim();
    final message = (item['message'] ?? '').toString().trim();
    final createdAtRaw = (item['created_at'] ?? '').toString();

    final createdAt = DateTime.tryParse(createdAtRaw)?.toLocal();

    final hh = createdAt?.hour.toString().padLeft(2, '0') ?? '--';
    final mm = createdAt?.minute.toString().padLeft(2, '0') ?? '--';

    final isRead = item['is_read'] == true;

    return NotificationItem(
      title: title.isEmpty ? 'Notification' : title,
      message: message.isEmpty ? '-' : message,
      time: '$hh:$mm',
      isHighlighted: !isRead,
    );
  }
}