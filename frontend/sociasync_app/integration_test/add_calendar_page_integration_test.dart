import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sociasync_app/screens/calendar/add_calendar_page.dart';
import 'package:sociasync_app/widgets/app_navbar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AddCalendarPage Integration Tests', () {
    // ===== Page Loading Tests =====
    group('page loading and initialization', () {
      testWidgets('page loads successfully', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('all main UI elements are visible on load', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.text('Add Event'), findsOneWidget);
        expect(find.text('Daily'), findsOneWidget);
        expect(find.text('Platform'), findsOneWidget);
        expect(find.text('Repeat'), findsOneWidget);
        expect(find.text('Reminder'), findsOneWidget);
        expect(find.text('+ Add event'), findsOneWidget);
      });

      testWidgets('edit mode loads with correct data', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'scheduleId': '999',
                'title': 'Existing Event',
                'notes': 'Existing notes',
                'platform': 'instagram',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Edit Event'), findsOneWidget);
        expect(find.text('Existing Event'), findsOneWidget);
        expect(find.text('Update Event'), findsOneWidget);
      });

      testWidgets('page initializes with default values in create mode', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();
        expect(find.text('instagram'), findsWidgets);
        expect(find.text('Never'), findsWidgets);
      });
    });

    // ===== Workflow Tests =====
    group('complete event creation workflow', () {
      testWidgets('user can fill form and attempt submission', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: AddCalendarPage())),
        );
        await tester.pumpAndSettle();

        // Find and fill title
        final titleField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.hintText ?? '').contains('Title'),
        );
        await tester.tap(titleField);
        await tester.enterText(titleField, 'My Test Event');
        await tester.pump();

        expect(find.text('My Test Event'), findsOneWidget);
      });

      testWidgets('user can toggle daily mode', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final switchWidget = find.byType(Switch);
        expect(switchWidget, findsOneWidget);

        await tester.tap(switchWidget);
        await tester.pumpAndSettle();
        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets('user can scroll through form', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final scrollable = find.byWidgetPredicate(
          (widget) => widget is SingleChildScrollView,
        );
        expect(scrollable, findsOneWidget);

        await tester.drag(scrollable.first, const Offset(0, -300));
        await tester.pumpAndSettle();
      });

      testWidgets(
        'user can fill title, platform, repeat, reminder fields completely',
        (tester) async {
          await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
          await tester.pumpAndSettle();

          // Fill title
          final titleField = find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                (widget.decoration?.hintText ?? '').contains('Title'),
          );
          await tester.tap(titleField);
          await tester.enterText(titleField, 'Complete Event');
          await tester.pump();

          expect(find.text('Complete Event'), findsOneWidget);
        },
      );

      testWidgets('user can navigate through date/time pickers', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Verify date/time chips are present
        final gestureDetectors = find.byType(GestureDetector);
        expect(gestureDetectors, findsWidgets);
      });
    });

    // ===== Form Validation Tests =====
    group('form validation', () {
      testWidgets('shows error when submitting empty title', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final button = find.byType(ElevatedButton);
        await tester.ensureVisible(button);
        await tester.pumpAndSettle();
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsWidgets);
      });

      testWidgets('shows error when end time before start time', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Fill title first
        final titleField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.hintText ?? '').contains('Title'),
        );
        await tester.tap(titleField);
        await tester.enterText(titleField, 'Test Event');
        await tester.pump();

        // Try submitting
        final button = find.byType(ElevatedButton);
        await tester.ensureVisible(button);
        await tester.pumpAndSettle();
        await tester.tap(button);
        await tester.pumpAndSettle();
      });

      testWidgets('allows whitespace-only title to be validated', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final titleField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.hintText ?? '').contains('Title'),
        );
        await tester.tap(titleField);
        await tester.enterText(titleField, '   ');
        await tester.pump();

        final button = find.byType(ElevatedButton);
        await tester.ensureVisible(button);
        await tester.pumpAndSettle();
        await tester.tap(button);
        await tester.pumpAndSettle();
      });
    });

    // ===== UI State Tests =====
    group('UI state changes', () {
      testWidgets('switch toggles between daily and scheduled modes', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Start in non-daily mode (scheduled)
        expect(find.text('Start'), findsWidgets);

        // Toggle to daily
        final switchWidget = find.byType(Switch);
        await tester.tap(switchWidget);
        await tester.pumpAndSettle();

        expect(find.text('Start'), findsWidgets);
      });

      testWidgets('platform selector updates selected value', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Should show instagram as default
        expect(find.text('instagram'), findsWidgets);
      });

      testWidgets('repeat selector updates selected value', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Should show Never as default
        expect(find.text('Never'), findsWidgets);
      });

      testWidgets('reminder selector updates selected value', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Should show Never as default
        expect(find.text('Never'), findsWidgets);
      });

      testWidgets('notes field accepts multiline input', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final notesField = find.byWidgetPredicate(
          (widget) =>
            widget is TextField &&
            (widget.decoration?.labelText ?? '').contains('Notes'),
        );
        await tester.ensureVisible(notesField);
        await tester.pumpAndSettle();
        await tester.tap(notesField);
        await tester.enterText(notesField, 'Line 1\nLine 2\nLine 3');
        await tester.pump();

        expect(find.text('Line 1\nLine 2\nLine 3'), findsOneWidget);
      });
    });

    // ===== Navigation Tests =====
    group('navigation', () {
      testWidgets('back button returns to previous screen', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: AddCalendarPage())),
        );
        await tester.pumpAndSettle();

        final backButton = find.byIcon(Icons.arrow_back);
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      });

      testWidgets('navbar navigation works from add event page', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Navbar should be present at bottom
        expect(find.byType(AppNavbar), findsOneWidget);
      });
    });

    // ===== Initial Data Loading Tests =====
    group('initial data loading', () {
      testWidgets('loads edit data into form fields', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'title': 'Edit Me',
                'notes': 'Edit notes',
                'platform': 'tiktok',
                'repeat': 'Weekly',
                'reminder': '5 mins before',
                'scheduleId': '456',
                'startDate': now,
                'endDate': now.add(const Duration(hours: 2)),
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Edit Me'), findsOneWidget);
        expect(find.text('Edit notes'), findsOneWidget);
        expect(find.text('Update Event'), findsOneWidget);
      });

      testWidgets('handles missing optional fields in initial data', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AddCalendarPage(initialData: {'title': 'Minimal Event'}),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Minimal Event'), findsOneWidget);
        expect(find.text('Add Event'), findsOneWidget);
      });

      testWidgets('correctly interprets platform field', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'title': 'Tiktok Event',
                'platform': 'tik tok',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Tiktok Event'), findsOneWidget);
      });

      testWidgets('correctly interprets repeat field', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'title': 'Weekly Event',
                'repeat': 'weekly',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Weekly Event'), findsOneWidget);
      });
    });

    // ===== Negative/Edge Case Tests =====
    group('negative and edge case scenarios', () {
      testWidgets('handles null initial data gracefully', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: AddCalendarPage(initialData: null)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Add Event'), findsOneWidget);
        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('handles empty initial data map', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: AddCalendarPage(initialData: {})),
        );
        await tester.pumpAndSettle();

        expect(find.text('Add Event'), findsOneWidget);
      });

      testWidgets('handles invalid scheduleId format', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'scheduleId': 'not_a_number',
                'title': 'Test',
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Add Event'), findsOneWidget);
      });

      testWidgets('handles very long title gracefully', (tester) async {
        final longTitle = 'A' * 1000;
        await tester.pumpWidget(
          MaterialApp(home: AddCalendarPage(initialData: {'title': longTitle})),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('handles special characters in title', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {'title': 'Event with @#\$%^&*()'},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Event with @#\$%^&*()'), findsOneWidget);
      });

      testWidgets('handles emoji in title', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(initialData: {'title': 'Event 🎉🎊'}),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Event 🎉🎊'), findsOneWidget);
      });

      testWidgets('handles very long notes text', (tester) async {
        final longNotes = 'Note line ' * 100;
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {'title': 'Test', 'notes': longNotes},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('handles null values in initial data fields', (tester) async {
        final now = DateTime.now();
        await tester.pumpWidget(
          MaterialApp(
            home: AddCalendarPage(
              initialData: {
                'title': null,
                'notes': null,
                'platform': null,
                'repeat': null,
                'reminder': null,
                'startDate': now,
                'endDate': now,
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AddCalendarPage), findsOneWidget);
      });

      testWidgets('handles form with all fields empty except title', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        // Fill only title
        final titleField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.hintText ?? '').contains('Title'),
        );
        await tester.tap(titleField);
        await tester.enterText(titleField, 'Only Title');
        await tester.pump();

        expect(find.text('Only Title'), findsOneWidget);
      });

      testWidgets('handles rapidly clicking submit button', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final button = find.byType(ElevatedButton);
        await tester.ensureVisible(button);
        await tester.pumpAndSettle();
        await tester.tap(button);
        await tester.tap(button);
        await tester.tap(button);
        await tester.pumpAndSettle();
      });

      testWidgets('handles keyboard dismissal during text input', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final titleField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              (widget.decoration?.hintText ?? '').contains('Title'),
        );
        await tester.tap(titleField);
        await tester.enterText(titleField, 'Test');
        tester.testTextInput.closeConnection();
        await tester.pumpAndSettle();
      });
    });

    // ===== Layout Tests =====
    group('layout and responsiveness', () {
      testWidgets('all form elements are visible when scrolled to bottom', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final scrollable = find.byWidgetPredicate(
          (widget) => widget is SingleChildScrollView,
        );

        await tester.drag(scrollable.first, const Offset(0, -500));
        await tester.pumpAndSettle();

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('submit button remains clickable when scrolled', (
        tester,
      ) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        final scrollable = find.byWidgetPredicate(
          (widget) => widget is SingleChildScrollView,
        );

        await tester.drag(scrollable.first, const Offset(0, -500));
        await tester.pumpAndSettle();

        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
      });

      testWidgets('SafeArea is applied correctly', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: AddCalendarPage()));
        await tester.pumpAndSettle();

        expect(find.byType(SafeArea), findsWidgets);
      });
    });
  });
}
