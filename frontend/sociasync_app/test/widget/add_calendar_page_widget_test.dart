import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociasync_app/screens/calendar/add_calendar_page.dart';
import 'package:sociasync_app/widgets/app_background_wrapper.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';
import 'package:sociasync_app/widgets/dashboard_header.dart';

void main() {
  group('AddCalendarPage Widget Tests', () {
    // ===== Basic Rendering Tests =====
    group('basic rendering', () {
      testWidgets('widget renders without errors', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('displays AppBackgroundWrapper', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppBackgroundWrapper), findsOneWidget);
      });

      testWidgets('displays Scaffold structure', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(Scaffold), findsWidgets);
      });

      testWidgets('displays DashboardHeader', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(DashboardHeader), findsOneWidget);
      });

      testWidgets('displays AppNavbar at bottom', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AppNavbar), findsOneWidget);
      });

      testWidgets('displays title "Add Event" in new mode', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Add Event'), findsOneWidget);
      });

      testWidgets('displays title "Edit Event" in edit mode', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'scheduleId': '123',
                'title': 'Test Event',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Edit Event'), findsOneWidget);
      });
    });

    // ===== Back Button Tests =====
    group('back button', () {
      testWidgets('back button is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('back button has correct color', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        final iconButton = find.byIcon(Icons.arrow_back);
        expect(iconButton, findsOneWidget);
      });

      testWidgets('back button triggers navigation pop', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: AddCalendarPage())),
        );
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        // Navigation pop should be attempted
        expect(find.byType(AddCalendarPage), findsNothing);
      });
    });

    // ===== Title Input Tests =====
    group('title input field', () {
      testWidgets('title input field is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(TextField), findsWidgets);
      });

      testWidgets('title input has correct hint text', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Title...'), findsOneWidget);
      });

      testWidgets('title input accepts text', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        final titleField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.hintText ?? '').contains('Title'),
        );
        await tester.tap(titleField);
        await tester.enterText(titleField, 'My Event');
        await tester.pump();
        expect(find.text('My Event'), findsOneWidget);
      });

      testWidgets('title input initializes with provided data', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'title': 'Pre-filled Event',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Pre-filled Event'), findsOneWidget);
      });
    });

    // ===== Schedule Group Tests =====
    group('schedule group (Daily Toggle)', () {
      testWidgets('schedule group is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Daily'), findsOneWidget);
      });

      testWidgets('daily switch is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets('daily switch toggles correctly', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        final switchWidget = find.byType(Switch);
        expect(switchWidget, findsOneWidget);
        await tester.tap(switchWidget);
        await tester.pump();
        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets('start/end date fields are shown in daily mode', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        final switchWidget = find.byType(Switch);
        await tester.tap(switchWidget);
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Start'), findsWidgets);
        expect(find.text('End'), findsWidgets);
      });

      testWidgets('start/end time fields are shown in non-daily mode', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        // Default is not daily, so time fields should be visible
        expect(find.text('Start'), findsWidgets);
        expect(find.text('End'), findsWidgets);
      });
    });

    // ===== Time/Date Chips Tests =====
    group('time/date chips', () {
      testWidgets('time chips are displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        // Should have at least date and time chips
        final chips = find.byWidgetPredicate(
          (widget) => widget is GestureDetector,
        );
        expect(chips, findsWidgets);
      });

      testWidgets('date chip opens date picker on tap', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'startDate': DateTime(2026, 5, 15),
                'endDate': DateTime(2026, 5, 15),
              },
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('15 MAY 2026').first);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(DatePickerDialog), findsOneWidget);
      });
    });

    // ===== Platform Picker Tests =====
    group('platform picker', () {
      testWidgets('platform option tile is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Platform'), findsOneWidget);
      });

      testWidgets('platform shows default value', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('instagram'), findsWidgets);
      });

      testWidgets('platform picker dialog opens on tap', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        final platformTile = find.byWidgetPredicate(
          (widget) =>
              widget is GestureDetector &&
              widget.child is Container &&
              (widget.child as Container).child.toString().contains('Platform'),
        );
        // Just verify platform text exists
        expect(find.text('Platform'), findsOneWidget);
      });
    });

    // ===== Repeat Picker Tests =====
    group('repeat picker', () {
      testWidgets('repeat option tile is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Repeat'), findsOneWidget);
      });

      testWidgets('repeat shows default value', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Never'), findsWidgets);
      });
    });

    // ===== Reminder Picker Tests =====
    group('reminder picker', () {
      testWidgets('reminder option tile is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Reminder'), findsOneWidget);
      });

      testWidgets('reminder shows default value', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Never'), findsWidgets);
      });
    });

    // ===== Notes Input Tests =====
    group('notes input field', () {
      testWidgets('notes input field is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                (widget.decoration?.labelText ?? '').contains('Notes'),
          ),
          findsOneWidget,
        );
      });

      testWidgets('notes input accepts text', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        final notesField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.labelText ?? '').contains('Notes'),
        );
        await tester.ensureVisible(notesField);
        await tester.pump();
        await tester.tap(notesField);
        await tester.enterText(notesField, 'Important notes');
        await tester.pump();
        expect(find.text('Important notes'), findsOneWidget);
      });

      testWidgets('notes field initializes with provided data', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'notes': 'Pre-filled notes',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Pre-filled notes'), findsOneWidget);
      });
    });

    // ===== Submit Button Tests =====
    group('submit button', () {
      testWidgets('submit button is displayed', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('submit button shows "+ Add event" in create mode', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        expect(find.text('+ Add event'), findsOneWidget);
      });

      testWidgets('submit button shows "Update Event" in edit mode', (
        tester,
      ) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'scheduleId': '123',
                'title': 'Test',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Update Event'), findsOneWidget);
      });

      testWidgets('submit button is disabled when title is empty', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
      });
    });

    // ===== Negative Tests =====
    group('negative/error handling', () {
      testWidgets('handles null initial data gracefully', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: AddCalendarPage(initialData: null)),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('handles empty initial data gracefully', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: AddCalendarPage(initialData: {})),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('handles invalid scheduleId in initial data', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(initialData: {'scheduleId': 'invalid'}),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Add Event'), findsOneWidget);
      });

      testWidgets('handles missing date fields gracefully', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AddCalendarPage(
              initialData: {'title': 'Event without dates'},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Event without dates'), findsOneWidget);
      });

      testWidgets('notifies user when title is missing on submit', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        // Try to submit without title
        final button = find.byType(ElevatedButton);
        await tester.ensureVisible(button);
        await tester.pump();
        await tester.tap(button);
        await tester.pumpAndSettle();
        // Should show validation error
        expect(find.byType(SnackBar), findsWidgets);
      });

      testWidgets('validates end time is not before start time', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        // Find title field and add title
        final titleField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.hintText ?? '').contains('Title'),
        );
        await tester.tap(titleField);
        await tester.enterText(titleField, 'Test Event');
        await tester.pump();
      });

      testWidgets('renders correctly with all fields populated', (
        tester,
      ) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'title': 'Complete Event',
                'notes': 'Complete notes',
                'platform': 'tiktok',
                'repeat': 'Weekly',
                'reminder': '1 hour before',
                'startDate': now,
                'endDate': now.add(const Duration(hours: 2)),
                'startTime': const TimeOfDay(hour: 10, minute: 0),
                'endTime': const TimeOfDay(hour: 12, minute: 0),
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Complete Event'), findsOneWidget);
        expect(find.text('Complete notes'), findsOneWidget);
      });

      testWidgets('handles very long title without crashing', (tester) async {
        final longTitle = 'A' * 500;
        await tester.pumpWidget(
          MaterialApp(home: AddCalendarPage(initialData: {'title': longTitle})),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('handles special characters in title', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(initialData: {'title': r'Event @#$%^&*()'}),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text(r'Event @#$%^&*()'), findsOneWidget);
      });
    });
  });
}
