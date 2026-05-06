class FakeDashboardService {
  static Future<Map<String, dynamic>> getProfile() async {
    return {
      'name': 'Test User',
      'instagram_connected': true,
      'instagram_username': 'test_ig',
      'tiktok_connected': true,
      'tiktok_username': 'test_tt',
    };
  }

  static Future<int> getUnreadCount() async {
    return 3;
  }

  static Future<Map<String, dynamic>> getInstagramDashboard() async {
    return {
      'latest_stats': {
        'engagement_percentage': 5.2,
        'followers_count': 10000,
        'total_posts': 120,
        'total_likes': 5000,
        'total_comments': 500,
      }
    };
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    return List.generate(7, (i) {
      return {
        'engagement_percentage': 3.0 + i,
        'recorded_at': DateTime.now()
            .subtract(Duration(days: 6 - i))
            .toIso8601String(),
      };
    });
  }
}