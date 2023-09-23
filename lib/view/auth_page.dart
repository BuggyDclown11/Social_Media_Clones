import 'dart:io';

import 'package:fireapp/common/show_snackbar.dart';
import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/provider/auth_provider.dart';
import 'package:fireapp/provider/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerWidget {
  final mailController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ref) {
    ref.listen(authProvider, (previous, next) {
      if (next.isError) {
        ShowSnack.showErrorSnack(context, next.errText);
      } else if (next.isSuccess) {
        ShowSnack.showSuccessSnack(context, 'success');
      }
    });
    final image = ref.watch(imageProvider);
    final auth = ref.watch(authProvider);
    final isLogin = ref.watch(loginProvider);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
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
                  InkWell(
                    onTap: () {
                      ref.read(imageProvider.notifier).pickUImage(true);
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: image == null
                          ? Center(child: Text('Please insert an image'))
                          : Image.file(File(image.path)),
                    ),
                  ),
                gapH20,
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 9)),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _form.currentState!.save();
                      if (_form.currentState!.validate()) {
                        // print(passController.text.replaceAll(' ', ''));
                        if (isLogin) {
                          ref.read(authProvider.notifier).userLogin(
                              email: mailController.text.trim(),
                              password: passController.text.trim());
                        }
                      }
                    },
                    child: auth.isLoad
                        ? Center(child: CircularProgressIndicator())
                        : Text(isLogin ? 'Login' : 'Signup')),
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
                          child: Center(
                              child: Text(isLogin ? 'Sign Up' : 'Login')))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
