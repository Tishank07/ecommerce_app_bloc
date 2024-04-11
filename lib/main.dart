import 'package:ecommerce_app_bloc/screens/login.dart';
import 'package:ecommerce_app_bloc/screens/product_list_screen.dart';
import 'package:ecommerce_app_bloc/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/add_to_cart_bloc/add_to_cart_bloc.dart';

// void main() => runApp(const MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers : [
        BlocProvider(create: (context) => CartBloc())
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        title: 'Ecommerce App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/':(context) => SignupPage(),
          '/login': (context) => const LoginScreen(),
          '/products': (context) => const ProductListScreen(),
        },
    
      ),
    );
  }
}