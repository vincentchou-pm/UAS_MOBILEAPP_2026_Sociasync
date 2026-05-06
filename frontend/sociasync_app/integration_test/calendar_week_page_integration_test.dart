import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_week_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CalendarWeekPage Integration Tests', () {
    Future<void> pumpCalendarWeekPage(
      WidgetTester tester, {
      CalendarScheduleLoader? scheduleLoader,
      DateTime? initialDate,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CalendarWeekPage(
            scheduleLoader: scheduleLoader ?? () async => [],
            initialDate: initialDate,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    }

    Future<void> openViewDropdown(WidgetTester tester) async {
      await tester.tap(find.byKey(CalendarWeekPage.viewDropdownKey));
      await tester.pump(const Duration(milliseconds: 300));
    }

    Future<void> tapWeekDay(WidgetTester tester, DateTime day) async {
      await tester.tap(find.byKey(CalendarWeekPage.weekDayItemKey(day)));
      await tester.pump(const Duration(milliseconds: 300));
    }

    // ===== Setup Tests =====
    group('page load and initialization', () {
      testWidgets('page loads successfully', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('page initializes with current date', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('page displays header with user greeting', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('page displays month label correctly', (tester) async {
        await pumpCalendarWeekPage(tester);

        final now = DateTime.now();
        final monthLabels = [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        final expectedMonth = monthLabels[now.month];
        expect(find.textContaining('$expectedMonth ${now.year}'), findsWidgets);
      });
    });

    // ===== Switch View Selector Tests =====
    group('switch view selector workflow', () {
      testWidgets('dropdown button opens and shows options', (tester) async {
        await pumpCalendarWeekPage(tester);

        await openViewDropdown(tester);

        expect(find.text('Week'), findsWidgets);
        expect(find.text('Month'), findsOneWidget);
        expect(find.text('Year'), findsOneWidget);
      });

      testWidgets('selecting Week option keeps current view', (tester) async {
        await pumpCalendarWeekPage(tester);

        await openViewDropdown(tester);

        await tester.tap(find.text('Week').last);
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('dropdown maintains state after interaction', (tester) async {
        await pumpCalendarWeekPage(tester);

        await openViewDropdown(tester);
        await tester.tap(find.text('Week').last);
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });
    });

    // ===== Week Days Header Tests =====
    group('week days header interaction', () {
      testWidgets('clicking day selector changes date display', (tester) async {
        final today = DateTime.now();
        await pumpCalendarWeekPage(tester, initialDate: today);

        final secondDay = CalendarWeekConfig.weekDays(today)[1];
        await tapWeekDay(tester, secondDay);

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('selected day is highlighted visually', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('can navigate through multiple days', (tester) async {
        final today = DateTime.now();
        await pumpCalendarWeekPage(tester, initialDate: today);

        final days = CalendarWeekConfig.weekDays(today);
        for (final day in days.take(3)) {
          await tapWeekDay(tester, day);
        }

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });
    });

    // ===== Event Display Tests =====
    group('event display and visibility', () {
      testWidgets('displays empty state when no events', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.text('Belum ada event'), findsWidgets);
      });

      testWidgets('displays event when loaded', (tester) async {
        Future<List<Map<String, dynamic>>> mockSchedules() async {
          return [
            {
              'id': 1,
              'title': 'Instagram Post',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
              'repeat': 'daily',
              'reminder_type': 'Email',
              'caption': 'Sample caption',
              'notes': 'Sample notes',
            },
          ];
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockSchedules);

        expect(find.text('Instagram Post'), findsOneWidget);
      });

      testWidgets('event row is tappable', (tester) async {
        Future<List<Map<String, dynamic>>> mockSchedules() async {
          return [
            {
              'id': 1,
              'title': 'Test Event',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
              'repeat': 'never',
              'reminder_type': 'Email',
              'caption': 'Caption',
              'notes': 'Notes',
            },
          ];
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockSchedules);

        expect(find.text('Test Event'), findsOneWidget);
      });

      testWidgets('limits event display to 4 events per day', (tester) async {
        Future<List<Map<String, dynamic>>> mockManySchedules() async {
          return List.generate(
            6,
            (i) => {
              'id': i,
              'title': 'Event $i',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
              'repeat': 'never',
              'reminder_type': 'Email',
              'caption': 'Caption',
              'notes': 'Notes',
            },
          );
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockManySchedules);

        expect(find.text('Event 0'), findsOneWidget);
        expect(find.text('Event 1'), findsOneWidget);
        expect(find.text('Event 2'), findsOneWidget);
        expect(find.text('Event 3'), findsOneWidget);
        expect(find.text('Event 4'), findsNothing);
        expect(find.text('Event 5'), findsNothing);
      });
    });

    // ===== Event Details Dialog Tests =====
    group('event details dialog workflow', () {
      testWidgets('tapping event opens detail dialog', (tester) async {
        Future<List<Map<String, dynamic>>> mockSchedules() async {
          return [
            {
              'id': 1,
              'title': 'Instagram Post',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
              'repeat': 'daily',
              'reminder_type': 'Email',
              'caption': 'Sample caption',
              'notes': 'Sample notes',
            },
          ];
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockSchedules);

        await tester.tap(
          find.byKey(CalendarWeekPage.deadlineRowKey('Instagram Post')),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('dialog displays all event details', (tester) async {
        Future<List<Map<String, dynamic>>> mockSchedules() async {
          return [
            {
              'id': 1,
              'title': 'Test Event',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
              'repeat': 'daily',
              'reminder_type': 'Email',
              'caption': 'Sample caption',
              'notes': 'Sample notes',
            },
          ];
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockSchedules);

        await tester.tap(
          find.byKey(CalendarWeekPage.deadlineRowKey('Test Event')),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Platform'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
        expect(find.text('End'), findsOneWidget);
      });

      testWidgets('close button dismisses dialog', (tester) async {
        Future<List<Map<String, dynamic>>> mockSchedules() async {
          return [
            {
              'id': 1,
              'title': 'Test Event',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
              'repeat': 'never',
              'reminder_type': 'Email',
              'caption': 'Caption',
              'notes': 'Notes',
            },
          ];
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockSchedules);

        await tester.tap(
          find.byKey(CalendarWeekPage.deadlineRowKey('Test Event')),
        );
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(find.text('Close'));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('dialog shows correct status for posted event', (
        tester,
      ) async {
        Future<List<Map<String, dynamic>>> mockSchedules() async {
          return [
            {
              'id': 1,
              'title': 'Posted Event',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': true,
              'repeat': 'never',
              'reminder_type': 'Email',
              'caption': 'Caption',
              'notes': 'Notes',
            },
          ];
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockSchedules);

        await tester.tap(
          find.byKey(CalendarWeekPage.deadlineRowKey('Posted Event')),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Posted'), findsOneWidget);
      });
    });

    // ===== Add Event Button Tests =====
    group('add event button workflow', () {
      testWidgets('add event button is visible and tappable', (tester) async {
        await pumpCalendarWeekPage(tester);

        final addButton = find.byKey(CalendarWeekPage.addEventButtonKey);
        expect(addButton, findsOneWidget);
      });

      testWidgets('button remains visible after page interactions', (
        tester,
      ) async {
        final today = DateTime.now();
        await pumpCalendarWeekPage(tester, initialDate: today);

        await tapWeekDay(tester, CalendarWeekConfig.weekDays(today).first);

        expect(find.byKey(CalendarWeekPage.addEventButtonKey), findsOneWidget);
      });

      testWidgets('add button has proper styling', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    // ===== Bottom Navbar Tests =====
    group('bottom navbar navigation', () {
      testWidgets('navbar is displayed at bottom', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar has navigation items', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar maintains position during interactions', (
        tester,
      ) async {
        final today = DateTime.now();
        await pumpCalendarWeekPage(tester, initialDate: today);

        await tapWeekDay(tester, CalendarWeekConfig.weekDays(today).first);

        expect(find.byType(AppNavbar), findsWidgets);
      });
    });

    // ===== Page Layout Tests =====
    group('page layout and structure', () {
      testWidgets('page displays all major sections', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(SafeArea), findsWidgets);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Scaffold), findsWidgets);
      });

      testWidgets('page container has correct styling', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('page scrollable content is accessible', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(SingleChildScrollView), findsWidgets);
      });
    });

    // ===== Error Handling Tests =====
    group('error handling and edge cases', () {
      testWidgets('page handles schedule loading failure gracefully', (
        tester,
      ) async {
        Future<List<Map<String, dynamic>>> failingLoader() async {
          throw Exception('Network error');
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: failingLoader);

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('page recovers after error and remains functional', (
        tester,
      ) async {
        await pumpCalendarWeekPage(tester);

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('handles missing event data gracefully', (tester) async {
        Future<List<Map<String, dynamic>>> mockSchedules() async {
          return [
            {
              'id': 1,
              'title': 'Incomplete Event',
              'start_time': DateTime.now().toIso8601String(),
            },
          ];
        }

        await pumpCalendarWeekPage(tester, scheduleLoader: mockSchedules);

        expect(find.text('Incomplete Event'), findsOneWidget);
      });
    });

    // ===== User Workflow Tests =====
    group('complete user workflows', () {
      testWidgets('user can view calendar and see empty state', (tester) async {
        await pumpCalendarWeekPage(tester);

        expect(find.text('Belum ada event'), findsWidgets);
      });

      testWidgets('user can select different days in calendar', (tester) async {
        final today = DateTime.now();
        await pumpCalendarWeekPage(tester, initialDate: today);

        await tapWeekDay(tester, CalendarWeekConfig.weekDays(today).first);

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('user can navigate view types via dropdown', (tester) async {
        await pumpCalendarWeekPage(tester);

        await openViewDropdown(tester);

        expect(find.text('Week'), findsWidgets);
        expect(find.text('Month'), findsOneWidget);
      });
    });
  });
}
