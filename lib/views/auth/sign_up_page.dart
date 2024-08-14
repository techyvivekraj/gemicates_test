import 'package:flutter/material.dart';
import 'package:gemicates/utils/constants.dart';
import 'package:gemicates/views/auth/login_page.dart';
import 'package:gemicates/views/common/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/validators.dart';
import '../product/product_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool passwordInvisible = true;

  void _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          isLoading = true;
        });
        await Provider.of<UserProvider>(context, listen: false).signUp(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ProductPage()),
            (route) => false);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign-up failed: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        enabledBorder: OutlineInputBorder(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      validator: Validators.validateName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      validator: Validators.validateEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: const OutlineInputBorder(),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordInvisible = !passwordInvisible;
                              });
                            },
                            icon: passwordInvisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility)),
                      ),
                      obscureText: true,
                      validator: Validators.validatePassword,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "Click here to Login",
                        style: TextStyle(
                          color: ColorsConst.primary,
                        ),
                      )),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: _signUp,
                  //   child: const Text('Sign Up'),
                  // ),
                ],
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
                isLoading ? null : _signUp();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConst.primary,
                  foregroundColor: ColorsConst.white),
              child: isLoading ? const Loader() : const Text("Sign Up"),
            ),
          ),
        ),
      ),
    );
  }
}
