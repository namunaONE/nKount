import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nkount/features/app/commands.dart';

void main() {
  testWidgets('command palette lists commands and filters by query',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showCommandPalette(context),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // All 9 commands visible initially.
    expect(find.text('New Sale'), findsOneWidget);
    expect(find.text('Settings', skipOffstage: false), findsOneWidget);

    // Filter narrows the list.
    await tester.enterText(find.byType(TextField), 'set');
    await tester.pump();
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('New Sale'), findsNothing);
  });

  test('registry exposes navigation commands', () {
    final titles = appCommands().map((c) => c.title).toList();
    expect(
      titles,
      containsAll(
          ['Dashboard', 'New Sale', 'New Purchase', 'Reports', 'Settings']),
    );
  });
}
