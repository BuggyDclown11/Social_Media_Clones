import 'package:fireapp/common/show_snackbar.dart';
import 'package:fireapp/model/post_model.dart';
import 'package:fireapp/provider/crud_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DetailPage extends StatelessWidget {
  final Post post;
  final types.User users;
  DetailPage(this.post, this.users);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Image.network(post.imageUrl),
        Consumer(
          builder: (context, ref, child) {
            return Column(
              children: [
                TextFormField(
                  controller: commentController,
                  onFieldSubmitted: (val) {
                    commentController.clear();
                    if (val.isEmpty) {
                      ShowSnack.showErrorSnack(context, 'Please Add Comment');
                    } else {
                      ref.read(crudProvider.notifier).commentPost(
                          comment: Comment(
                              comment: commentController.text.trim(),
                              image: users.imageUrl!,
                              username: users.firstName!),
                          postId: post.postId);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Add a comment', border: OutlineInputBorder()),
                ),
              ],
            );
          },
        )
      ],
    ));
  }
}

final commentController = TextEditingController();
