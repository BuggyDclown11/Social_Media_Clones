import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/provider/login-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerWidget {
  final mailController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ref) {
    final isLogin = ref.watch(loginProvider);
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  isLogin ? 'User Login' : 'User Register',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              gapH10,
              if (!isLogin)
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'Your name',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                ),
              gapH10,
              TextFormField(
                controller: mailController,
                decoration: InputDecoration(
                    hintText: 'your email',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              ),
              gapH10,
              TextFormField(
                controller: passController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'password',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              ),
              gapH10,
              if (!isLogin)
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('Please insert an image')),
                ),
              gapH20,
              ElevatedButton(
                  onPressed: () {
                    _form.currentState!.save();
                    if (_form.currentState!.validate()) {
                      print(passController.text.replaceAll(' ', ''));
                    }
                  },
                  child: Text(isLogin ? 'Login' : 'Signup')),
              gapH20,
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(isLogin
                          ? 'don\'t have an Account?'
                          : 'Already have an Account'),
                    ),
                    TextButton(
                        onPressed: () {
                          ref.read(loginProvider.notifier).toggle();
                        },
                        child:
                            Center(child: Text(isLogin ? 'Sign Up' : 'Login')))
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
