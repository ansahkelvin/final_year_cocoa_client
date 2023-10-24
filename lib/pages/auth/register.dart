import 'package:cocoa_project/pages/auth/login.dart';
import 'package:cocoa_project/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final globalKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isLoading = false;

  Future<void> validateAndRegister(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    if (globalKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await provider.registerUser(
            emailController.text, passwordController.text, nameController.text);
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Join Us",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Enter your credentials to continue",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: SvgPicture.asset(
                    "assets/undraw_sign_up_n6im.svg",
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                isLoading
                    ? const ProgressDialog(message: "registering")
                    : Form(
                        key: globalKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: nameController,
                              validator: (value) =>
                                  value!.length < 6 ? "Enter valid name" : null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                hintText: "Full name",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: emailController,
                              validator: (value) =>
                                  value!.length < 6 || !value.contains("@")
                                      ? "Invalid email"
                                      : null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: "Email",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              validator: (value) => value!.length < 6
                                  ? "Password must be more than 6 characters"
                                  : null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock_outline),
                                hintText: "Password",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                    "By creating an account with us you agree with our terms and conditions"),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50)),
                              onPressed: () {
                                validateAndRegister(context);
                              },
                              child: const Text("Register"),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text("Already having an account? Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
