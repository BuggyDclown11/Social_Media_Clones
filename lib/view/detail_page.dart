import 'package:fireapp/common/show_snackbar.dart';
import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/model/post_model.dart';
import 'package:fireapp/provider/crud_provider.dart';
import 'package:fireapp/services/crud_sevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DetailPage extends StatelessWidget {
  final Post post;
  final types.User users;
  DetailPage(this.post, this.users);

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(
        builder: (context, ref, child) {
          final allPost = ref.watch(postStream);
          return Column(
            children: [
              Image.network(post.imageUrl),
              TextFormField(
                controller: commentController,
                onFieldSubmitted: (val) {
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
                  commentController.clear();
                },
                decoration: InputDecoration(
                    hintText: 'Add a comment', border: OutlineInputBorder()),
              ),
              gapH10,
              Expanded(
                  child: allPost.when(
                      data: (data) {
                        final thisPost = data.firstWhere(
                            (element) => element.postId == post.postId);
                        return ListView.builder(
                            itemCount: thisPost.comment.length,
                            itemBuilder: ((context, index) {
                              final comment = thisPost.comment[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(comment.image),
                                ),
                                title: Text(comment.username),
                                subtitle: Text(comment.comment),
                              );
                            }));
                      },
                      error: (error, stack) => Text('$error'),
                      loading: () => CircularProgressIndicator()))
            ],
          );
        },
      ),
    ));
  }
}
