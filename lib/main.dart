import 'package:app_manager/providers/product/product_cubit.dart';
import 'package:app_manager/repositories/product_repository.dart';
import 'package:app_manager/screens/auth/enter_email_screen.dart';
import 'package:app_manager/screens/auth/login_screen.dart';
import 'package:app_manager/screens/auth/register_screen.dart';
import 'package:app_manager/screens/home_screen.dart';
import 'package:app_manager/screens/product/product_screen.dart';
import 'package:app_manager/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit(ProductRepository())),
      ],
      child: MaterialApp(
        title: 'App Manager',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/forgot_password': (context) => EnterEmailScreen(),
          '/home': (context) => HomeScreen(),
          '/product': (context) => ProductScreen(),
        },
      ),
    );
  }
}
