import 'dart:io';
import 'package:fireapp/common/show_snackbar.dart';
import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/model/post_model.dart';
import 'package:fireapp/provider/auth_provider.dart';
import 'package:fireapp/provider/common_provider.dart';
import 'package:fireapp/provider/crud_provider.dart';
import 'package:fireapp/services/crud_sevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class UpdatePost extends ConsumerStatefulWidget {
  final Post post;
  UpdatePost(this.post);
  @override
  ConsumerState<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends ConsumerState<UpdatePost> {
  final _form = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    detailController..text = widget.post.detail;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Update Post',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                gapH10,
                gapH10,
                TextFormField(
                  controller: detailController,
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
                        ? Image.network(widget.post.imageUrl)
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
                          ref.read(crudProvider.notifier).updatePost(
                              title: titleController.text.trim(),
                              detail: detailController.text.trim(),
                              postId: widget.post.postId);
                        } else {
                          ref.read(crudProvider.notifier).updatePost(
                              title: titleController.text.trim(),
                              detail: detailController.text.trim(),
                              postId: widget.post.postId,
                              image: image,
                              imageId: widget.post.imageId);
                        }
                        Get.back();
                        ShowSnack.showSuccessSnack(
                            context, 'Post Updated successfully');
                      }
                      if (!_form.currentState!.validate()) {
                        ShowSnack.showErrorSnack(context, 'There is some error.Please try again later');
                      }
                    },
                    child: crud.isLoad
                        ? Center(child: CircularProgressIndicator())
                        : Text('Update Post')),
                gapH20,
              ],
            ),
          ),
        ),
      )),
    );
  }
}
