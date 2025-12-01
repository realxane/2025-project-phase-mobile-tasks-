import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_6/core/routes/app_routes.dart';
import 'package:task_6/feature/presentation/home_page.dart';
import 'package:task_6/feature/presentation/details_page.dart';
import 'package:task_6/feature/presentation/add_update_page.dart';
import 'package:task_6/feature/domain/product.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets(
    'Tapping the back button on DetailsPage returns you to the HomePage',
    (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: const HomePage(),
            routes: {
              AppRoutes.addUpdate: (_) => const AddUpdatePage(),
              AppRoutes.details: (context) {
                final product =
                    ModalRoute.of(context)!.settings.arguments as Product;
                return DetailsPage(product: product);
              },
            },
          ),
        );

        await tester.pumpAndSettle();

        // We open the details page by tapping on the first product
        await tester.tap(find.text('Derby Leather Shoes').first);
        await tester.pumpAndSettle();

        // We check that we are indeed on the DetailsPage
        expect(find.text('Size:'), findsOneWidget);
        expect(find.text('UPDATE'), findsOneWidget);

        // Tap the back icon
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await tester.pumpAndSettle();

        // We need to see the text of the main page again
        expect(find.text('Available Products'), findsOneWidget);
      });
    },
  );
}