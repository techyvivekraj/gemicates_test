import 'package:flutter/material.dart';
import 'package:gemicates/utils/constants.dart';
import 'package:gemicates/views/common/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/validators.dart';
import '../product/product_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordInvisible = true;
  bool isLoading = false;

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        await Provider.of<UserProvider>(context, listen: false)
            .signIn(_emailController.text, _passwordController.text);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ProductPage()),
            (route) => false);

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: $e'),
        ));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      validator: Validators.validateEmail,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          hintText: "Email ID "),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: passwordInvisible,
                      validator: Validators.validatePassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordInvisible = !passwordInvisible;
                                });
                              },
                              icon: passwordInvisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          enabledBorder: const OutlineInputBorder(),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(),
                          hintText: "Password"),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading) const Positioned(child: Loader()),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !isLoading,
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                isLoading ? null : _login();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConst.primary,
                  foregroundColor: ColorsConst.white),
              child: isLoading ? const Loader() : const Text("Login"),
            ),
          ),
        ),
      ),
    );
  }
}
