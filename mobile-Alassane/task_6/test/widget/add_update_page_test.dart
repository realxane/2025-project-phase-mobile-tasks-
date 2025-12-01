import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_6/feature/presentation/add_update_page.dart';

void main() {
  group('AddUpdatePage - product creation', () {
    testWidgets(
      'Displays an error if the title and description are empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AddUpdatePage(), // "add" mode
          ),
        );

        // The button is called "ADD" when product == null
        final addButton = find.text('ADD');

        await tester.ensureVisible(addButton);
        await tester.pumpAndSettle();
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        expect(
          find.text('Title and description are required'),
          findsOneWidget,
        );
      },
    );
    testWidgets(
      'Closes the page when the entered data is valid',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddUpdatePage(),
                          ),
                        );
                      },
                      child: const Text('Open Add'),
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // We open AddUpdatePage
        await tester.tap(find.text('Open Add'));
        await tester.pumpAndSettle();

        // The TextFields are in the following order: name, category, price, description
        final nameField = find.byType(TextField).at(0);
        final categoryField = find.byType(TextField).at(1);
        final priceField = find.byType(TextField).at(2);
        final descriptionField = find.byType(TextField).at(3);

        await tester.enterText(nameField, 'Test Shoe');
        await tester.enterText(categoryField, 'Test Category');
        await tester.enterText(priceField, '99');
        await tester.enterText(descriptionField, 'Nice shoe');

        final addButton = find.text('ADD');

        await tester.ensureVisible(addButton);
        await tester.pumpAndSettle();
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        // If we've returned to the original page,
        // the "Open Add" button should be visible again
        expect(find.text('Open Add'), findsOneWidget);
      },
    );
  });
}