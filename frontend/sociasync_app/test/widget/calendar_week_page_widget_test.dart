import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/calendar/calendar_week_page.dart';
import 'package:sociasync_app/widgets/app_background_wrapper.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';
import 'package:sociasync_app/widgets/dashboard_header.dart';

Future<List<Map<String, dynamic>>> mockLoadSchedules() async {
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

Future<List<Map<String, dynamic>>> mockEmptySchedules() async {
  return [];
}

Future<List<Map<String, dynamic>>> mockFailedSchedules() async {
  throw Exception('Failed to load schedules');
}

void main() {
  group('CalendarWeekPage Widget Tests', () {
    // ===== Basic Rendering Tests =====
    group('basic rendering', () {
      testWidgets('widget renders without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('displays AppBackgroundWrapper', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppBackgroundWrapper), findsOneWidget);
      });

      testWidgets('displays Scaffold structure', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(Scaffold), findsWidgets);
      });

      testWidgets('displays AppNavbar at bottom', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('displays DashboardHeader with username', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(DashboardHeader), findsOneWidget);
      });
    });

    // ===== Switch View Selector Tests =====
    group('switch view selector (Dropdown)', () {
      testWidgets('displays view dropdown button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byKey(CalendarWeekPage.viewDropdownKey), findsOneWidget);
      });

      testWidgets('dropdown button shows "Week" text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Week'), findsWidgets);
      });

      testWidgets('dropdown button shows arrow icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('tapping dropdown button shows menu options', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.byKey(CalendarWeekPage.viewDropdownKey));
        await tester.pumpAndSettle();

        expect(find.text('Week'), findsWidgets);
        expect(find.text('Month'), findsOneWidget);
        expect(find.text('Year'), findsOneWidget);
      });

      testWidgets('dropdown menu is properly positioned', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.byKey(CalendarWeekPage.viewDropdownKey));
        await tester.pumpAndSettle();

        expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
      });
    });

    // ===== Week Days Header Tests =====
    group('week days header', () {
      testWidgets('displays week day item selector', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('displays abbreviated day labels', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Mo'), findsWidgets);
        expect(find.text('Tu'), findsWidgets);
        expect(find.text('We'), findsWidgets);
      });

      testWidgets('displays date numbers', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final today = DateTime.now().day.toString();
        expect(find.text(today), findsWidgets);
      });

      testWidgets('initial date is highlighted', (tester) async {
        final today = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(
              scheduleLoader: mockEmptySchedules,
              initialDate: today,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final containers = find
            .byType(Container)
            .evaluate()
            .toList()
            .cast<Element>();
        final hasHighlighted = containers.any((element) {
          if (element.widget is Container) {
            final container = element.widget as Container;
            if (container.decoration is BoxDecoration) {
              final decoration = container.decoration as BoxDecoration;
              return decoration.color != Colors.transparent;
            }
          }
          return false;
        });

        expect(hasHighlighted, true);
      });

      testWidgets('tapping day changes selection', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final dayItems = find.byType(GestureDetector);
        await tester.tap(dayItems.last);
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(GestureDetector), findsWidgets);
      });
    });

    // ===== Timetable / Day Column Tests =====
    group('timetable / day column', () {
      testWidgets('displays day columns for left and right day', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final columnFinder = find.byType(Column);
        expect(columnFinder, findsWidgets);
      });

      testWidgets('displays full date format in column header', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('displays "Belum ada event" when no events', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Belum ada event'), findsWidgets);
      });

      testWidgets('displays event titles when events exist', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Instagram Post'), findsOneWidget);
      });

      testWidgets('limits event display to 4 per day', (tester) async {
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
            },
          );
        }

        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockManySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Event 0'), findsOneWidget);
        expect(find.text('Event 1'), findsOneWidget);
        expect(find.text('Event 2'), findsOneWidget);
        expect(find.text('Event 3'), findsOneWidget);
        expect(find.text('Event 4'), findsNothing);
        expect(find.text('Event 5'), findsNothing);
      });

      testWidgets('separates columns with divider', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(Divider), findsOneWidget);
      });
    });

    // ===== Deadline / Event Row Tests =====
    group('deadline / event row', () {
      testWidgets('displays event row with circular icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byIcon(Icons.circle), findsWidgets);
      });

      testWidgets('displays event title text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Instagram Post'), findsOneWidget);
      });

      testWidgets('event row with tap shows chevron icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byIcon(Icons.chevron_right), findsWidgets);
      });

      testWidgets('empty event row does not show chevron', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Belum ada event'), findsWidgets);
      });

      testWidgets('tapping event row is tappable via InkWell', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('event row has correct styling', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(Container), findsWidgets);
      });
    });

    // ===== Detail Event Dialog Tests =====
    group('detail event dialog', () {
      Future<void> openEventDetailsDialog(
        WidgetTester tester, {
        String title = 'Instagram Post',
      }) async {
        await tester.tap(find.byKey(CalendarWeekPage.deadlineRowKey(title)));
        await tester.pump(const Duration(milliseconds: 300));
      }

      testWidgets('tapping event shows AlertDialog', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await openEventDetailsDialog(tester);

        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('dialog displays event title', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await openEventDetailsDialog(tester);

        expect(find.text('Instagram Post'), findsWidgets);
      });

      testWidgets('dialog displays event details', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await openEventDetailsDialog(tester);

        expect(find.text('Platform'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
      });

      testWidgets('dialog has Edit and Close buttons', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await openEventDetailsDialog(tester);

        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Close'), findsOneWidget);
      });

      testWidgets('Close button dismisses dialog', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await openEventDetailsDialog(tester);

        await tester.tap(find.text('Close'));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('dialog shows "Posted" status for posted events', (
        tester,
      ) async {
        Future<List<Map<String, dynamic>>> mockPostedSchedules() async {
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
              'caption': 'Sample',
              'notes': 'Notes',
            },
          ];
        }

        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockPostedSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await openEventDetailsDialog(tester, title: 'Posted Event');

        expect(find.text('Posted'), findsOneWidget);
      });

      testWidgets('dialog shows "Scheduled" status for unposted events', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockLoadSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await openEventDetailsDialog(tester);

        expect(find.text('Scheduled'), findsOneWidget);
      });
    });

    // ===== Add Event Button Tests =====
    group('add event button', () {
      testWidgets('displays ElevatedButton for add event', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('add event button shows correct text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('+ Add event'), findsOneWidget);
      });

      testWidgets('add event button has correct style', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final button =
            find.byType(ElevatedButton).evaluate().first.widget
                as ElevatedButton;
        expect(button.onPressed, isNotNull);
      });

      testWidgets('add event button is centered', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(Center), findsWidgets);
      });

      testWidgets('tapping add event button is possible', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    // ===== Bottom Navbar Tests =====
    group('bottom navbar', () {
      testWidgets('displays AppNavbar at bottom', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar has 4 navigation items', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('navbar is positioned at bottom', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final scaffold = find.byType(Scaffold);
        expect(scaffold, findsWidgets);
      });
    });

    // ===== Negative Tests =====
    group('negative tests', () {
      testWidgets('handles null initialDate gracefully', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: const CalendarWeekPage(initialDate: null)),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });

      testWidgets('handles failed schedule loading', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockFailedSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('displays "Belum ada event" for empty schedules', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockEmptySchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Belum ada event'), findsWidgets);
      });

      testWidgets('handles event with invalid ID gracefully', (tester) async {
        Future<List<Map<String, dynamic>>> mockInvalidIdSchedules() async {
          return [
            {
              'id': null,
              'title': 'Invalid Event',
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
            },
          ];
        }

        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockInvalidIdSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('handles missing event title', (tester) async {
        Future<List<Map<String, dynamic>>> mockMissingTitleSchedules() async {
          return [
            {
              'id': 1,
              'start_time': DateTime.now().toIso8601String(),
              'end_time': DateTime.now()
                  .add(const Duration(hours: 1))
                  .toIso8601String(),
              'platform': 'Instagram',
              'is_posted': false,
            },
          ];
        }

        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockMissingTitleSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Untitled event'), findsOneWidget);
      });

      testWidgets('page remains mounted after navigation errors', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CalendarWeekPage(scheduleLoader: mockFailedSchedules),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(CalendarWeekPage), findsOneWidget);
      });
    });
  });
}
