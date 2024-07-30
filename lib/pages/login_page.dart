import 'package:documents_collector/api/hx_user.dart';
import 'package:documents_collector/pages/homepage.dart';
import 'package:documents_collector/providers/px_user_model.dart';
import 'package:documents_collector/widgets/central_loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36.0),
              child: CircleAvatar(
                child: Icon(Icons.person_add),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: const Text('Email Address'),
                subtitle: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Email Address.",
                  ),
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return 'Invalid Email Address';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: const Text('Password'),
                subtitle: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Password.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Password.",
                    suffix: IconButton.outlined(
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ),
                  obscureText: obscure,
                ),
              ),
            ),
            Consumer<PxUserModel>(
              builder: (context, u, _) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        BuildContext? dialogContext;
                        showDialog(
                            context: context,
                            builder: (context) {
                              dialogContext = context;
                              return const CentralLoading();
                            });
                        try {
                          await u
                              .login(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          )
                              .whenComplete(() {
                            Navigator.pop(dialogContext!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(),
                              ),
                            );
                          });
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    label: const Text('Login'),
                    icon: const Icon(Icons.login),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  BuildContext? dialogContext;
                  showDialog(
                      context: context,
                      builder: (context) {
                        dialogContext = context;
                        return const CentralLoading();
                      });
                  await HxUser.sendResetPasswordRequest(_emailController.text)
                      .whenComplete(() {
                    Navigator.pop(dialogContext!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password Reset Email Was Sent.'),
                      ),
                    );
                  });
                },
                label: const Text('Reset Password'),
                icon: const Icon(Icons.password),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
