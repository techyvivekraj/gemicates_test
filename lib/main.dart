import 'package:flutter/material.dart';
import 'package:gemicates/views/auth/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/product_provider.dart';
import 'views/auth/login_page.dart';
import 'views/product/product_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return userProvider.user == null
                ? const SignUpPage()
                : const ProductPage();
          },
        ),
      ),
    );
  }
}
