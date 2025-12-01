import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_6/core/routes/app_routes.dart';
import 'package:task_6/feature/presentation/home_page.dart';
import 'package:task_6/feature/presentation/add_update_page.dart';
import 'package:task_6/feature/presentation/details_page.dart';
import 'package:task_6/feature/domain/product.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('HomePage - listing produits', () {
    testWidgets(
      'displays the initial list of products',
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            const MaterialApp(
              home: HomePage(),
            ),
          );

          await tester.pumpAndSettle();

          // All the initial products have the same title: 'Derby Leather Shoes'
          expect(find.text('Derby Leather Shoes'), findsNWidgets(6));

          expect(find.text('Available Products'), findsOneWidget);
        });
      },
    );

    testWidgets(
      'HomePage - listing products adds a new product to the list after AddUpdatePage returns',
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            MaterialApp(
              routes: {
                '/': (_) => const HomePage(),
                AppRoutes.addUpdate: (_) => const AddUpdatePage(),
                AppRoutes.details: (ctx) {
                  final product =
                      ModalRoute.of(ctx)!.settings.arguments as Product;
                  return DetailsPage(product: product);
                },
              },
            ),
          );

          await tester.pumpAndSettle();

          // Check that the new product does not already exist
          expect(find.text('New Test Shoe'), findsNothing);

          // Press the FloatingActionButton to open AddUpdatePage
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          // We fill in the fields on AddUpdatePage
          final nameField = find.byType(TextField).at(0);
          final categoryField = find.byType(TextField).at(1);
          final priceField = find.byType(TextField).at(2);
          final descriptionField = find.byType(TextField).at(3);

          await tester.enterText(nameField, 'New Test Shoe');
          await tester.enterText(categoryField, 'Sneakers');
          await tester.enterText(priceField, '150');
          await tester.enterText(descriptionField, 'A very nice sneaker');

          final addButton = find.text('ADD');

          // Scroll until the button is in the visible area
          await tester.ensureVisible(addButton);
          await tester.pumpAndSettle();

          // Now we can press it
          await tester.tap(addButton);
          await tester.pumpAndSettle();

          // Back on the HomePage, the new product should be displayed
          expect(find.text('New Test Shoe'), findsOneWidget);
        });
      },
    );
  });
}