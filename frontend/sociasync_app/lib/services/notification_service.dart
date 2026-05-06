/// Service class for notification settings helper methods
class NotificationService {
  /// Convert display label to API format for push schedule
  static String scheduleLabelToApi(String label) {
    switch (label) {
      case 'Always':
        return 'always';
      case 'During work hours (9AM - 6PM)':
        return 'work_hours';
      case 'Custom schedule':
        return 'custom';
      default:
        return 'always';
    }
  }

  /// Convert API format to display label for push schedule
  static String scheduleApiToLabel(String api) {
    switch (api) {
      case 'always':
        return 'Always';
      case 'work_hours':
        return 'During work hours (9AM - 6PM)';
      case 'custom':
        return 'Custom schedule';
      default:
        return 'Always';
    }
  }

  /// Convert display label to API format for SMS frequency
  static String smsLabelToApi(String label) {
    switch (label) {
      case 'Instantly':
        return 'instant';
      case 'Daily':
        return 'daily';
      case 'Weekly':
        return 'weekly';
      default:
        return 'instant';
    }
  }

  /// Convert API format to display label for SMS frequency
  static String smsApiToLabel(String api) {
    switch (api) {
      case 'instant':
        return 'Instantly';
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      default:
        return 'Instantly';
    }
  }
}
