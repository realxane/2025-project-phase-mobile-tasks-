import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_6/core/routes/app_routes.dart';
import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/presentation/add_update_page.dart';
import 'package:task_6/feature/presentation/bloc/product_bloc.dart';
import 'package:task_6/feature/presentation/details_page.dart';
import 'package:task_6/feature/presentation/home_page.dart';
import 'package:task_6/core/di/injection_container.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override 
  Widget build(BuildContext context) {
    final seed = const Color.fromARGB(255, 51, 140, 241);
    return BlocProvider(
      create: (_) => di.sl<ProductBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Home',
        initialRoute: AppRoutes.home, 
        routes: {
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.details: (context) {
            final product = ModalRoute.of(context)!.settings.arguments as Product;
            return DetailsPage(product: product);
          },
          AppRoutes.addUpdate: (context) {
            final product = ModalRoute.of(context)!.settings.arguments as Product?;
            return AddUpdatePage(product: product);
          },
        },
        theme: ThemeData( 
          colorScheme: ColorScheme.fromSeed(seedColor: seed),
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: const Color(0xFFF4F5F7),
          useMaterial3: true,
        ),
      ),
    );
  }
}