import 'dart:io';
import 'package:fireapp/common/show_snackbar.dart';
import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/provider/auth_provider.dart';
import 'package:fireapp/provider/common_provider.dart';
import 'package:fireapp/provider/crud_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class CreatePost extends ConsumerWidget {
  final titleController = TextEditingController();
  final DetailController = TextEditingController();
  //final passController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ref) {
    ref.listen(authProvider, (previous, next) {
      if (next.isError) {
        ShowSnack.showErrorSnack(context, next.errText);
      } else if (next.isSuccess) {
        ShowSnack.showSuccessSnack(context, 'success');
        Get.back();
      }
    });
    final image = ref.watch(imageProvider);
    final crud = ref.watch(crudProvider);

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
                    'Add Post',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                gapH10,
                gapH10,
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: 'title',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                ),
                gapH10,
                TextFormField(
                  controller: DetailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Details';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Details',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                ),
                gapH10,
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
                        if (image == null) {
                          ShowSnack.showErrorSnack(
                              context, 'Please select an image!');
                        } else {
                          ref.read(crudProvider.notifier).addPost(
                              title: titleController.text.trim(),
                              detail: DetailController.text.trim(),
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              image: image);
                          Get.back();
                        }
                      }
                    },
                    child: crud.isLoad
                        ? Center(child: CircularProgressIndicator())
                        : Text('Add Post')),
                gapH20,
              ],
            ),
          ),
        ),
      )),
    );
  }
}
